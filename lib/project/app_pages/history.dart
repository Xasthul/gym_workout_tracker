import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/main.dart';
import 'package:workout_tracker_prototype/project/classes/custom_dialog.dart';
import 'package:workout_tracker_prototype/objectbox.g.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TextEditingController searchController = TextEditingController();

  WorkoutCard Function(BuildContext, int) _itemBuilder(List<Workout> workouts) {
    return (BuildContext context, int index) =>
        WorkoutCard(workout: workouts[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Your Workouts"),
            SizedBox(
              width: 150.w,
              height: 45.h,
              child: TextField(
                onChanged: (_) {
                  setState(() {});
                },
                controller: searchController,
                style: TextStyle(fontSize: 18.sp, color: Colors.brown[600]),
                cursorColor: Colors.brown[500],
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 10),
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.brown[600]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.all(Radius.circular(25.r))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.all(Radius.circular(25.r)))),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              FocusNode()); // Hide Search keyboard, when click outside
        },
        child: StreamBuilder<List<Workout>>(
          stream: objectbox.getWorkouts(),
          builder: (context, snapshot) {
            if (searchController.text != "") {
              Query<Workout> query = objectbox.workoutBox
                  .query(Workout_.dbExercises.contains(searchController.text))
                  .order(Workout_.dateOfWorkout, flags: Order.descending)
                  .build();
              List<Workout> workouts = query.find();
              query.close();
              if (workouts.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.r),
                    itemCount: workouts.length,
                    itemBuilder: _itemBuilder(workouts));
              } else {
                return Center(
                    child: Text(
                  "Empty",
                  style: TextStyle(fontSize: 18.sp),
                ));
              }
            } else {
              if (snapshot.data?.isNotEmpty ?? false) {
                return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.r),
                    itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                    itemBuilder: _itemBuilder(snapshot.data ?? []));
              } else {
                return Center(
                    child: Text(
                  "Empty",
                  style: TextStyle(fontSize: 18.sp),
                ));
              }
            }
          },
        ),
      ),
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final Workout workout;

  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(6.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                          DateFormat('EEEE, d MMM.')
                              .format(widget.workout.dateOfWorkout),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold))),
                  PopupMenuButton(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.r))),
                      child: Icon(Icons.more_horiz, size: 24.sp),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.h, horizontal: 10.w),
                        value: 1,
                        onTap: () {
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => customDialogError(
                                  context,
                                  "Delete workout",
                                  "Are you sure to delete the workout? This action cannot be undone.",
                                  "Delete",
                                  removeWorkout));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(Icons.close, color: Colors.red),
                            Text("Delete"),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.workout.exercises!.length,
                  itemBuilder: (context, index) {
                    String key =
                        widget.workout.exercises!.keys.elementAt(index);
                    String name = key;
                    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
                    String editedWeight = widget
                        .workout.exercises![key]["weight"]
                        .toString()
                        .replaceAll(regex, '');

                    const int wholeLineSpace = 24;
                    int spaceForNumbers = editedWeight.length +
                        widget.workout.exercises![key]["reps"]
                            .toString()
                            .length +
                        widget.workout.exercises![key]["sets"]
                            .toString()
                            .length;
                    int spaceForName = wholeLineSpace - spaceForNumbers;
                    if (name.length > spaceForName) {
                      name = "${key.substring(0, (spaceForName))}..";
                    }
                    return Wrap(
                      children: [
                        Row(
                          children: [
                            Text(
                              "${(index + 1).toString()}. $name ",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            const Spacer(),
                            Text(
                              "${editedWeight}kg "
                              "${widget.workout.exercises![key]["reps"]}x"
                              "${widget.workout.exercises![key]["sets"]}",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 5.h)),
            ),
          ],
        ),
      ),
    );
  }

  void removeWorkout() {
    widget.workout.exercises!.forEach((key, value) {
      Query<Exercise> query =
          objectbox.exerciseBox.query(Exercise_.name.equals(key)).build();
      Exercise? exercise = query.findUnique();
      query.close();
      exercise!.oneRepMax!.remove(
          DateFormat('dd.MM.yyyy').format(widget.workout.dateOfWorkout));
      objectbox.exerciseBox.put(exercise);
    });

    objectbox.workoutBox.remove(widget.workout.id);
  }
}
