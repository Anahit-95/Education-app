import 'package:dartz/dartz.dart';
import 'package:educational_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tFullName = 'Test fullName';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  test('should call the AuthRepo.signUp', () async {
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        fullName: any(named: 'fullName'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(
      const SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    expect(result, const Right<dynamic, void>(null));

    verify(
      () => repo.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
