import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/enums/notification_enum.dart';
import 'package:educational_app/core/extensions/enum_extension.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/notifications/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.category,
    required super.sentAt,
    super.seen,
  });

  NotificationModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          body: '_empty.body',
          category: NotificationCategory.NONE,
          seen: false,
          sentAt: DateTime.now(),
        );

  NotificationModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          body: map['body'] as String,
          category: (map['category'] as String).toNotificationCategory,
          seen: map['seen'] as bool,
          sentAt: (map['sentAt'] as Timestamp).toDate(),
        );

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category.value,
      'seen': seen,
      'sentAt': FieldValue.serverTimestamp(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    bool? seen,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      seen: seen ?? this.seen,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}