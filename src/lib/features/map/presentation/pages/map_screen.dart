import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';
import 'package:src/features/map/presentation/providers/map_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool _isMapReady = false;
  List<MapReportEntity> _reports = [];
  StreamSubscription<List<MapReportEntity>>? _reportsSubscription;

  static const CameraPosition _kDefaultCenter = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 14.4746,
  );

  Future<void> _determineUserPosition() async {
    if (!_isMapReady) return;

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Set<Marker> _createMarkers(List<MapReportEntity> reports) {
    return reports.map((report) {
      return Marker(
        markerId: MarkerId(report.id),
        position: LatLng(
          report.location.latitude,
          report.location.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerHue(report.status),
        ),
        infoWindow: InfoWindow(
          title: report.title,
        ),
      );
    }).toSet();
  }

  double _getMarkerHue(String status) {
    if (status == ReportStatus.pending.displayName) {
      return BitmapDescriptor.hueRed;
    } else if (status == ReportStatus.inProgress.displayName) {
      return BitmapDescriptor.hueYellow;
    } else if (status == ReportStatus.resolved.displayName) {
      return BitmapDescriptor.hueGreen;
    } else {
      return BitmapDescriptor.hueRed;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mapProvider = context.read<MapProvider>();
      _reportsSubscription = mapProvider.getMapReportsStream().listen((reports) {
        if (mounted) {
          setState(() {
            _reports = reports;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kDefaultCenter,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _isMapReady = true;
          });
          _determineUserPosition();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        markers: _createMarkers(_reports),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determineUserPosition,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
