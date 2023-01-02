class ExerciseInputModel {
  String? name;
  double? weight;
  int? reps;
  int? sets;

  ExerciseInputModel({this.name, this.weight, this.reps, this.sets});

  bool checkNullValues() {
    return [name, weight, reps, sets].contains(null);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'exerciseName': name,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
    return map;
  }

  static ExerciseInputModel fromMap(Map<String, dynamic> map) {
    return ExerciseInputModel(
      name: map['exerciseName'],
      weight: map['weight'],
      reps: map['reps'],
      sets: map['sets'],
    );
  }
}
