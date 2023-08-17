part of pages;

class InboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        leading: IconButton(
          onPressed: () {
            ServiceNavigation.serviceNavi.back();
            // Your navigation logic
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final userDocs = snapshot.data!.docs;

          final currentUserUid =
              Provider.of<AuthController>(context, listen: false)
                  .auth
                  .currentUser!
                  .uid;

          final filteredUserDocs = userDocs.where((userDoc) {
            return userDoc.id != currentUserUid;
          }).toList();

          return ListView.builder(
            itemCount: filteredUserDocs.length,
            itemBuilder: (context, index) {
              final userDoc = filteredUserDocs[index];
              return UserTile(userDoc: userDoc);
            },
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final DocumentSnapshot userDoc;

  UserTile({required this.userDoc});

  String getChatId(String userId1, String userId2) {
    if (userId1.hashCode <= userId2.hashCode) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = userDoc.data() as Map<String, dynamic>;
    final userName = userData['name'] as String;
    final imagePath = userData['imagePath'] ?? "";

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(getChatId(
              Provider.of<AuthController>(context, listen: false)
                  .auth
                  .currentUser!
                  .uid,
              userDoc.id))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ListTile(
            title: Text(
              userName,
              style: TextStyle(color: Colors.blue),
            ),
            subtitle: Text('Error loading message'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    userId: Provider.of<AuthController>(context, listen: false)
                        .auth
                        .currentUser!
                        .uid,
                    recipientId: userDoc.id,
                    recipientName: userName,
                  ),
                ),
              );
            },
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(
                imagePath,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Image.asset(ImageAssets.app_icon),
              ),
            ),
            title: Text(
              userName,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text('No messages'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    // imagePath: imagePath,
                    userId: Provider.of<AuthController>(context, listen: false)
                        .auth
                        .currentUser!
                        .uid,
                    recipientId: userDoc.id,
                    recipientName: userName,
                  ),
                ),
              );
            },
          );
        }

        final messageData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final lastMessage = messageData['text'] as String;
        final Timestamp timestamp =
            messageData['timestamp'] as Timestamp? ?? Timestamp.now();

        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(
              imagePath,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Image.asset(ImageAssets.app_icon),
            ),
          ),
          title: Text(
            userName,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastMessage,
                maxLines: 1,
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${timestamp.toFormattedString()}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  userId: Provider.of<AuthController>(context, listen: false)
                      .auth
                      .currentUser!
                      .uid,
                  recipientId: userDoc.id,
                  recipientName: userName,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
