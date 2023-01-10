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
        backgroundColor: Colors.blue[400],
        title: Text("Your Workouts", style: TextStyle(fontSize: 21.sp)),
        //centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Search",
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Remove",
            icon: const Icon(Icons.delete),
            onPressed: () {},
          )
        ],
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
              "No Workouts yet",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
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
              padding: EdgeInsets.only(left: 5.w),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                          DateFormat('EEEE, d MMM.')
                              .format(widget.workout.dateOfWorkout),
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold))),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      color: Colors.lightBlue[200],
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: 28.sp,
                    ),
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
                              "${(index + 1).toString()}. $key ",
                              style: TextStyle(fontSize: 20.sp),
                            ),
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
