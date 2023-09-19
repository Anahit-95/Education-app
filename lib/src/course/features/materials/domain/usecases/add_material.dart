import 'package:educational_app/core/usecases/usecases.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:educational_app/src/course/features/materials/domain/repos/material_repo.dart';

class AddMaterial extends UsecaseWithParams<void, Resource> {
  AddMaterial(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<void> call(Resource params) => _repo.addMaterial(params);
}
