import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/src/notifications/domain/entities/notification.dart';
import 'package:educational_app/src/notifications/domain/usecases/clear.dart';
import 'package:educational_app/src/notifications/domain/usecases/clear_all.dart';
import 'package:educational_app/src/notifications/domain/usecases/get_notifications.dart';
import 'package:educational_app/src/notifications/domain/usecases/mark_as_read.dart';
import 'package:educational_app/src/notifications/domain/usecases/send_notification.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(
      {required Clear clear,
      required ClearAll clearAll,
      required GetNotifications getNotifications,
      required MarkAsRead markAsRead,
      required SendNotification sendNotification})
      : _clear = clear,
        _clearAll = clearAll,
        _getNotifications = getNotifications,
        _markAsRead = markAsRead,
        _sendNotification = sendNotification,
        super(const NotificationInitial());

  // NotificationCubit() : super(NotificationInitial());

  final Clear _clear;
  final ClearAll _clearAll;
  final GetNotifications _getNotifications;
  final MarkAsRead _markAsRead;
  final SendNotification _sendNotification;

  Future<void> clear(String notificationId) async {
    emit(const ClearingNotifications());

    final result = await _clear(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationInitial()),
    );
  }

  Future<void> clearAll() async {
    emit(const ClearingNotifications());

    final result = await _clearAll();
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationInitial()),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsRead(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationInitial()),
    );
  }

  Future<void> sendNotification(Notification notification) async {
    emit(const SendingNotification());
    final result = await _sendNotification(notification);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationSent()),
    );
  }

  Stream<Either<NotificationError, List<Notification>>> getNotifications() {
    return _getNotifications().map((result) {
      return result.fold(
        (failure) => Left(NotificationError(failure.errorMessage)),
        Right.new,
      );
    });
  }
}