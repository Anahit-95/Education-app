import 'package:bloc/bloc.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/entities/group.dart';
import 'package:educational_app/src/chat/domain/entities/message.dart';
import 'package:educational_app/src/chat/domain/usecases/get_groups.dart';
import 'package:educational_app/src/chat/domain/usecases/get_messages.dart';
import 'package:educational_app/src/chat/domain/usecases/get_user_by_id.dart';
import 'package:educational_app/src/chat/domain/usecases/join_group.dart';
import 'package:educational_app/src/chat/domain/usecases/leave_group.dart';
import 'package:educational_app/src/chat/domain/usecases/send_message.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
      {required GetGroups getGroups,
      required GetMessages getMessages,
      required GetUserById getUserById,
      required JoinGroup joinGroup,
      required LeaveGroup leaveGroup,
      required SendMessage sendMessage})
      : _getGroups = getGroups,
        _getMessages = getMessages,
        _getUserById = getUserById,
        _joinGroup = joinGroup,
        _leaveGroup = leaveGroup,
        _sendMessage = sendMessage,
        super(ChatInitial());

  final GetGroups _getGroups;
  final GetMessages _getMessages;
  final GetUserById _getUserById;
  final JoinGroup _joinGroup;
  final LeaveGroup _leaveGroup;
  final SendMessage _sendMessage;

  Future<void> sendMessage(Message message) async {
    emit(const SendingMessage());

    final result = await _sendMessage(message);
    result.fold(
      (failure) => ChatError('${failure.statusCode}: ${failure.message}'),
      (_) => emit(const MessageSent()),
    );
  }
}
