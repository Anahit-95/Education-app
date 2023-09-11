import 'package:educational_app/core/common/features/course/domain/entities/course.dart';
import 'package:educational_app/core/common/features/course/domain/repos/cource_repo.dart';
import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<void> call(Course params) async => _repo.addCourse(params);
}
