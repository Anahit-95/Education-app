import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/utils/datasource_utils.dart';
import 'package:educational_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class MaterialRemoteDataSrc {
  const MaterialRemoteDataSrc();

  Future<List<ResourceModel>> getMaterials(String courseId);

  Future<void> addMaterial(Resource material);
}

class MaterialRemoteDataSrcImpl implements MaterialRemoteDataSrc {
  MaterialRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> addMaterial(Resource material) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      final materialRef = _firestore
          .collection('courses')
          .doc(material.courseId)
          .collection('materials')
          .doc();
      var materialMadel =
          (material as ResourceModel).copyWith(id: materialRef.id);
      if (materialMadel.isFile) {
        final materialFileRef = _storage.ref().child(
            'courses/${materialMadel.courseId}/materials/${materialMadel.id}/material');
        await materialFileRef
            .putFile(File(materialMadel.fileURL))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          materialMadel = materialMadel.copyWith(fileURL: url);
        });
        await materialRef.set(materialMadel.toMap());

        await _firestore.collection('courses').doc(material.courseId).update({
          'numberOfMaterials': FieldValue.increment(1),
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<ResourceModel>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);

      final materialsRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('materials');
      final materials = await materialsRef.get();
      return materials.docs
          .map((e) => ResourceModel.fromMap(e.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
