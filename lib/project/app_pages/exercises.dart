import 'package:flutter/material.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text("Exercises", style: TextStyle(fontSize: 21)),
        actions: [
          IconButton(
            tooltip: "Search",
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
              tooltip: "Add new exercise",
              onPressed: () {},
              icon: const Icon(Icons.add),
          ),

        ],
        //centerTitle: true,
      ),
    );
  }
}

