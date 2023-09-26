import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/notifications/domain/repos/notification_repo.dart';

class MarkAsRead extends FutureUsecaseWithParams<void, String> {
  const MarkAsRead(this._repo);

  final NotificationRepo _repo;
  @override
  ResultFuture<void> call(String params) => _repo.markAsRead(params);
}
