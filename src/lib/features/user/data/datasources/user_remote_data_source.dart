import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/data/models/user_model.dart';
import 'package:src/features/user/data/models/user_report_model.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  });

  Future<List<UserReportModel>> getUserReports({
    required int limit,
    required String userId,
    ReportStatus? status,
    String? lastReportId,
  });

  Future<UserModel> getUserProfile(String userId);

  Future<bool> uploadProfileImage({
    required String userId,
    required File image,
  });

  Future<bool> updateReportBasicInformation({
    required String reportId,
    String? title,
    String? description,
  });

  Future<bool> deleteReport({
    required String reportId,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<List<UserModel>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  }) async {
    try {
      Query query = firestore.collection('users');

      if (keyword != null && keyword.isNotEmpty) {
        query = query.where(
          Filter.or(
            Filter('email', isEqualTo: keyword),
            Filter('id', isEqualTo: keyword),
            Filter('name', isEqualTo: keyword),
          ),
        );
      }

      query = query.limit(limit);

      if (lastUserId != null) {
        final lastDoc = await firestore.collection('users').doc(lastUserId).get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UserReportModel>> getUserReports({
    required int limit,
    required String userId,
    ReportStatus? status,
    String? lastReportId,
  }) async {
    try {
      Query query = firestore.collection('reports').where('user_id', isEqualTo: userId).orderBy('created_at', descending: true);
      if (status != null) {
        query = query.where('status', isEqualTo: status.displayName);
      }
      query = query.limit(limit);
      if (lastReportId != null) {
        final lastDoc = await firestore.collection('reports').doc(lastReportId).get();
        query = query.startAfterDocument(lastDoc);
      }
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => UserReportModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromDocument(doc);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> uploadProfileImage({
    required String userId,
    required File image,
  }) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final oldImageUrl = userDoc.data()?['profileImageUrl'] as String?;
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          try {
            final oldStorageRef = storage.refFromURL(oldImageUrl);
            await oldStorageRef.delete();
          } catch (_) {}
        }
      }

      final storageRef = storage.ref().child('profile_images').child('$userId.jpg');
      final uploadTask = await storageRef.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await firestore.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> updateReportBasicInformation({
    required String reportId,
    String? title,
    String? description,
  }) async {
    try {
      await firestore.collection('reports').doc(reportId).update({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      });
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteReport({
    required String reportId,
  }) async {
    try {
      final imageUrl = await firestore.collection('reports').doc(reportId).get().then((doc) => doc['image_url'] as String?);
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final storageRef = storage.refFromURL(imageUrl);
        await storageRef.delete();
      }
      await firestore.collection('reports').doc(reportId).delete();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
