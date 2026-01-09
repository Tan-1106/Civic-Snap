import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:src/core/error/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ReportRepository {
  Future<Either<Failure, String>> uploadImage({
    required File image,
    required String reportId,
  });

  Future<Either<Failure, void>> submitReport({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String imageUrl,
    required DateTime createdAt,
    required String status,
    required GeoPoint location,
  });
}
