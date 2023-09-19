import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:educational_app/src/course/features/exams/domain/repos/exam_repo.dart';

class GetExamQuestions extends UsecaseWithParams<List<ExamQuestion>, Exam> {
  const GetExamQuestions(this._repo);
  final ExamRepo _repo;

  @override
  ResultFuture<List<ExamQuestion>> call(Exam params) =>
      _repo.getExamQuestions(params);
}
