import 'package:objectbox/objectbox.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

@Entity()
class Exercise {
  @Id()
  int id = 0;

  String name;
  Map<String, double>? oneRepMax;

  Exercise(this.name);

  void addNewOneRepMax(DateTime dateTime, double weight, int reps) {
    String oneRepMaxDate = DateFormat('dd.MM.yyyy').format(dateTime);
    double newOneRepMax = double.parse(
        (weight * (1 + 0.0333 * reps)).toStringAsFixed(2)); // formula
    oneRepMax![oneRepMaxDate] = newOneRepMax;
  }

  String? get dbOneRepMaxes =>
      oneRepMax == null ? null : json.encode(oneRepMax);

  set dbOneRepMaxes(String? value) {
    if (value == null) {
      oneRepMax = null;
    } else {
      oneRepMax = Map.from(
          json.decode(value).map((k, v) => MapEntry(k as String, v as double)));
    }
  }
}

@Entity()
class Workout {
  @Id()
  int id = 0;

  DateTime dateOfWorkout;
  Map<String, dynamic>? exercises; // Map<String, Map<String, int>>

  Workout(this.dateOfWorkout);

  String? get dbExercises => exercises == null ? null : json.encode(exercises);

  set dbExercises(String? value) {
    if (value == null) {
      exercises = null;
    } else {
      exercises = Map.from(json
          .decode(value)
          .map((k, v) => MapEntry(k as String, v as dynamic)));
    }
  }
}
