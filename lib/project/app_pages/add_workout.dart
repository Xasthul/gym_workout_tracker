import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/objectbox.g.dart';
import 'package:workout_tracker_prototype/project/app_pages/exercises.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/project/classes/exercise_input_model.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/classes/custom_toast.dart';
import 'package:workout_tracker_prototype/project/classes/custom_dialog.dart';
import 'package:intl/intl.dart';

List<ExerciseInputModel> exerciseModels = [];

class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final List<Widget> _exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Add Workout", style: TextStyle(fontSize: 21.sp)),
        actions: <Widget>[
          IconButton(
            tooltip: "Save workout",
            icon: const Icon(Icons.check),
            onPressed: saveWorkout,
          ),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      onTap: removeExercise,
                      child: const Text("Remove exercise"),
                    )
                  ],
              offset: const Offset(0, 55))
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) => _exercises[index],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _exercises.add(const ExerciseWorkoutCard());
          });
        },
        tooltip: "Add exercise",
        child: const Icon(Icons.add),
      ),
    );
  }

  void removeExercise() {}

  void saveWorkout() {
    DateTime currentDate = DateTime.now();
    String workoutDate = DateFormat('dd.MM.yyyy').format(currentDate);
    final List<Exercise> exercisesOneRepMaxes = [];
    bool unfilledFields = false;
    Map<String, dynamic> newWorkoutMap = {};

    void addWorkoutToDB() {
      if (newWorkoutMap.isNotEmpty) {
        Workout newWorkout = Workout(workoutDate);
        newWorkout.exercises = newWorkoutMap;
        objectbox.workoutBox.put(newWorkout);

        objectbox.exerciseBox.putMany(exercisesOneRepMaxes);

        if (!mounted) return;
        customToast(context, "Saved", Colors.greenAccent);
      }

      exerciseModels.clear();
      setState(() {
        _exercises.clear();
      });
    }

    for (int i = 0; i < exerciseModels.length; i++) {
      // check if all fields are filled
      if (!exerciseModels[i].checkNullValues()) {
        Query<Exercise> query = objectbox.exerciseBox
            .query(Exercise_.name.equals(exerciseModels[i].name!))
            .build();
        Exercise? foundExercise = query.findUnique();
        query.close();

        // Exercise might be deleted
        if (foundExercise != null) {
          foundExercise.addNewOneRepMax(
              currentDate, exerciseModels[i].weight!, exerciseModels[i].reps!);
          exercisesOneRepMaxes.add(foundExercise);

          newWorkoutMap[exerciseModels[i].name!] = {
            "weight": exerciseModels[i].weight,
            "reps": exerciseModels[i].reps,
            "sets": exerciseModels[i].sets
          };
        }
      } else {
        unfilledFields = true;
        continue;
      }
    }

    if (unfilledFields) {
      customDialogError(context, "You have unfilled fields",
          "Exercises with empty fields will NOT be saved.", addWorkoutToDB);
    } else {
      addWorkoutToDB();
    }
  }
}

class ExerciseWorkoutCard extends StatefulWidget {
  const ExerciseWorkoutCard({Key? key}) : super(key: key);

  @override
  State<ExerciseWorkoutCard> createState() => _ExerciseWorkoutCardState();
}

class _ExerciseWorkoutCardState extends State<ExerciseWorkoutCard> {
  final ExerciseInputModel exerciseInputModel = ExerciseInputModel();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  @override
  void initState() {
    exerciseModels.add(exerciseInputModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[200],
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 12.5.h, horizontal: 25.w),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 32.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final chosenExercise =
                    await Navigator.of(context).push(_routeToExercises());
                setState(() {
                  exerciseInputModel.name = chosenExercise;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(exerciseInputModel.name ?? "Exercise",
                            style: TextStyle(fontSize: 20.sp))),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18.sp,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0.8.h,
              color: Colors.black,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  child: TextField(
                    enableInteractiveSelection: false,
                    controller: _weightController,
                    onChanged: (item) {
                      exerciseInputModel.weight = _weightController.text != ""
                          ? double.parse(_weightController.text)
                          : null;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        isDense: true,
                        labelText: "Weight",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)))),
                  ),
                ),
                SizedBox(width: 10.w),
                Text("kg", style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 10.w),
                SizedBox(
                  width: 65.w,
                  child: TextField(
                    enableInteractiveSelection: false,
                    controller: _repsController,
                    onChanged: (item) {
                      exerciseInputModel.reps = _repsController.text != ""
                          ? int.parse(_repsController.text)
                          : null;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        isDense: true,
                        labelText: "Reps",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)))),
                  ),
                ),
                SizedBox(width: 5.w),
                const Text("X"),
                SizedBox(width: 5.w),
                SizedBox(
                  width: 60.w,
                  child: TextField(
                    enableInteractiveSelection: false,
                    controller: _setsController,
                    onChanged: (item) {
                      exerciseInputModel.sets = _setsController.text != ""
                          ? int.parse(_setsController.text)
                          : null;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        isDense: true,
                        labelText: "Sets",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Route _routeToExercises() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Exercises(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
