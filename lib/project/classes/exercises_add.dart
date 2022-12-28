import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';

class ExercisesAdd extends StatefulWidget {
  const ExercisesAdd({Key? key}) : super(key: key);

  @override
  State<ExercisesAdd> createState() => _ExercisesAddState();
}

class _ExercisesAddState extends State<ExercisesAdd> {
  final TextEditingController _controller = TextEditingController();

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
        openDialog();
      },
      icon: const Icon(Icons.add),
    );
  }

  void openDialog() => showDialog<String>(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("New exercise", style: TextStyle(fontSize: 18.sp)),
                      Padding(
                        padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
                        child: TextField(
                          autofocus: true,
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: "Name of exercise",
                              contentPadding: EdgeInsets.all(10.w),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)))),
                          onSubmitted: (_) => submitDialog(),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber[300]),
                        onPressed: submitDialog,
                        child: const Text("Add",
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));

  void submitDialog() {
    if (_controller.text.isEmpty) return;

    Exercise newExercise = Exercise(_controller.text);
    objectbox.exerciseBox.put(newExercise);

    Navigator.of(context).pop();
    _controller.clear();
  }
}
