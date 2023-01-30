import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracker_prototype/objectbox.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/classes/custom_toast.dart';
import 'package:workout_tracker_prototype/project/classes/custom_dialog.dart';
import 'package:workout_tracker_prototype/project/classes/routes.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  ExerciseWorkoutCard Function(BuildContext, int) _itemBuilder(
      List<AddWorkoutExercise> addWorkoutExercises) {
    return (BuildContext context, int index) =>
        ExerciseWorkoutCard(addWorkoutExercise: addWorkoutExercises[index]);
  }

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
                      onTap: clearWorkout,
                      child: const Text("Clear workout"),
                    )
                  ],
              offset: const Offset(0, 55))
        ],
      ),
      body: StreamBuilder<List<AddWorkoutExercise>>(
        stream: objectbox.getAddWorkoutExercises(),
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty ?? false) {
            return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: _itemBuilder(snapshot.data ?? []));
          } else {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Press ",
                  style: TextStyle(fontSize: 18.sp),
                ),
                Icon(Icons.add, size: 28.sp),
                Text(
                  " to add exercise",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ],
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            objectbox.addWorkoutExerciseBox.put(AddWorkoutExercise());
          });
        },
        tooltip: "Add exercise",
        child: const Icon(Icons.add),
      ),
    );
  }

  void clearWorkout() {
    setState(() {
      objectbox.addWorkoutExerciseBox.removeAll();
    });
  }

  void saveWorkout() {
    DateTime currentDate = DateTime.now();
    final List<Exercise> exercisesOneRepMaxes = [];
    bool unfilledFields = false;
    Map<String, dynamic> newWorkoutMap = {};

    void addWorkoutToDB() {
      if (newWorkoutMap.isNotEmpty) {
        Workout newWorkout = Workout(currentDate);
        newWorkout.exercises = newWorkoutMap;
        objectbox.workoutBox.put(newWorkout);

        objectbox.exerciseBox.putMany(exercisesOneRepMaxes);

        if (!mounted) return;
        customToast(context, "Saved", Colors.greenAccent);
      }

      setState(() {
        objectbox.addWorkoutExerciseBox.removeAll();
      });
    }

    List<AddWorkoutExercise> addWorkoutExercises =
        objectbox.addWorkoutExerciseBox.getAll();
    for (int i = 0; i < addWorkoutExercises.length; i++) {
      // check if all fields are filled
      if (!([
        addWorkoutExercises[i].name,
        addWorkoutExercises[i].weight,
        addWorkoutExercises[i].reps,
        addWorkoutExercises[i].sets
      ].contains(null))) {
        Query<Exercise> query = objectbox.exerciseBox
            .query(Exercise_.name.equals(addWorkoutExercises[i].name!))
            .build();
        Exercise? foundExercise = query.findUnique();
        query.close();

        // Exercise might be deleted
        if (foundExercise != null) {
          foundExercise.addNewOneRepMax(currentDate,
              addWorkoutExercises[i].weight!, addWorkoutExercises[i].reps!);
          exercisesOneRepMaxes.add(foundExercise);

          newWorkoutMap[addWorkoutExercises[i].name!] = {
            "weight": addWorkoutExercises[i].weight,
            "reps": addWorkoutExercises[i].reps,
            "sets": addWorkoutExercises[i].sets
          };
        }
      } else {
        unfilledFields = true;
        continue;
      }
    }

    if (unfilledFields) {
      customDialogError(
          context,
          "You have unfilled fields",
          "Exercises with empty fields will NOT be saved.",
          "Continue",
          addWorkoutToDB);
    } else {
      addWorkoutToDB();
    }
  }
}

class ExerciseWorkoutCard extends StatefulWidget {
  final AddWorkoutExercise addWorkoutExercise;

  const ExerciseWorkoutCard({Key? key, required this.addWorkoutExercise})
      : super(key: key);

  @override
  State<ExerciseWorkoutCard> createState() => _ExerciseWorkoutCardState();
}

class _ExerciseWorkoutCardState extends State<ExerciseWorkoutCard> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  @override
  void initState() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    _weightController.text = widget.addWorkoutExercise.weight != null
        ? widget.addWorkoutExercise.weight.toString().replaceAll(regex, '')
        : "";
    _repsController.text = widget.addWorkoutExercise.reps != null
        ? widget.addWorkoutExercise.reps.toString()
        : "";
    _setsController.text = widget.addWorkoutExercise.sets != null
        ? widget.addWorkoutExercise.sets.toString()
        : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Future.delayed(
            const Duration(seconds: 0),
            () => customDialogError(context, "Remove exercise",
                    "Are you sure to delete this exercise?", "Remove", () {
                  removeExercise(widget.addWorkoutExercise.id);
                }));
      },
      child: Card(
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
                      await Navigator.of(context).push(routeToExercises());
                  setState(() {
                    widget.addWorkoutExercise.name = chosenExercise?.name;
                    objectbox.addWorkoutExerciseBox
                        .put(widget.addWorkoutExercise);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              widget.addWorkoutExercise.name ?? "Exercise",
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
                        widget.addWorkoutExercise.weight =
                            _weightController.text != ""
                                ? double.parse(_weightController.text)
                                : null;
                        objectbox.addWorkoutExerciseBox
                            .put(widget.addWorkoutExercise);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^\d{1,3}\.\d{0,2})|(^\d{1,4})')),
                        // Only one dot with maximum two digits after it
                        // If there is no dot, maximum 4 digits
                      ],
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
                        widget.addWorkoutExercise.reps =
                            _repsController.text != ""
                                ? int.parse(_repsController.text)
                                : null;
                        objectbox.addWorkoutExerciseBox
                            .put(widget.addWorkoutExercise);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
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
                        widget.addWorkoutExercise.sets =
                            _setsController.text != ""
                                ? int.parse(_setsController.text)
                                : null;
                        objectbox.addWorkoutExerciseBox
                            .put(widget.addWorkoutExercise);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
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
      ),
    );
  }

  void removeExercise(int id) {
    setState(() {
      objectbox.addWorkoutExerciseBox.remove(id);
    });
  }
}
