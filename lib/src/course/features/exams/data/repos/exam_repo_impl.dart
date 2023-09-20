import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/data/datasources/exam_remote_data_src.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:educational_app/src/course/features/exams/domain/repos/exam_repo.dart';

class ExamRepoImpl implements ExamRepo {
  ExamRepoImpl(this._remoteDataSrc);

  final ExamRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<List<ExamQuestion>> getExamQuestions(Exam exam) async {
    try {
      final result = await _remoteDataSrc.getExamQuestions(exam);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Exam>> getExams(String courseId) async {
    try {
      final result = await _remoteDataSrc.getExams(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserCourseExams(String courseId) async {
    try {
      final result = await _remoteDataSrc.getUserCourseExams(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserExam>> getUserExams() async {
    try {
      final result = await _remoteDataSrc.getUserExams();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> submitExam(UserExam exam) async {
    try {
      await _remoteDataSrc.submitExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateExam(Exam exam) async {
    try {
      await _remoteDataSrc.updateExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> uploadExam(Exam exam) async {
    try {
      await _remoteDataSrc.uploadExam(exam);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
