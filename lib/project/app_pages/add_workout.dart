import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/project/app_pages/exercises.dart';

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
        title: const Text("Add Workout", style: TextStyle(fontSize: 21)),
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
      margin: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 25.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 32.0),
        child: SizedBox(
          height: 130,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final chosenExercise = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Exercises(),
                      ));
                  setState(() {
                    exercise = chosenExercise;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(exercise ?? "Exercise",
                              style: const TextStyle(fontSize: 20))),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          labelText: "Weight",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("kg", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 65,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          labelText: "Reps",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("X"),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          labelText: "Sets",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
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
}
