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
      expect(user1NotificationsRef.docs.first.data()['title'],
          equals(notification.title));
      expect(user2NotificationsRef.docs, hasLength(1));
    });
  });

  group('getNotifications', () {
    test(
      'should return a [Stream<List<Notification>>] when the call '
      'is successful',
      () async {},
    );
  });
}
