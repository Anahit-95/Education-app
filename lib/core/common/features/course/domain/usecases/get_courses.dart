import 'package:educational_app/core/common/features/course/domain/entities/course.dart';
import 'package:educational_app/core/common/features/course/domain/repos/cource_repo.dart';
import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';

class GetCourses extends UsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<List<Course>> call() async => _repo.getCourses();
}
