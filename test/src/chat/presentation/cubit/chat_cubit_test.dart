import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/data/models/group_model.dart';
import 'package:educational_app/src/chat/data/models/message_model.dart';
import 'package:educational_app/src/chat/domain/usecases/get_group_members.dart';
import 'package:educational_app/src/chat/domain/usecases/get_groups.dart';
import 'package:educational_app/src/chat/domain/usecases/get_messages.dart';
import 'package:educational_app/src/chat/domain/usecases/get_user_by_id.dart';
import 'package:educational_app/src/chat/domain/usecases/join_group.dart';
import 'package:educational_app/src/chat/domain/usecases/leave_group.dart';
import 'package:educational_app/src/chat/domain/usecases/send_message.dart';
import 'package:educational_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessage extends Mock implements SendMessage {}

class MockGetGroups extends Mock implements GetGroups {}

class MockGetMessages extends Mock implements GetMessages {}

class MockJoinGroup extends Mock implements JoinGroup {}

class MockLeaveGroup extends Mock implements LeaveGroup {}

class MockGetUserById extends Mock implements GetUserById {}

class MockGetGroupMembers extends Mock implements GetGroupMembers {}

void main() {
  late SendMessage sendMessage;
  late GetMessages getMessages;
  late GetGroups getGroups;
  late JoinGroup joinGroup;
  late LeaveGroup leaveGroup;
  late GetUserById getUserById;
  late GetGroupMembers getGroupMembers;
  late ChatCubit chatCubit;

  setUp(() {
    sendMessage = MockSendMessage();
    getMessages = MockGetMessages();
    getGroups = MockGetGroups();
    joinGroup = MockJoinGroup();
    leaveGroup = MockLeaveGroup();
    getUserById = MockGetUserById();
    getGroupMembers = MockGetGroupMembers();
    chatCubit = ChatCubit(
      getGroups: getGroups,
      getMessages: getMessages,
      getUserById: getUserById,
      joinGroup: joinGroup,
      leaveGroup: leaveGroup,
      sendMessage: sendMessage,
      getGroupMembers: getGroupMembers,
    );
  });

  tearDown(() => chatCubit.close());

  final tFailure = ServerFailure(
    message: 'SErver Error',
    statusCode: '500',
  );

  test('initial state is ChatInitial', () {
    expect(chatCubit.state, const ChatInitial());
  });

  group('sendMessage', () {
    final message = MessageModel.empty();

    setUp(() => registerFallbackValue(message));

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, MessageSent] when successful',
      build: () {
        when(() => sendMessage(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => const [
        SendingMessage(),
        MessageSent(),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, ChatError] when unsuccessful',
      build: () {
        when(() => sendMessage(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => [
        const SendingMessage(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );
  });

  group('joinGroup', () {
    const tJoinGroupParams = JoinGroupParams.empty();

    setUpAll(() => registerFallbackValue(tJoinGroupParams));

    blocTest<ChatCubit, ChatState>(
      'emits [JoiningGroup, JoinedGroup] when successful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.joinGroup(
        groupId: tJoinGroupParams.groupId,
        userId: tJoinGroupParams.userId,
      ),
      expect: () => const [
        JoiningGroup(),
        JoinedGroup(),
      ],
      verify: (_) {
        verify(() => joinGroup(tJoinGroupParams)).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [JoiningGroup, ChatError] when unsuccessful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.joinGroup(
        groupId: tJoinGroupParams.groupId,
        userId: tJoinGroupParams.userId,
      ),
      expect: () => [
        const JoiningGroup(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => joinGroup(tJoinGroupParams)).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );
  });

  group('leaveGroup', () {
    const tLeaveGroupParams = LeaveGroupParams.empty();

    setUpAll(() => registerFallbackValue(tLeaveGroupParams));

    blocTest<ChatCubit, ChatState>(
      'emits [LeavingGroup, LeftGroup] when successful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.leaveGroup(
        groupId: tLeaveGroupParams.groupId,
        userId: tLeaveGroupParams.userId,
      ),
      expect: () => const [
        LeavingGroup(),
        LeftGroup(),
      ],
      verify: (_) {
        verify(() => leaveGroup(tLeaveGroupParams)).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [LeavingGroup, ChatError] when unsuccessful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.leaveGroup(
        groupId: tLeaveGroupParams.groupId,
        userId: tLeaveGroupParams.userId,
      ),
      expect: () => [
        const LeavingGroup(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => leaveGroup(tLeaveGroupParams)).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );
  });

  group('getUser', () {
    const tUserId = 'userId';
    const tUser = LocalUser.empty();

    blocTest<ChatCubit, ChatState>(
      'emits [GettingUser, UserFound] when successful',
      build: () {
        when(() => getUserById(any())).thenAnswer(
          (_) async => const Right(tUser),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => const [
        GettingUser(),
        UserFound(tUser),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [GettingUser, ChatError] when unsuccessful',
      build: () {
        when(() => getUserById(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => [
        const GettingUser(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );
  });

  group('getGroupMembers', () {
    const tGroupId = 'groupIdId';
    const tMembers = [LocalUser.empty()];

    blocTest<ChatCubit, ChatState>(
      'emits [GettingGroupMembers, UserFound] when successful',
      build: () {
        when(() => getGroupMembers(any())).thenAnswer(
          (_) async => const Right(tMembers),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getGroupMembers(tGroupId),
      expect: () => const [
        GettingGroupMembers(),
        GroupMembersFound(tMembers),
      ],
      verify: (_) {
        verify(() => getGroupMembers(tGroupId)).called(1);
        verifyNoMoreInteractions(getGroupMembers);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [GettingUser, ChatError] when unsuccessful',
      build: () {
        when(() => getGroupMembers(any())).thenAnswer(
          (_) async => Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getGroupMembers(tGroupId),
      expect: () => [
        const GettingGroupMembers(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getGroupMembers(tGroupId)).called(1);
        verifyNoMoreInteractions(getGroupMembers);
      },
    );
  });

  group('getGroups', () {
    final tGroups = [
      GroupModel.empty(),
    ];

    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingGroups, GroupsLoaded] when successful',
      build: () {
        when(() => getGroups()).thenAnswer((_) => Stream.value(Right(tGroups)));
        return chatCubit;
      },
      act: (cubit) => cubit.getGroups(),
      expect: () => [
        const LoadingGroups(),
        GroupsLoaded(tGroups),
      ],
      verify: (_) {
        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingGroups, ChatError] when unsuccessful',
      build: () {
        when(() => getGroups()).thenAnswer((_) => Stream.value(Left(tFailure)));
        return chatCubit;
      },
      act: (cubit) => cubit.getGroups(),
      expect: () => [
        const LoadingGroups(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );
  });

  group('getMessages', () {
    final tMessages = [
      MessageModel.empty(),
    ];

    const tGroupId = 'groupId';

    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, MessagesLoaded] when successful',
      build: () {
        when(() => getMessages(any()))
            .thenAnswer((_) => Stream.value(Right(tMessages)));
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages(tGroupId),
      expect: () => [
        const LoadingMessages(),
        MessagesLoaded(tMessages),
      ],
      verify: (_) {
        verify(() => getMessages(tGroupId)).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, ChatError] when unsuccessful',
      build: () {
        when(() => getMessages(any()))
            .thenAnswer((_) => Stream.value(Left(tFailure)));
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages(tGroupId),
      expect: () => [
        const LoadingMessages(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getMessages(tGroupId)).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
  });
}
