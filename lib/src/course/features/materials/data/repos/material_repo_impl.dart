import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/materials/data/datasoursces/material_remote_data_src.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:educational_app/src/course/features/materials/domain/repos/material_repo.dart';

class MaterialRepoImpl implements MaterialRepo {
  MaterialRepoImpl(this._remoteDataSrc);

  final MaterialRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addMaterial(Resource material) async {
    try {
      await _remoteDataSrc.addMaterial(material);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) async {
    try {
      final result = await _remoteDataSrc.getMaterials(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
