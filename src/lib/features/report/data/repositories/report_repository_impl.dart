import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/features/report/data/models/report_model.dart';
import 'package:src/features/report/domain/repositories/report_repository.dart';
import 'package:src/features/report/data/datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  const ReportRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, String>> uploadImage({
    required File image,
    required String reportId,
  }) async {
    try {
      final imageUrl = await remoteDataSource.uploadImage(image: image, reportId: reportId);
      return right(imageUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitReport({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String imageUrl,
    required DateTime createdAt,
    required String status,
    required GeoPoint location,
  }) async {
    try {
      await remoteDataSource.createReport(
        ReportModel(
          id: id,
          userId: userId,
          title: title,
          description: description,
          imageUrl: imageUrl,
          createdAt: createdAt,
          status: status,
          location: location,
        ),
      );
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
