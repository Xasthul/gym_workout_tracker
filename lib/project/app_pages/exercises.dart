import 'package:flutter/material.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            onPressed: () async {
              final newExerciseName = await openDialog();
              if (newExerciseName == null || newExerciseName.isEmpty) return;
              setState(() {
                _exercises.add(newExerciseName);
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) => Text(_exercises[index]),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("New exercise"),
            content: TextField(
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(hintText: "Name of exercise"),
              onSubmitted: (_) => submitDialog(),
            ),
            actions: [
              TextButton(
                onPressed: submitDialog,
                child: const Text("Add"),
              )
            ],
          ));

  void submitDialog() {
    Navigator.of(context).pop(_controller.text);

    _controller.clear();
  }
}
