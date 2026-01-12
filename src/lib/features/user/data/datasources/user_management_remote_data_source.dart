import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/data/models/user_model.dart';
import 'package:src/features/user/data/models/user_report_model.dart';

abstract interface class UserManagementRemoteDataSource {
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
}

class UserManagementRemoteDataSourceImpl implements UserManagementRemoteDataSource {
  final FirebaseFirestore firestore;

  UserManagementRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<UserModel>> getUsers({
    required int limit,
    String? keyword,
    String? lastUserId,
  }) async {
    try {
      debugPrint('Fetching users with limit: $limit, keyword: $keyword, lastUserId: $lastUserId');
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
}
