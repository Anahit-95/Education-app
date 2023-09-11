import 'package:dartz/dartz.dart';
import 'package:educational_app/core/enums/update_user.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:educational_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/auth/domain/repos/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepoImpl repoImpl;
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';

  const tUser = LocalUserModel.empty();

  test(
    'should be a subclass of [AuthRepo]',
    () {
      expect(repoImpl, isA<AuthRepo>());
    },
  );

  group('forgotPassword', () {
    test(
      'should return [void] when call to remote source is successfull',
      () async {
        when(
          () => remoteDataSource.forgotPassword(any()),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.forgotPassword(tEmail);

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => remoteDataSource.forgotPassword(tEmail),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.forgotPassword(any()),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repoImpl.forgotPassword(tEmail);

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'User does not exist',
                statusCode: '404',
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.forgotPassword(tEmail),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUser] when call to remote source is successfull',
      () async {
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUser);

        final result = await repoImpl.signIn(
          email: tEmail,
          password: tPassword,
        );

        expect(result, equals(const Right<dynamic, LocalUser>(tUser)));

        verify(
          () => remoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repoImpl.signIn(
          email: tEmail,
          password: tPassword,
        );

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'User does not exist',
                statusCode: '404',
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signUp', () {
    test(
      'should return [void] when call to remote source is successfull',
      () async {
        when(
          () => remoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => remoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when signUp call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'User already exists',
            statusCode: '400',
          ),
        );

        final result = await repoImpl.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'User already exists',
                statusCode: '400',
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('updateUser', () {
    test(
      'should return [void] when call to remote source is successfull',
      () async {
        when(
          () => remoteDataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => remoteDataSource.updateUser(
            action: tUpdateAction,
            userData: tUserData,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return [ServerFailure] when updateUser call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => remoteDataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repoImpl.updateUser(
          action: tUpdateAction,
          userData: tUserData,
        );

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'User does not exist',
                statusCode: '404',
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.updateUser(
            action: tUpdateAction,
            userData: tUserData,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
