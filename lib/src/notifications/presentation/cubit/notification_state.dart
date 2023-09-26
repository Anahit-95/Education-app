part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class ClearingNotifications extends NotificationState {
  const ClearingNotifications();
}

class SendingNotification extends NotificationState {
  const SendingNotification();
}

class NotificationSent extends NotificationState {
  const NotificationSent();
}

class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
