import 'package:flutter/material.dart';


class AddWorkout extends StatelessWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text("Add Workout", style: TextStyle(fontSize: 21)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Menu",
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
