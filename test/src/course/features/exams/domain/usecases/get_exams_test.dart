import 'package:dartz/dartz.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:educational_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:educational_app/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'exam_repo.mock.dart';

void main() {
  late ExamRepo repo;
  late GetExams usecase;

  setUp(() {
    repo = MockExamRepo();
    usecase = GetExams(repo);
  });

  test(
    'should return [List<Exam>] from the repo',
    () async {
      when(
        () => repo.getExams(any()),
      ).thenAnswer((_) async => const Right([]));

      final result = await usecase('courseId');
      expect(result, equals(const Right<dynamic, List<Exam>>([])));

      verify(() => repo.getExams('courseId')).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
