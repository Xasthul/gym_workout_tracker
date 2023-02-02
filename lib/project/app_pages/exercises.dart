import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/project/classes/exercises_add.dart';
import 'package:workout_tracker_prototype/project/classes/exercises_search.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/project/classes/custom_dialog.dart';
import 'package:workout_tracker_prototype/project/classes/custom_toast.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  ExerciseCard Function(BuildContext, int) _itemBuilder(
      List<Exercise> exercises) {
    return (BuildContext context, int index) =>
        ExerciseCard(exercise: exercises[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
        actions: const [
          ExercisesSearch(),
          ExercisesAdd(),
        ],
      ),
      body: StreamBuilder<List<Exercise>>(
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
            return const Center(child: Text("List is empty"));
          }
        },
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late TextEditingController _renameController;

  @override
  void initState() {
    _renameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, widget.exercise),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 3.h),
        child: Material(
          child: Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (item) => customDialogTextField(
                      context,
                      "Rename exercise",
                      "New name",
                      _renameController,
                      "Rename", () {
                    renameExercise(context, widget.exercise);
                  }),
                  flex: 7,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Rename',
                ),
                SlidableAction(
                  onPressed: (item) => deleteExercise(context, widget.exercise),
                  flex: 6,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.r),
                      bottomRight: Radius.circular(5.r)),
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      bottomLeft: Radius.circular(5.r))),
              child: ListTile(title: Text(widget.exercise.name)),
            ),
          ),
        ),
      ),
    );
  }

  void renameExercise(BuildContext context, Exercise exercise) {
    if (_renameController.text.isEmpty) return;

    exercise.name = _renameController.text;
    objectbox.exerciseBox.put(exercise);
    customToast(context, "Renamed", Colors.greenAccent);
    _renameController.clear();
  }

  void deleteExercise(BuildContext context, Exercise exercise) {
    objectbox.exerciseBox.remove(exercise.id);
  }
}
