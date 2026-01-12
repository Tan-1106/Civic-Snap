import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/core/utils/format_date.dart';
import 'package:src/core/common/widgets/loader.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/utils/show_snackbar.dart';
import 'package:src/features/user/presentation/widgets/status_chip.dart';
import 'package:src/features/user/presentation/providers/user_profile_provider.dart';
import 'package:src/features/authentication/presentation/providers/authentication_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ScrollController _scrollController = ScrollController();
  ReportStatus? _currentFilterStatus;

  Future<void> _chooseImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final imageFile = File(pickedFile.path);
      final userProfileProvider = context.read<UserProfileProvider>();
      await userProfileProvider.updateProfileImage(imageFile);

      if (userProfileProvider.errorMessage == null) {
        if (mounted) {
          showSuccessSnackBar(context, 'Profile image updated successfully.');
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, userProfileProvider.errorMessage!);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
      final UserProfileProvider userManagementProvider = context.read<UserProfileProvider>();

      final currentUserId = authenticationProvider.userId;
      userManagementProvider.setUserId(currentUserId);

      if (userManagementProvider.userProfile == null) {
        userManagementProvider.fetchUserProfile();
      }

      userManagementProvider.getUserReports(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<UserProfileProvider>().loadMoreUserReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<UserProfileProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingProfile && provider.userProfile == null) {
              return const Center(child: Loader());
            }

            if (provider.errorMessage != null && provider.userProfile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Can\'t load your profile, please try again or come back later.',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchUserProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.userProfile == null) {
              return const Center(child: Loader());
            }

            final user = provider.userProfile!;
            return Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (user.profileImageUrl != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.profileImageUrl!),
                      )
                    else
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _chooseImageFromGallery,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your reports:',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<ReportStatus?>(
                      elevation: 4,
                      value: _currentFilterStatus,
                      items: [
                        const DropdownMenuItem<ReportStatus?>(
                          value: null,
                          child: Text('All'),
                        ),
                        ...ReportStatus.values.map(
                          (status) => DropdownMenuItem<ReportStatus>(
                            value: status,
                            child: Text(
                              status == ReportStatus.pending
                                  ? 'Pending'
                                  : status == ReportStatus.inProgress
                                  ? 'In Progress'
                                  : 'Resolved',
                            ),
                          ),
                        ),
                      ],
                      onChanged: (status) {
                        setState(() {
                          _currentFilterStatus = status;
                        });
                        provider.setReportStatusFilter(status);
                        provider.getUserReports(refresh: true);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: () {
                    if (provider.isLoading && provider.userReports.isEmpty) {
                      return const Center(child: Loader());
                    }

                    if (provider.userReports.isEmpty) {
                      return Center(
                        child: Text(
                          'No reports found.',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      itemCount: provider.userReports.length + (provider.isLoadingMoreReports ? 1 : 0),
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        if (index >= provider.userReports.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Loader(),
                            ),
                          );
                        }
                        final report = provider.userReports[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0.0),
                          title: Text(
                            report.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Status: ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StatusChip(status: report.status),
                              ],
                            ),
                          ),
                          trailing: Text(
                            formatDate(report.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            context.push(
                              '/user-report-details',
                              extra: report,
                            );
                          },
                        );
                      },
                    );
                  }(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
