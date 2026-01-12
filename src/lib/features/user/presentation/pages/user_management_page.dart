import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/utils/format_date.dart';
import 'package:src/core/common/widgets/loader.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/user/presentation/widgets/status_chip.dart';
import 'package:src/features/user/presentation/providers/user_management_provider.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final ScrollController _usersScrollController = ScrollController();
  final ScrollController _userReportsScrollController = ScrollController();
  final _keywordController = TextEditingController();

  ReportStatus? _currentFilterStatus;
  late String userId;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _usersScrollController.addListener(_onUsersScroll);
    _userReportsScrollController.addListener(_onUserReportsScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final UserManagementProvider userManagementProvider = context.read<UserManagementProvider>();
      userManagementProvider.getUsers(refresh: true);
    });
  }

  @override
  void dispose() {
    _usersScrollController.removeListener(_onUsersScroll);
    _userReportsScrollController.removeListener(_onUserReportsScroll);
    _usersScrollController.dispose();
    _userReportsScrollController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  void _onUsersScroll() {
    if (_usersScrollController.position.pixels >= _usersScrollController.position.maxScrollExtent * 0.8) {
      context.read<UserManagementProvider>().loadMoreUsers();
    }
  }

  void _onUserReportsScroll() {
    if (_userReportsScrollController.position.pixels >= _userReportsScrollController.position.maxScrollExtent * 0.8) {
      context.read<UserManagementProvider>().loadMoreUserReports(userId: userId);
    }
  }

  Widget _buildUserReportsSection(
    BuildContext context,
    UserManagementProvider provider,
    String currentUserId,
  ) {
    if (provider.isLoading && provider.userReports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Loader()),
      );
    }

    if (provider.errorMessage != null && provider.userReports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Can\'t load reports',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => provider.getUserReports(userId: currentUserId, refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.userReports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No reports found for this user',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reports (${provider.userReports.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<ReportStatus?>(
                value: _currentFilterStatus,
                hint: const Text('Filter by status'),
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
                  provider.getUserReports(userId: currentUserId, refresh: true);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.separated(
            controller: _userReportsScrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.userReports.length + (provider.hasMoreReports ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              if (index == provider.userReports.length) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final report = provider.userReports[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                title: Text(
                  report.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatusChip(status: report.status),
                        const SizedBox(width: 8),
                        Text(
                          formatDate(report.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push(
                    '/admin-report-details',
                    extra: report.toBaseReport(),
                  );
                },
              );
            },
          ),
          // Load more button
          if (provider.hasMoreReports && !provider.isLoadingMoreReports)
            Center(
              child: TextButton(
                onPressed: () => provider.loadMoreUserReports(userId: currentUserId),
                child: const Text('Load more'),
              ),
            ),
          if (provider.isLoadingMoreReports)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<UserManagementProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.users.isEmpty) {
              return const Center(child: Loader());
            }

            if (provider.errorMessage != null && provider.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Can\'t load reports, please try again or come back later.',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.getUsers(refresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.getUsers(refresh: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    'List of Users:',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _keywordController,
                    decoration: InputDecoration(
                      labelText: 'Search users',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          provider.setKeywordFilter(_keywordController.text);
                          provider.getUsers(refresh: true);
                        },
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      provider.setKeywordFilter(value);
                      provider.getUsers(refresh: true);
                    },
                  ),
                  if (provider.users.isEmpty)
                    Center(
                      child: Text(
                        'No users found',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: _usersScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: provider.users.length,
                        itemBuilder: (context, index) {
                          final user = provider.users[index];
                          return Column(
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ExpansionTile(
                                  key: ValueKey('expansion_${index}_$_expandedIndex'),
                                  initiallyExpanded: _expandedIndex == index,
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide.none,
                                  ),
                                  collapsedShape: const RoundedRectangleBorder(
                                    side: BorderSide.none,
                                  ),
                                  onExpansionChanged: (expanded) {
                                    if (expanded) {
                                      setState(() {
                                        _expandedIndex = index;
                                        userId = user.id;
                                      });
                                      provider.getUserReports(userId: user.id, refresh: true);
                                    } else if (_expandedIndex == index) {
                                      setState(() {
                                        _expandedIndex = null;
                                      });
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
                                    onBackgroundImageError: user.profileImageUrl != null ? (_, _) {} : null,
                                    child: user.profileImageUrl == null ? Icon(Icons.person, color: Colors.grey[600]) : null,
                                  ),
                                  title: Text(
                                    user.name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Role: ${user.role}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text(
                                        'Email: ${user.email}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  children: [
                                    _buildUserReportsSection(context, provider, user.id),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
