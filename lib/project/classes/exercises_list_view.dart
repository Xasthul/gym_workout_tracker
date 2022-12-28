import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/project/classes/exercise_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  ExerciseCard Function(BuildContext, int) _itemBuilder(
      List<Exercise> exercises) {
    return (BuildContext context, int index) =>
        ExerciseCard(exercise: exercises[index]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>>(
      stream: objectbox.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.r),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: _itemBuilder(snapshot.data ?? [])));
        } else {
          return const Center(
              child: Text("List is empty."));
        }
      },
    );
  }
}
