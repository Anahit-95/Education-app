import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:educational_app/src/notifications/domain/usecases/clear.dart';
import 'package:educational_app/src/notifications/domain/usecases/clear_all.dart';
import 'package:educational_app/src/notifications/domain/usecases/get_notifications.dart';
import 'package:educational_app/src/notifications/domain/usecases/mark_as_read.dart';
import 'package:educational_app/src/notifications/domain/usecases/send_notification.dart';
import 'package:educational_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClear extends Mock implements Clear {}

class MockClearAll extends Mock implements ClearAll {}

class MockGetNotifications extends Mock implements GetNotifications {}

class MockMarkAsRead extends Mock implements MarkAsRead {}

class MockSendNotification extends Mock implements SendNotification {}

void main() {
  late NotificationCubit cubit;
  late Clear clear;
  late ClearAll clearAll;
  late GetNotifications getNotifications;
  late MarkAsRead markAsRead;
  late SendNotification sendNotification;

  setUp(() {
    clear = MockClear();
    clearAll = MockClearAll();
    getNotifications = MockGetNotifications();
    markAsRead = MockMarkAsRead();
    sendNotification = MockSendNotification();
    cubit = NotificationCubit(
      clear: clear,
      clearAll: clearAll,
      getNotifications: getNotifications,
      markAsRead: markAsRead,
      sendNotification: sendNotification,
    );
  });

  tearDown(() => cubit.close());

  final tFailure = ServerFailure(message: 'Server Error', statusCode: '500');

  test('initial state is NotificationInitial', () {
    expect(cubit.state, const NotificationInitial());
  });

  group('clear', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[ClearingNotifications, NotificationCleared] when successful',
      build: () {
        when(
          () => clear(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => const <NotificationState>[
        ClearingNotifications(),
        NotificationCleared(),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(
          () => clear(any()),
        ).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => <NotificationState>[
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );
  });

  group('clearAll', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[ClearingNotifications, NotificationCleared] when successful',
      build: () {
        when(
          () => clearAll(),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => const <NotificationState>[
        ClearingNotifications(),
        NotificationCleared(),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(
          () => clearAll(),
        ).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => <NotificationState>[
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );
  });

  group('markAsRead', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[NotificationInitial] when successful',
      build: () {
        when(
          () => markAsRead(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => const <NotificationState>[
        NotificationInitial(),
      ],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[NotificationError] when unsuccessful',
      build: () {
        when(
          () => markAsRead(any()),
        ).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => <NotificationState>[
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );
  });

  group('sendNotification', () {
    final tNotification = NotificationModel.empty();
    setUp(() => registerFallbackValue(tNotification));

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[SendingNotification, NotificationSent] when successful',
      build: () {
        when(
          () => sendNotification(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => const <NotificationState>[
        SendingNotification(),
        NotificationSent(),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[SendingNotification, NotificationError] when unsuccessful',
      build: () {
        when(
          () => sendNotification(any()),
        ).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => <NotificationState>[
        const SendingNotification(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );
  });

  group('getNotifications', () {
    final tNotifications = [NotificationModel.empty()];
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[GettingNotifications, NotificationsLoaded] when successful',
      build: () {
        when(
          () => getNotifications(),
        ).thenAnswer((_) => Stream.value(Right(tNotifications)));
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => <NotificationState>[
        const GettingNotifications(),
        NotificationsLoaded(tNotifications),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
      '[GettingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(
          () => getNotifications(),
        ).thenAnswer((_) => Stream.value(Left(tFailure)));
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => <NotificationState>[
        const GettingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
  });

  // group('getNotifications', () {
  //   final tNotification = NotificationModel.empty();

  //   test(
  //     'should return [Stream<Either<NotificationError, List<Notification>>>] '
  //     'when successful',
  //     () async {
  //       when(
  //         () => getNotifications(),
  //       ).thenAnswer((_) => Stream.value(Right([tNotification])));

  //       final result = cubit.getNotifications();
  //       expect(
  //         result,
  //         isA<Stream<Either<NotificationError, List<Notification>>>>(),
  //       );

  //       verify(() => getNotifications()).called(1);
  //       verifyNoMoreInteractions(getNotifications);
  //     },
  //   );

  //   test(
  //     'should return [Stream<Either<NotificationError, List<Notification>>>] '
  //     'when unsuccessful',
  //     () async {
  //       when(
  //         () => getNotifications(),
  //       ).thenAnswer((_) => Stream.value(Left(tFailure)));

  //       final result = cubit.getNotifications();
  //       expect(
  //         result,
  //         isA<Stream<Either<NotificationError, List<Notification>>>>(),
  //       );

  //       verify(() => getNotifications()).called(1);
  //       verifyNoMoreInteractions(getNotifications);
  //     },
  //   );
  // });
}
