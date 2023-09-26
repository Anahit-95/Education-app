import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:educational_app/src/notifications/data/datasources/notification_remote_data_src.dart';
import 'package:educational_app/src/notifications/data/models/notification_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late NotificationRemoteDataSrc remoteDataSrc;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;

  setUp(() async {
    firestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    remoteDataSrc = NotificationRemoteDataSrcImpl(
      firestore: firestore,
      auth: auth,
    );
  });

  Future<QuerySnapshot<DataMap>> getNotifications() async => firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('notifications')
      .get();

  Future<DocumentReference> addNotification(
      NotificationModel notification) async {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notifications')
        .add(notification.toMap());
  }

  group('sendNotification', () {
    test('should upload a [Notification] to the specified user', () async {
      const secondUID = 'second_uid';
      for (var i = 0; i < 2; i++) {
        await firestore
            .collection('users')
            .doc(i == 0 ? auth.currentUser!.uid : secondUID)
            .set(
              const LocalUserModel.empty()
                  .copyWith(
                    uid: i == 0 ? auth.currentUser!.uid : secondUID,
                    email: i == 0 ? auth.currentUser!.email : 'second email',
                    fullName:
                        i == 0 ? auth.currentUser!.displayName : 'second name',
                  )
                  .toMap(),
            );
      }
      final notification = NotificationModel.empty().copyWith(
        id: '1',
        title: 'Test unique title, cannot be duplicated',
        body: 'Test',
      );

      await remoteDataSrc.sendNotification(notification);

      final user1NotificationsRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .get();
      final user2NotificationsRef = await firestore
          .collection('users')
          .doc(secondUID)
          .collection('notifications')
          .get();

      expect(user1NotificationsRef.docs, hasLength(1));
      expect(
        user1NotificationsRef.docs.first.data()['title'],
        equals(notification.title),
      );
      expect(user2NotificationsRef.docs, hasLength(1));
      expect(
        user2NotificationsRef.docs.first.data()['title'],
        equals(notification.title),
      );
    });
  });

  group('getNotifications', () {
    test(
      'should return a [Stream<List<Notification>>] when the call '
      'is successful',
      () async {
        // Arrange
        final userId = auth.currentUser!.uid;
        await firestore
            .collection('users')
            .doc(userId)
            .set(const LocalUserModel.empty().copyWith(uid: userId).toMap());

        final expectedNotifications = [
          NotificationModel.empty(),
          NotificationModel.empty().copyWith(
            id: '1',
            sentAt: DateTime.now().add(
              const Duration(seconds: 50),
            ),
          ),
        ];
        for (final notification in expectedNotifications) {
          await addNotification(notification);
        }
        // Act
        final result = remoteDataSrc.getNotifications();

        // Assert
        expect(result, emitsInOrder([equals(expectedNotifications.reversed)]));
      },
    );

    test('should return a stream of empty list when an error occurs', () async {
      final result = remoteDataSrc.getNotifications();
      expect(result, emits(equals(<NotificationModel>[])));
    });
  });

  group('clear', () {
    test('should delete the specified [Notification] from the database',
        () async {
      // Create notification sub-collection for current user
      final firstDocRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .add(NotificationModel.empty().toMap());
      // Add notification to the sub-collection
      final notification = NotificationModel.empty().copyWith(id: '1');
      final docRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .add(notification.toMap());

      final collection = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .get();
      // Assert that the notification was added
      expect(collection.docs, hasLength(2));

      // Act
      await remoteDataSrc.clear(docRef.id);
      final secondNotificationDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .doc(docRef.id)
          .get();

      final firstNotificationDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .doc(firstDocRef.id)
          .get();

      // Assert that the notification was deleted
      expect(firstNotificationDoc.exists, isTrue);
      expect(secondNotificationDoc.exists, isFalse);
    });
  });

  group('clearAll', () {
    test(
        "should delete every notification in the current user's sub-collection",
        () async {
      for (var i = 0; i < 5; i++) {
        await addNotification(
          NotificationModel.empty().copyWith(id: i.toString()),
        );
      }

      final collection = await getNotifications();
      // Assert that the notifications were added
      expect(collection.docs, hasLength(5));

      // Act
      await remoteDataSrc.clearAll();
      final notificationDocs = await getNotifications();

      // Assert that the notifications were deleted

      expect(notificationDocs.docs, isEmpty);
    });
  });

  group('markAsRead', () {
    test(
      'should mark the specified notification as read',
      () async {
        var tId = '';
        for (var i = 0; i < 5; i++) {
          final docRef = await addNotification(
            NotificationModel.empty().copyWith(
              id: i.toString(),
              seen: i.isEven,
            ),
          );
          if (i == 1) {
            tId = docRef.id;
          }
        }
        final collection = await getNotifications();
        // Assert that the notifications were addded
        expect(collection.docs, hasLength(5));

        // Act
        await remoteDataSrc.markAsRead(tId);
        final notificationDoc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .doc(tId)
            .get();

        // Assert that the notification was marked as read
        expect(notificationDoc.data()!['seen'], isTrue);
      },
    );
  });
}
