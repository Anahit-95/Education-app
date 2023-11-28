import 'package:dartz/dartz.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/usecases/get_group_members.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_repo.mock.dart';

void main() {
  late MockChatRepo repo;
  late GetGroupMembers usecase;

  setUp(() {
    repo = MockChatRepo();
    usecase = GetGroupMembers(repo);
  });

  const tMembers = [LocalUser.empty()];

  test(
    'should return [LocalUser] from [UserRepo.getUserById]',
    () async {
      when(
        () => repo.getGroupMembers(any()),
      ).thenAnswer((_) async => const Right(tMembers));

      final result = await usecase('groupId');

      expect(result, const Right<dynamic, List<LocalUser>>(tMembers));
      verify(
        () => repo.getGroupMembers('groupId'),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
