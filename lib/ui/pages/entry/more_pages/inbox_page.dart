part of pages;

class InboxPage extends StatelessWidget {
   InboxPage({Key? key}) : super(key: key);

  final List<InboxModel> inboxes = InboxModel.inboxes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        leading: IconButton(onPressed: (){ServiceNavigation.serviceNavi.back();}, icon: const Icon(Icons.arrow_back_ios_new_outlined),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: inboxes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context , index) {
            final inbox = inboxes[index];
            return InboxTile(title: inbox.title, supTitle: inbox.content, date: inbox.date, isRead: inbox.isRead);
          },

        ),
      ),
    );
  }
}


