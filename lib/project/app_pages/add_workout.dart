import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/project/app_pages/exercises.dart';


class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  List<Widget> _exercises = [];

  @override
  Widget build(BuildContext context) {

    Widget popupMenuButton =
      PopupMenuButton(
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
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(25.0, 12.5, 25.0, 12.5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(20.0)
          )
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        child: SizedBox(
          height: 130,
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(
                            builder: (context) => Exercises(),
                        ));
                  },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0 , 0),
                    child: Row(
                      children: const [
                        Expanded(
                            child: Text("Exercise",
                              style: TextStyle(fontSize: 20)
                            )
                        ),
                        Icon(
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
                children: const [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(height: 0.5),
                      decoration: InputDecoration(
                          labelText: "Weight",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("kg"),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 18
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          isDense: true,
                          labelText: "Reps",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("x"),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(height: 0.5),
                      decoration: InputDecoration(
                          labelText: "Sets",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
