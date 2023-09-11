import 'package:dartz/dartz.dart';
import 'package:educational_app/core/common/features/course/domain/entities/course.dart';
import 'package:educational_app/core/common/features/course/domain/repos/cource_repo.dart';
import 'package:educational_app/core/common/features/course/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repo.mock.dart';

void main() {
  late CourseRepo repo;
  late AddCourse usecase;

  final tCourse = Course.empty();

  setUp(() {
    repo = MockCourseRepo();
    usecase = AddCourse(repo);
    registerFallbackValue(tCourse);
  });

  test(
    'should call [CourseRepo.addCourse]',
    () async {
      when(
        () => repo.addCourse(any()),
      ).thenAnswer((invocation) async => const Right(null));

      final result = await usecase(tCourse);
      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
