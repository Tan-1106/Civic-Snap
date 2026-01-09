import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:src/core/common/widgets/loader.dart';
import 'package:src/core/common/widgets/primary_button.dart';
import 'package:src/core/utils/show_snackbar.dart';
import 'package:src/features/authentication/presentation/providers/authentication_provider.dart';
import 'package:src/features/report/presentation/providers/report_provider.dart';

class SendReportPage extends StatefulWidget {
  const SendReportPage({super.key});

  @override
  State<SendReportPage> createState() => _SendReportPageState();
}

class _SendReportPageState extends State<SendReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  Position? _position;
  bool _isLoading = false;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _chooseImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
      _isLoading = false;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() || _image != null || _position != null) {
      final authenticationProvider = context.read<AuthenticationProvider>();
      final reportProvider = context.read<ReportProvider>();

      await reportProvider.submitReport(
        userId: authenticationProvider.user!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _image!,
        position: _position!,
      );

      if (reportProvider.errorMessage == null) {
        if (mounted) {
          showSuccessSnackBar(context, 'Report submitted successfully.');
          context.go('/user-map');
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, reportProvider.errorMessage!);
          reportProvider.clearError();
        }
      }
    } else {
      showErrorSnackBar(context, 'Please attach an image and enable location services.');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ReportProvider>().isLoading;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: isLoading
            ? const Center(child: Loader())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Problem Title:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Short description of the issue',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detailed Description:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach Image:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _image == null
                              ? Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No image selected.',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _image!,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _takePhoto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.camera_alt),
                            label: Text(
                              'Take Photo',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _chooseImageFromGallery,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.photo_library),
                              label: Text(
                                'Choose from Gallery',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const Loader()
                                          : Text(
                                              _position == null ? 'No location selected.' : '${_position!.latitude} : ${_position!.longitude}',
                                              style: Theme.of(context).textTheme.labelMedium,
                                            ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.my_location),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                                  ),
                                  onPressed: _getCurrentLocation,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      PrimaryButton(
                        text: 'Send Report',
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
