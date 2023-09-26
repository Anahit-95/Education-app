import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/notifications/data/datasources/notification_remote_data_src.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:educational_app/src/notifications/data/repos/notification_repo_impl.dart';
import 'package:educational_app/src/notifications/domain/entities/notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRemoteDataSrc extends Mock
    implements NotificationRemoteDataSrc {}

void main() {
  late NotificationRemoteDataSrc remoteDataSrc;
  late NotificationRepoImpl repoImpl;

  final tNotification = NotificationModel.empty();
  const tException = ServerException(
    message: 'message',
    statusCode: 'statusCode',
  );

  setUp(() {
    remoteDataSrc = MockNotificationRemoteDataSrc();
    repoImpl = NotificationRepoImpl(remoteDataSrc);
  });

  group('clear', () {
    test(
      'should complete successfully when the call to remote source '
      'is successful',
      () async {
        when(
          () => remoteDataSrc.clear(any()),
        ).thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repoImpl.clear('notificationId');

        expect(result, const Right<dynamic, void>(null));

        verify(() => remoteDataSrc.clear('notificationId')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote source '
      'is unsuccessful',
      () async {
        when(
          () => remoteDataSrc.clear(any()),
        ).thenThrow(tException);

        final result = await repoImpl.clear('notificationId');

        expect(
          result,
          equals(
            Left<Failure, void>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.clear('notificationId')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('clearAll', () {
    test(
      'should complete successfully when the call to remote source '
      'is successful',
      () async {
        when(
          () => remoteDataSrc.clearAll(),
        ).thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repoImpl.clearAll();

        expect(result, const Right<dynamic, void>(null));

        verify(() => remoteDataSrc.clearAll()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote source '
      'is unsuccessful',
      () async {
        when(
          () => remoteDataSrc.clearAll(),
        ).thenThrow(tException);

        final result = await repoImpl.clearAll();

        expect(
          result,
          equals(
            Left<Failure, void>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.clearAll()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('markAsRead', () {
    test(
      'should complete successfully when the call to remote source '
      'is successful',
      () async {
        when(
          () => remoteDataSrc.markAsRead(any()),
        ).thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repoImpl.markAsRead('notificationId');

        expect(result, const Right<dynamic, void>(null));

        verify(() => remoteDataSrc.markAsRead('notificationId')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote source '
      'is unsuccessful',
      () async {
        when(
          () => remoteDataSrc.markAsRead(any()),
        ).thenThrow(tException);

        final result = await repoImpl.markAsRead('notificationId');

        expect(
          result,
          equals(
            Left<Failure, void>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.markAsRead('notificationId')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('sendNotification', () {
    setUp(() => registerFallbackValue(tNotification));
    test(
      'should complete successfully when the call to remote source '
      'is successful',
      () async {
        when(
          () => remoteDataSrc.sendNotification(any()),
        ).thenAnswer((_) async => const Right<dynamic, void>(null));

        final result = await repoImpl.sendNotification(tNotification);

        expect(result, const Right<dynamic, void>(null));

        verify(() => remoteDataSrc.sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should return [ServerFailure] when the call to remote source '
      'is unsuccessful',
      () async {
        when(
          () => remoteDataSrc.sendNotification(any()),
        ).thenThrow(tException);

        final result = await repoImpl.sendNotification(tNotification);

        expect(
          result,
          equals(
            Left<Failure, void>(ServerFailure.fromException(tException)),
          ),
        );

        verify(() => remoteDataSrc.sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });

  group('getNotifications', () {
    test(
      'should emit a [List<Notification>] when call to remote source is '
      'successful',
      () async {
        final notifications = [NotificationModel.empty()];
        when(
          () => remoteDataSrc.getNotifications(),
        ).thenAnswer((_) => Stream.value(notifications));

        final result = repoImpl.getNotifications();

        expect(
          result,
          emits(Right<dynamic, List<Notification>>(notifications)),
        );

        verify(() => remoteDataSrc.getNotifications()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
      'should emit a [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSrc.getNotifications(),
        ).thenAnswer((_) => Stream.error(tException));

        final result = repoImpl.getNotifications();

        expect(
          result,
          emits(
            Left<ServerFailure, dynamic>(
              ServerFailure.fromException(tException),
            ),
          ),
        );

        verify(() => remoteDataSrc.getNotifications()).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );
  });
}
