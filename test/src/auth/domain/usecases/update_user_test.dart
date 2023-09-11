import 'package:dartz/dartz.dart';
import 'package:educational_app/core/enums/update_user.dart';
import 'package:educational_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
  });

  test('should call [AuthRepo.updateUser]', () async {
    when(
      () => repo.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(
      const UpdateUserParams(
        action: UpdateUserAction.email,
        userData: 'Test email',
      ),
    );

    expect(result, const Right<dynamic, void>(null));

    verify(
      () => repo.updateUser(
        action: UpdateUserAction.email,
        userData: 'Test email',
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
