import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/notifications/domain/entities/notification.dart';
import 'package:educational_app/src/notifications/domain/repos/notification_repo.dart';

class GetNotifications extends StreamUsecaseWithoutParams<List<Notification>> {
  const GetNotifications(this._repo);

  final NotificationRepo _repo;

  @override
  ResultStream<List<Notification>> call() => _repo.getNotifications();
}
