import 'package:educational_app/src/auth/data/models/user_model.dart';
import 'package:educational_app/src/chat/data/models/group_model.dart';
import 'package:educational_app/src/chat/data/models/message_model.dart';
import 'package:educational_app/src/chat/domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  const ChatRemoteDataSource();

  Future<void> sendMessage(Message message);

  Stream<List<MessageModel>> getMessages(String groupId);

  Stream<List<GroupModel>> getGroups();

  Future<void> joinGroup({required String groupId, required String userId});

  Future<void> leaveGroup({required String groupId, required String userId});

  Future<LocalUserModel> getUserById(String userId);
}
