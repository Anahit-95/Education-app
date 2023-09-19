import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/user_exam.dart';

abstract class ExamRepo {
  const ExamRepo();

  ResultFuture<List<Exam>> getExams(String courseId);

  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam);

  ResultFuture<void> uploadExam(Exam exam);

  ResultFuture<void> updateExam(Exam exam);

  ResultFuture<void> submitExam(UserExam exam);

  ResultFuture<List<UserExam>> getUserExams();

  ResultFuture<List<UserExam>> getUserCourseExams(String courseId);
}
