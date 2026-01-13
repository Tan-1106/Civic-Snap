import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:src/core/common/widgets/primary_button.dart';
import 'package:src/features/map/domain/entities/map_report_entity.dart';
import 'package:src/features/map/presentation/providers/map_provider.dart';
import 'package:src/features/map/presentation/widgets/status_chip.dart';

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
        onTap: () {
          _showReportDetailsBottomSheet(report);
        },
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

  void _setupReportsStream() {
    final mapProvider = context.read<MapProvider>();
    _reportsSubscription?.cancel();
    _reportsSubscription = mapProvider.getMapReportsStream().listen((reports) {
      if (mounted) {
        setState(() {
          _reports = reports;
        });
      }
    });
  }

  void _showFilterBottomSheet() {
    final mapProvider = context.read<MapProvider>();
    int selectedLimit = mapProvider.limit;
    List<int> limitOptions = [20, 50, 100];
    ReportStatus? selectedStatus = mapProvider.statusFilter;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Report Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of reports to display:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<int>(
                        value: selectedLimit,
                        items: limitOptions.map((limit) {
                          return DropdownMenuItem<int>(
                            value: limit,
                            child: Text(limit.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setSheetState(() {
                              selectedLimit = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Report status:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<ReportStatus?>(
                        value: selectedStatus,
                        items: [
                          const DropdownMenuItem<ReportStatus?>(
                            value: null,
                            child: Text('All'),
                          ),
                          ...ReportStatus.values.map((status) {
                            return DropdownMenuItem<ReportStatus>(
                              value: status,
                              child: Text(status.displayName),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setSheetState(() {
                            selectedStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                  PrimaryButton(
                    text: 'Apply Filters',
                    width: double.infinity,
                    onPressed: () {
                      mapProvider.setLimit(selectedLimit);
                      mapProvider.setStatusFilter(selectedStatus);
                      _setupReportsStream();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showReportDetailsBottomSheet(MapReportEntity report) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Report Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StatusChip(status: report.status),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Title:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.title,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.description,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Attached Image:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        report.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 150,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupReportsStream();
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          FloatingActionButton(
            heroTag: 'filterButton',
            onPressed: _showFilterBottomSheet,
            child: const Icon(Icons.filter_list),
          ),
          FloatingActionButton(
            heroTag: 'locationButton',
            onPressed: _determineUserPosition,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
