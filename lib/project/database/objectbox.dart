import 'models.dart';
import 'package:workout_tracker_prototype/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  late final Box<Exercise> exerciseBox;
  late final Box<Workout> workoutBox;

  ObjectBox._create(this.store) {
    exerciseBox = Box<Exercise>(store);
    workoutBox = Box<Workout>(store);

    if (exerciseBox.isEmpty()) {
      _putDemoData();
    }
  }

  void _putDemoData() {
    Exercise benchPress = Exercise("Bench Press");
    Exercise deadlift = Exercise("Deadlift");
    Exercise squats = Exercise("Squats");
    for (var exercise in [benchPress, deadlift, squats]) {
      exercise.oneRepMax = {};
    }

    exerciseBox.putMany([benchPress, deadlift, squats]);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  Stream<List<Exercise>> getExercises() {
    final builder = exerciseBox.query()
      ..order(Exercise_.id); // flags: Order.descending
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Workout>> getWorkouts() {
    final builder = workoutBox.query()
      ..order(Workout_.id); // flags: Order.descending
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
