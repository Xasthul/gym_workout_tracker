import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, widget.exercise.name),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.r),
        child: Card(
            elevation: 2,
            color: Colors.amber[200],
            child: Slidable(
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (item) => renameExercise(context, widget.exercise),
                    flex: 7,
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Rename',
                  ),
                  SlidableAction(
                    onPressed: (item) => deleteExercise(context, widget.exercise),
                    flex: 6,
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.r),
                        bottomRight: Radius.circular(5.r)),
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(title: Text(widget.exercise.name)),
            )),
      ),
    );
  }

  void renameExercise(BuildContext context, Exercise exercise) {
    // TODO: exercise rename function
    // create new dialog for exercise renaming, receive controller.text as argument, then change exercise name as written bellow
    // exercise.name = "renamed";
    // objectbox.exerciseBox.put(exercise);
  }

  void deleteExercise(BuildContext context, Exercise exercise) {
    objectbox.exerciseBox.remove(exercise.id);
  }

}
