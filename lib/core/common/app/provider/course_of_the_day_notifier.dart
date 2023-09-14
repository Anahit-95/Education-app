import 'package:educational_app/src/course/domain/entities/course.dart';
import 'package:flutter/material.dart';

class CourseOfTheDayNotifier extends ChangeNotifier {
  Course? _courseOfTheDay;

  Course? get courseOfTheDay => _courseOfTheDay;

  void setCourseOfTheDay(Course course) {
    _courseOfTheDay ??= course;
    notifyListeners();
  }
}
