import 'package:dartz/dartz.dart';
import 'package:educational_app/src/course/features/videos/domain/entities/video.dart';
import 'package:educational_app/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:educational_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repo.mock.dart';

void main() {
  late VideoRepo repo;
  late GetVideos usecase;

  setUp(() {
    repo = MockVideoRepo();
    usecase = GetVideos(repo);
  });

  test('should call [VideoRepo.addValue]', () async {
    when(
      () => repo.getVideos(any()),
    ).thenAnswer((_) async => const Right([]));

    final result = await usecase('test_id');

    expect(result, isA<Right<dynamic, List<Video>>>());

    verify(() => repo.getVideos('test_id')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
