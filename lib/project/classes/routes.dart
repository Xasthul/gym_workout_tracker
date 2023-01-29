import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/project/database/models.dart';
import 'package:workout_tracker_prototype/project/app_pages/exercises.dart';

Route<Exercise> routeToExercises() {
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