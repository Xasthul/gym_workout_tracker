import 'package:flutter/material.dart';


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
        centerTitle: true,
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
      );
  }
}
