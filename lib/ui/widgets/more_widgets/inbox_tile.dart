part of widgets;

class InboxTile extends StatelessWidget {
  const InboxTile({
    required this.chatDoc,
    Key? key,
  }) : super(key: key);

  final DocumentSnapshot chatDoc;

  Future<List<String>> fetchParticipantNames(
      List<dynamic> participantUids, String currentUserUid) async {
    try {
      final List<String> participantNames = [];

      for (final uid in participantUids) {
        if (uid != currentUserUid) {
          // Exclude the current user's UID
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            final userName = userData['name'] as String;
            participantNames.add(userName);
          }
        }
      }

      return participantNames;
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final participants = chatData['participants'] as List<dynamic>;

    final TextTheme textTheme = Theme.of(context).textTheme;
    return StreamBuilder(
      stream: chatDoc.reference
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No messages');
        }

        final messageData = snapshot.data!.docs.first.data();
        final lastMessage = messageData['content'] as String;
        final Timestamp lastMessageDate = messageData['timestamp'];
        // User? currentUser = value.auth.currentUser;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p20.w,
            vertical: AppPadding.p12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CustomCircleAvatar(),
                  hSpace5,
                  FutureBuilder<List<String>>(
                    future: fetchParticipantNames(
                        participants,
                        Provider.of<ProfileController>(context)
                            .auth
                            .currentUser!
                            .uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final participantNames = snapshot.data;
                        final participantNamesString =
                            participantNames?.join(', ') ?? '';

                        return Text(
                          participantNamesString, // Display participant names
                          style: textTheme.headline5,
                        );
                      }
                    },
                  ),
                  Spacer(),
                  Text(
                    lastMessageDate
                        .toFormattedString(), // Assuming you have the timestamp extension
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              vSpace15,
              Row(
                children: [
                  hSpace14,
                  Text(
                    lastMessage,
                    style: textTheme.subtitle2,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.star_border,
                    color: orangeColor,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
