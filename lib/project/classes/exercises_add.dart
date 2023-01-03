import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/objectbox.g.dart';
import 'package:workout_tracker_prototype/project/classes/custom_toast.dart';
import 'package:workout_tracker_prototype/project/classes/custom_dialog.dart';

class ExercisesAdd extends StatefulWidget {
  const ExercisesAdd({Key? key}) : super(key: key);

  @override
  State<ExercisesAdd> createState() => _ExercisesAddState();
}

class _ExercisesAddState extends State<ExercisesAdd> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Add new exercise",
      onPressed: () {
        customDialog(context, "New exercise", "Name of exercise", _controller, "Add", submitDialog);
      },
      icon: const Icon(Icons.add),
    );
  }

  void submitDialog() {
    if (_controller.text.isEmpty) return;

    Query<Exercise> query = objectbox.exerciseBox
        .query(Exercise_.name.equals(_controller.text))
        .build();
    Exercise? foundExercise = query.findUnique();
    query.close();

    if (foundExercise != null) {
      _controller.clear();
      customToast(context, "Exercise already exists", Colors.redAccent);
      return;
    }

    Exercise newExercise = Exercise(_controller.text);
    newExercise.oneRepMax = {};
    objectbox.exerciseBox.put(newExercise);

    _controller.clear();
  }
}
