import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_prototype/project/database/models.dart'; // DateTime currentDate = DateFormat('dd.MM.yyyy').format(DateTime.now()) as DateTime;
import 'package:workout_tracker_prototype/main.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  WorkoutCard Function(BuildContext, int) _itemBuilder(List<Workout> workouts) {
    return (BuildContext context, int index) =>
        WorkoutCard(workout: workouts[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("Your Workouts",
            style: TextStyle(fontSize: 21.sp, color: Colors.brown[600])),
      ),
      body: StreamBuilder<List<Workout>>(
        stream: objectbox.getWorkouts(),
        builder: (context, snapshot) {
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
        },
      ),
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final workout;

  const WorkoutCard({Key? key, this.workout}) : super(key: key);

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
                              fontSize: 20.sp, fontWeight: FontWeight.bold))),
                  PopupMenuButton(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.r))),
                      child: Icon(Icons.more_horiz, size: 26.sp),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.h, horizontal: 10.w),
                        value: 1,
                        onTap: () {
                          objectbox.workoutBox.remove(widget.workout.id);
                        },
                        child: SizedBox(
                          width: 90.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 24.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text("Remove", style: TextStyle(fontSize: 16.sp),),
                            ],
                          ),
                        ),
                      )
                    ],
                    // offset: const Offset(0, 30))
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
                  itemCount: widget.workout.exercises.length,
                  itemBuilder: (context, index) {
                    String key = widget.workout.exercises.keys.elementAt(index);
                    String name = key;
                    if (name.length > 15) {
                      name = "${key.substring(0, 15)}..";
                    }
                    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
                    String editedWeight = widget
                        .workout.exercises[key]["weight"]
                        .toString()
                        .replaceAll(regex, '');
                    return Wrap(
                      children: [
                        Row(
                          children: [
                            Text(
                              "${(index + 1).toString()}. $name ",
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            Spacer(),
                            Text(
                              "${editedWeight}kg "
                              "${widget.workout.exercises[key]["reps"]}x"
                              "${widget.workout.exercises[key]["sets"]}",
                              style: TextStyle(fontSize: 20.sp),
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
}
