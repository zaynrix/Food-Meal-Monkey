import 'package:flutter/material.dart';

class DesertsPage extends StatelessWidget {
  const DesertsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Desserts"),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_outlined)),
      ),
    );
  }
}
