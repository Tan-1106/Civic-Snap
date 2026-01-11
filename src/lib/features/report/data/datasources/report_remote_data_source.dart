import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:src/features/report/data/models/report_model.dart';

abstract interface class ReportRemoteDataSource {
  Future<String> uploadImage({
    required File image,
    required String reportId,
  });

  Future<void> createReport(
    ReportModel report,
  );
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ReportRemoteDataSourceImpl(
    this.firestore,
    this.storage,
  );

  @override
  Future<String> uploadImage({
    required File image,
    required String reportId,
  }) async {
    try {
      final ref = storage.ref().child('reports').child('$reportId.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createReport(
    ReportModel report,
  ) async {
    try {
      await firestore.collection('reports').doc(report.id).set(report.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
