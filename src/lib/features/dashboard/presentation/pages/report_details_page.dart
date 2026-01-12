import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/utils/show_snackbar.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/common/widgets/primary_button.dart';
import 'package:src/core/common/entities/base_report_entity.dart';
import 'package:src/features/dashboard/presentation/providers/dashboard_provider.dart';

class ReportDetailsPage extends StatefulWidget {
  final BaseReportEntity report;

  const ReportDetailsPage({super.key, required this.report});

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final _responseController = TextEditingController();
  late ReportStatus _currentStatus;

  void _submit() async {
    final dashboardProvider = context.read<DashboardProvider>();

    await dashboardProvider.respondToReport(
      reportId: widget.report.id,
      newStatus: _currentStatus.displayName != widget.report.status ? _currentStatus : null,
      response: _responseController.text.isNotEmpty ? _responseController.text : null,
    );
    await dashboardProvider.getReports(
      refresh: true,
    );

    if (dashboardProvider.errorMessage == null) {
      if (mounted) {
        showSuccessSnackBar(context, 'Response saved successfully');
        context.pop();
      }
    } else {
      if (mounted) {
        showErrorSnackBar(context, dashboardProvider.errorMessage!);
        dashboardProvider.clearError();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentStatus = ReportStatus.values.firstWhere(
      (status) => status.displayName == widget.report.status,
      orElse: () => ReportStatus.pending,
    );
    _responseController.text = widget.report.response ?? '';
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Text(
                    'User ID:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.report.userId),
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
                      widget.report.title,
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
                      widget.report.description,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.report.imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('No image available');
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Status:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ReportStatus>(
                    value: _currentStatus,
                    elevation: 16,
                    isExpanded: true,
                    items: ReportStatus.values.map((status) {
                      return DropdownMenuItem<ReportStatus>(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _currentStatus = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Response:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _responseController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your response here',
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Save',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
