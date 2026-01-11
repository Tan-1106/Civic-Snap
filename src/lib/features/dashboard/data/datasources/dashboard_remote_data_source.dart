import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/data/models/dashboard_report_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<List<DashboardReportModel>> getReports({
    required int limit,
    ReportStatus? status,
    String? userId,
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
    ReportStatus? status,
    String? userId,
    String? lastDocumentId,
  }) async {
    try {
      Query query = firestore.collection('reports').orderBy('created_at', descending: true);
      if (status != null) {
        query = query.where('status', isEqualTo: status.displayName);
      }
      if (userId != null) {
        query = query.where('user_id', isEqualTo: userId);
      }
      query = query.limit(limit);
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
