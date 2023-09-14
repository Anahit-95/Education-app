import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/domain/entities/course.dart';

abstract class CourseRepo {
  const CourseRepo();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);
}
