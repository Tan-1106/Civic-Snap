import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';
import 'package:src/features/dashboard/presentation/widgets/status_chip.dart';

class ReportItem extends StatelessWidget {
  final DashboardReportEntity report;
  final VoidCallback onSeeMore;

  const ReportItem({
    super.key,
    required this.report,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    //   return Card(
    //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //     elevation: 2,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Title và Status
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   report.title,
    //                   style: theme.textTheme.titleMedium?.copyWith(
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                   maxLines: 2,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ),
    //               const SizedBox(width: 8),
    //               _StatusChip(
    //                 status: status,
    //                 color: _getStatusColor(status),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 8),
    //
    //           // Description
    //           Text(
    //             report.description,
    //             style: theme.textTheme.bodyMedium?.copyWith(
    //               color: theme.textTheme.bodySmall?.color,
    //             ),
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //           const SizedBox(height: 12),
    //
    //           // See More button
    //           Align(
    //             alignment: Alignment.centerRight,
    //             child: TextButton.icon(
    //               onPressed: onSeeMore,
    //               icon: const Icon(Icons.arrow_forward, size: 18),
    //               label: const Text('See more'),
    //               style: TextButton.styleFrom(
    //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              child: Text(
                report.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StatusChip(
              status: report.status,
            ),
          ],
        ),
        Text(
          report.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onSeeMore,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('See more'),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
