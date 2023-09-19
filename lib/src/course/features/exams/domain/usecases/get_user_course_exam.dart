import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:educational_app/src/course/features/exams/domain/repos/exam_repo.dart';

class GetUserCourseExams extends UsecaseWithParams<List<UserExam>, String> {
  const GetUserCourseExams(this._repo);

  final ExamRepo _repo;

  @override
  ResultFuture<List<UserExam>> call(String params) =>
      _repo.getUserCourseExams(params);
}
