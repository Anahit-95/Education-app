import 'package:educational_app/core/common/features/course/data/datasources/course_remote_data_src.dart';
import 'package:educational_app/core/common/features/course/data/models/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late CourseRemoteDataSrc remoteDataSrc;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

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

    storage = MockFirebaseStorage();

    remoteDataSrc = CourseRemoteDataSrcImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );
  });

  group('addCourse', () {
    test(
      'should add the given course to the firestore collection',
      () async {
        // Arrenge
        final course = CourseModel.empty();

        // Act
        await remoteDataSrc.addCourse(course);

        // Assert
        final firestoreData = await firestore.collection('courses').get();
        expect(firestoreData.docs.length, 1);

        final courseRef = firestoreData.docs.first;
        expect(courseRef.data()['id'], courseRef.id);

        final groupData = await firestore.collection('groups').get();
        expect(groupData.docs.length, 1);

        final groupRef = groupData.docs.first;
        expect(groupRef.data()['id'], groupRef.id);

        expect(courseRef.data()['groupId'], groupRef.id);
        expect(groupRef.data()['courseId'], courseRef.id);
      },
    );
  });

  group('getCources', () {
    test('should return a List<Course> when the call is successful', () async {
      // Arrange
      final firstDate = DateTime.now();
      final secondDate = DateTime.now();

      final expectedCourses = [
        CourseModel.empty().copyWith(createdAt: firstDate),
        CourseModel.empty().copyWith(
          createdAt: secondDate,
          id: '1',
          title: 'Course 1',
        ),
      ];

      for (final course in expectedCourses) {
        await firestore.collection('courses').add(course.toMap());
      }
      // Act
      final result = await remoteDataSrc.getCourses();

      // Assert
      expect(result, expectedCourses);
    });
  });
}
