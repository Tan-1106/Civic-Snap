import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/common/widgets/primary_button.dart';
import 'package:src/core/utils/show_snackbar.dart';
import 'package:src/features/user/domain/entities/user_report_entity.dart';
import 'package:src/features/user/presentation/providers/user_profile_provider.dart';
import 'package:src/features/user/presentation/widgets/status_chip.dart';

class UserReportDetailsPage extends StatefulWidget {
  final UserReportEntity report;

  const UserReportDetailsPage({super.key, required this.report});

  @override
  State<UserReportDetailsPage> createState() => _UserReportDetailsPageState();
}

class _UserReportDetailsPageState extends State<UserReportDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProfileProvider = context.read<UserProfileProvider>();

      await userProfileProvider.updateReportBasicInformation(
        reportId: widget.report.id,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      if (userProfileProvider.errorMessage == null) {
        if (mounted) {
          showSuccessSnackBar(context, 'Report updated successfully.');
          context.pop();
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, userProfileProvider.errorMessage!);
          userProfileProvider.clearErrorMessage();
        }
      }
      userProfileProvider.getUserReports(refresh: true);
    } else {
      showErrorSnackBar(context, 'Please don\'t leave title or description empty.');
    }
  }

  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this report? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReport();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteReport() async {
    final userProfileProvider = context.read<UserProfileProvider>();

    await userProfileProvider.deleteReport(reportId: widget.report.id);

    if (userProfileProvider.errorMessage == null) {
      if (mounted) {
        showSuccessSnackBar(context, 'Report deleted successfully.');
        context.pop();
      }
    } else {
      if (mounted) {
        showErrorSnackBar(context, userProfileProvider.errorMessage!);
        userProfileProvider.clearErrorMessage();
      }
    }
    userProfileProvider.getUserReports(refresh: true);
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.report.title;
    _descriptionController.text = widget.report.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StatusChip(status: widget.report.status),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Problem Title:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _titleController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Short description of the issue',
                      border: OutlineInputBorder(),
                    ),
                    enabled: widget.report.status == ReportStatus.pending.displayName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Detailed Description:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Provide a detailed description of the issue',
                      border: OutlineInputBorder(),
                    ),
                    enabled: widget.report.status == ReportStatus.pending.displayName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Attach Image:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.report.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Location:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.report.location.latitude} : ${widget.report.location.longitude}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 30),
                if (widget.report.status == ReportStatus.pending.displayName)
                  PrimaryButton(
                    text: 'Submit Changes',
                    onPressed: _submit,
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showConfirmDeleteDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Delete Report',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
