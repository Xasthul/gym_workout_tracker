import 'package:flutter/material.dart';


class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  static const menuItems = <String>['Add exercise'];

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final List<PopupMenuItem<String>> _popupMenuItems = AddWorkout.menuItems.map(
      (String value) => PopupMenuItem<String>(
        value: value,
          child: Text(value))
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text("Add Workout", style: TextStyle(fontSize: 21)),
        //centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 1,
                  child: Text("Add new exercise"),
                  )
            ],
            offset: const Offset(0, 60),
          )
          // IconButton(
          //   tooltip: "Menu",
          //   icon: const Icon(Icons.more_vert),
          //   onPressed: () {},
          // )
        ],
      ),
    );
  }
}
