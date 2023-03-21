import 'package:test/test.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:intl/intl.dart';

void main() {
  test('One Rep Max Calculation', () {
    // Test Data
    DateTime currentDate = DateTime.now();
    String oneRepMaxDate = DateFormat('dd.MM.yyyy').format(currentDate);
    double weight = 65.5;
    int reps = 12;

    // Correct value
    final double correctOneRepMax = double.parse((weight * (1 + 0.0333 * reps)).toStringAsFixed(2));

    // Creating object
    final exercise = Exercise("test");
    exercise.oneRepMax = {};

    // Actual value
    exercise.addNewOneRepMax(currentDate, weight, reps);

    // Results
    expect(exercise.oneRepMax![oneRepMaxDate], correctOneRepMax);
  });
}