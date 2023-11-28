import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/auth/domain/entities/user.dart';
import 'package:educational_app/src/chat/domain/repos/chat_repo.dart';

class GetGroupMembers extends FutureUsecaseWithParams<List<LocalUser>, String> {
  const GetGroupMembers(this._repo);
  final ChatRepo _repo;

  @override
  ResultFuture<List<LocalUser>> call(String params) =>
      _repo.getGroupMembers(params);
}
