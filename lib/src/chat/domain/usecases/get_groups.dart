import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/chat/domain/entities/group.dart';
import 'package:educational_app/src/chat/domain/repos/chat_repo.dart';

class GetGroups extends StreamUsecaseWithoutParams<List<Group>> {
  const GetGroups(this._repo);

  final ChatRepo _repo;

  @override
  ResultStream<List<Group>> call() => _repo.getGroups();
}
