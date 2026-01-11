import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/data/models/dashboard_report_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<List<DashboardReportModel>> getReports({
    required int limit,
    String? lastDocumentId,
  });

  Future<DashboardReportModel> getReportById(String reportId);

  Future<List<DashboardReportModel>> getReportsByStatus({
    required ReportStatus status,
    required int limit,
    String? lastDocumentId,
  });

  Future<List<DashboardReportModel>> getReportsByUser({
    required String userId,
    required int limit,
    String? lastDocumentId,
  });

  Future<bool> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<DashboardReportModel>> getReports({
    required int limit,
    String? lastDocumentId,
  }) async {
    try {
      Query query = firestore.collection('reports').orderBy('created_at', descending: true).limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await firestore.collection('reports').doc(lastDocumentId).get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => DashboardReportModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DashboardReportModel> getReportById(String reportId) async {
    try {
      final doc = await firestore.collection('reports').doc(reportId).get();
      if (doc.exists) {
        return DashboardReportModel.fromDocument(doc);
      } else {
        throw Exception('Report not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<DashboardReportModel>> getReportsByStatus({
    required ReportStatus status,
    required int limit,
    String? lastDocumentId,
  }) async {
    try {
      Query query = firestore.collection('reports').where('status', isEqualTo: status.displayName).orderBy('created_at', descending: true).limit(limit);
      if (lastDocumentId != null) {
        return firestore.collection('reports').doc(lastDocumentId).get().then((lastDoc) {
          query = query.startAfterDocument(lastDoc);
          return query.get().then((querySnapshot) {
            return querySnapshot.docs.map((doc) => DashboardReportModel.fromDocument(doc)).toList();
          });
        });
      } else {
        return query.get().then((querySnapshot) {
          return querySnapshot.docs.map((doc) => DashboardReportModel.fromDocument(doc)).toList();
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<DashboardReportModel>> getReportsByUser({
    required String userId,
    required int limit,
    String? lastDocumentId,
  }) async {
    try {
      Query query = firestore.collection('reports').where('userId', isEqualTo: userId).orderBy('created_at', descending: true).limit(limit);
      if (lastDocumentId != null) {
        return firestore.collection('reports').doc(lastDocumentId).get().then((lastDoc) {
          query = query.startAfterDocument(lastDoc);
          return query.get().then((querySnapshot) {
            return querySnapshot.docs.map((doc) => DashboardReportModel.fromDocument(doc)).toList();
          });
        });
      } else {
        return query.get().then((querySnapshot) {
          return querySnapshot.docs.map((doc) => DashboardReportModel.fromDocument(doc)).toList();
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  }) async {
    try {
      final reportRef = firestore.collection('reports').doc(reportId);
      final updates = <String, dynamic>{};

      if (newStatus != null) {
        updates['status'] = newStatus.displayName;
      }

      updates['response'] = response;

      updates['updated_at'] = FieldValue.serverTimestamp();

      await reportRef.update(updates);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}