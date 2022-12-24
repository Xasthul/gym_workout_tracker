import 'package:flutter/material.dart';

//   Map<String, dynamic> workouts =
//   {"21.12.22" : {
//     "benchpress" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "squats" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "deadlift" : {"weight" : 55, "sets" : 4, "reps" : 8}},
//   "23.12.22" : {
//     "benchpress" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "squats" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "deadlift" : {"weight" : 55, "sets" : 4, "reps" : 8}},
//   "22.12.22" : {
//     "benchpress" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "squats" : {"weight" : 55, "sets" : 4, "reps" : 8},
//     "deadlift" : {"weight" : 55, "sets" : 4, "reps" : 8}}};

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text("Your Workouts", style: TextStyle(fontSize: 21)),
        //centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Search",
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Remove",
            icon: const Icon(Icons.delete),
            onPressed: () {},
          )
        ],
      ),
      body: WorkoutContainer(),
      );
  }
}

class WorkoutContainer extends StatefulWidget {
  const WorkoutContainer({Key? key}) : super(key: key);

  @override
  State<WorkoutContainer> createState() => _WorkoutContainerState();
}

class _WorkoutContainerState extends State<WorkoutContainer> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
