part of pages;

class Morepage extends StatefulWidget {
  const Morepage({Key? key}) : super(key: key);

  @override
  State<Morepage> createState() => _MorepageState();
}

class _MorepageState extends State<Morepage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("More"));
  }
}
