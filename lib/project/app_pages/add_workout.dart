import 'package:flutter/material.dart';


class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {

  @override
  Widget build(BuildContext context) {
    Widget popupMenuButton =
      PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text("Add new exercise"),
          )
        ],
        offset: const Offset(0, 60),
      );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text("Add Workout", style: TextStyle(fontSize: 21)),
        actions: <Widget>[
          popupMenuButton
        ],
      ),
    );
  }
}
