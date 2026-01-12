import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/map/data/models/map_report_model.dart';

abstract interface class MapRemoteDataSource {
  Stream<List<MapReportModel>> getMapReports({
    required int limit,
    ReportStatus? status,
  });
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final FirebaseFirestore firestore;

  MapRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<MapReportModel>> getMapReports({
    required int limit,
    ReportStatus? status,
  }) {
    Query query = firestore.collection('reports').orderBy('created_at', descending: true).limit(limit);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MapReportModel.fromDocument(doc)).toList();
    });
  }
}
