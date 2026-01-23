import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/common/widgets/loader.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/core/common/widgets/primary_button.dart';
import 'package:src/features/dashboard/presentation/widgets/report_item.dart';
import 'package:src/features/dashboard/presentation/providers/dashboard_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final _userIdController = TextEditingController();
  ReportStatus? _currentFilterStatus;

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<DashboardProvider>().loadMoreReports();
    }
  }

  void _showFilterSheet(BuildContext context) {
    final provider = context.read<DashboardProvider>();
    _currentFilterStatus = provider.currentFilterStatus;
    _userIdController.text = provider.currentFilterUserId ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Reports',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
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
                        child: DropdownButton<ReportStatus?>(
                          value: _currentFilterStatus,
                          hint: const Text('All'),
                          elevation: 16,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<ReportStatus?>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...ReportStatus.values.map((status) {
                              return DropdownMenuItem<ReportStatus?>(
                                value: status,
                                child: Text(status.displayName),
                              );
                            }),
                          ],
                          onChanged: (newValue) {
                            setSheetState(() {
                              _currentFilterStatus = newValue;
                            });
                            setState(() {
                              _currentFilterStatus = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'User ID:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _userIdController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter User ID',
                        suffixIcon: InkWell(
                          child: const Icon(Icons.clear),
                          onTap: () {
                            _userIdController.clear();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Apply Filters',
                        onPressed: () {
                          final dashboardProvider = context.read<DashboardProvider>();
                          dashboardProvider.setFilterStatus(_currentFilterStatus);
                          dashboardProvider.setFilterUserId(
                            _userIdController.text.isNotEmpty ? _userIdController.text : null,
                          );
                          dashboardProvider.getReports(refresh: true);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DashboardProvider dashboardProvider = context.read<DashboardProvider>();
      dashboardProvider.getReports(
        refresh: true,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.reports.isEmpty) {
              return const Center(
                child: Loader(),
              );
            }

            if (provider.reports.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => provider.getReports(refresh: true),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (provider.errorMessage == null) ...[
                        Text(
                          'No reports found',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (provider.errorMessage != null) ...[
                        Text(
                          'Can\'t load reports, please try again or come back later.',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.getReports(refresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.getReports(refresh: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'List of Reports:',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.reports.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.reports.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: Loader()),
                          );
                        }

                        final report = provider.reports[index];
                        return ReportItem(
                          report: report,
                          onSeeMore: () {
                            context.push(
                              '/admin-report-details',
                              extra: report.toBaseReport(),
                            );
                          },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFilterSheet(context),
        label: const Text('Filter'),
        icon: const Icon(Icons.filter_list),
      ),
    );
  }
}
