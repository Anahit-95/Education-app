import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:educational_app/src/course/features/materials/domain/repos/material_repo.dart';

class GetMaterials extends FutureUsecaseWithParams<List<Resource>, String> {
  GetMaterials(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<List<Resource>> call(String params) =>
      _repo.getMaterials(params);
}
