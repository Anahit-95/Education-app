import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:educational_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:educational_app/src/auth/domain/usecases/sign_in.dart';
import 'package:educational_app/src/auth/domain/usecases/sign_up.dart';
import 'package:educational_app/src/auth/domain/usecases/update_user.dart';
import 'package:educational_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tSignInParams = SignInParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
  });

  tearDown(() => authBloc.close());

  final tServerFailure = ServerFailure(
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
    statusCode: 'user-not-found',
  );

  test('initialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when '
      '[SignInEvent] is added.',
      build: () => authBloc,
      setUp: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => const Right(tUser));
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails.',
      build: () => authBloc,
      setUp: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when '
      '[SignUpEvent] is added and signUp succeeds.',
      build: () => authBloc,
      setUp: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when SignUpEvent is added and '
      'signUp fails.',
      build: () => authBloc,
      setUp: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] when '
      'ForgotPasswordEvent is added and ForgotPassword succeeds.',
      build: () => authBloc,
      setUp: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent('email'),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when ForgotPasswordEvent is added '
      'and ForgotPassword fails.',
      build: () => authBloc,
      setUp: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent('email'),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when UpdateUserEvent is added '
      'and UpdateUser succeeds.',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => const <AuthState>[
        AuthLoading(),
        UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when UpdateUserEvent is added and '
      'and updateUser fails.',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
