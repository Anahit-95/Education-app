import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:educational_app/src/notifications/domain/entities/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class NotificationRemoteDataSrc {
  const NotificationRemoteDataSrc();

  Future<void> markAsRead(String notificationId);

  Future<void> clearAll();

  Future<void> clear(String notificationId);

  Future<void> sendNotification(Notification notification);

  Stream<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSrcImpl implements NotificationRemoteDataSrc {
  NotificationRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> clear(String notificationId) {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  Stream<List<NotificationModel>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> markAsRead(String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> sendNotification(Notification notification) {
    // TODO: implement sendNotification
    throw UnimplementedError();
  }
}
