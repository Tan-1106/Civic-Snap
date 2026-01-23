import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/data/models/dashboard_report.dart';

abstract interface class DashboardRemoteDataSource {
  // Fetch reports with optional filters and pagination
  Future<List<DashboardReportModel>> getReports({
    required int limit,
    ReportStatus? status,
    String? userId,
    String? lastDocumentId,
  });

  // Respond to a report by updating its status and adding a response message
  Future<void> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl(this.firestore);

  // Fetch reports with optional filters and pagination
  @override
  Future<List<DashboardReportModel>> getReports({
    required int limit,
    ReportStatus? status,
    String? userId,
    String? lastDocumentId,
  }) async {
    try {
      Query query = firestore.collection('reports').orderBy('created_at', descending: true);
      if (status != null) query = query.where('status', isEqualTo: status.displayName);
      if (userId != null) query = query.where('user_id', isEqualTo: userId);

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

  // Respond to a report by updating its status and adding a response message
  @override
  Future<void> respondToReport({
    required String reportId,
    ReportStatus? newStatus,
    String? response,
  }) async {
    try {
      final reportRef = firestore.collection('reports').doc(reportId);
      final updates = <String, dynamic>{};

      updates['response'] = response;
      updates['updated_at'] = FieldValue.serverTimestamp();
      if (newStatus != null) updates['status'] = newStatus.displayName;

      await reportRef.update(updates);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
