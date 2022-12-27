import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/project/app_pages/exercises.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final List<Widget> _exercises = [];

  @override
  Widget build(BuildContext context) {
    Widget popupMenuButton = PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("Remove exercise"),
        )
      ],
      offset: const Offset(0, 55),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Add Workout", style: TextStyle(fontSize: 21.sp)),
        actions: <Widget>[
          IconButton(
            tooltip: "Save workout",
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
          popupMenuButton
        ],
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) => _exercises[index],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _exercises.add(const ExerciseCard());
          });
        },
        tooltip: "Add exercise",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  const ExerciseCard({Key? key}) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  String? exercise;

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
                // final chosenExercise = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const Exercises(),
                //     ));
                final chosenExercise = await Navigator.of(context).push(_routeToExercises());
                setState(() {
                  exercise = chosenExercise;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(exercise ?? "Exercise",
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
      pageBuilder: (context, animation, secondaryAnimation) => const Exercises(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
