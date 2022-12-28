import 'package:objectbox/objectbox.dart';
import 'dart:convert';

@Entity()
class Exercise {
  @Id()
  int id = 0;

  String name;
  Map<DateTime, int>? oneRepMax;

  Exercise(this.name);

  void addNewOneRepMax(DateTime dateTime, int weight, int reps) {
    int newOneRepMax = (weight * (1 + 0.0333 * reps)).toInt(); // formula
    oneRepMax![dateTime] = newOneRepMax;
  }
}

@Entity()
class Workout {
  @Id()
  int id = 0;

  DateTime dateTimeOfWorkout;
  Map<String, dynamic>? exercises; // Map<String, Map<String, int>>

  Workout(this.dateTimeOfWorkout);

  String? get dbExercises =>
      exercises == null ? null : json.encode(exercises);

  set dbExercises(String? value) {
    if (value == null) {
      exercises = null;
    } else {
      exercises = Map.from(
          json.decode(value).map((k, v) => MapEntry(k as String, v as dynamic)));
    }
  }
}
