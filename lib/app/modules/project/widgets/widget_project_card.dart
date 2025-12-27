import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import 'widget_metric_pill.dart';
import 'widget_status_badge.dart';

class WidgetProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const WidgetProjectCard({super.key, required this.project, this.onTap});

  BadgeStatus get _status {
    switch (project.status?.toUpperCase()) {
      case 'COMPLETED':
        return BadgeStatus.success;
      case 'CONSTRUCTION':
      case 'DESIGN':
        return BadgeStatus.warning;
      case 'CANCELLED':
        return BadgeStatus.danger;
      default:
        return BadgeStatus.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // 8-16dp spacing
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.neutral000,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral300),
          // boxShadow: [AppShadows.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP: Name + Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.name ?? 'Untitled Project',
                    style: AppTypography.headingMD.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                WidgetStatusBadge(
                  text: project.status ?? 'UNKNOWN',
                  status: _status,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // MID: Phase • Client
            Text(
              '${project.status ?? '-'} • ${project.clientName ?? 'No Client'}',
              style: AppTypography.bodySM.copyWith(color: AppColors.neutral700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // BOTTOM: Metrics + Chevron
            Row(
              children: [
                if (project.financials?.cpi != null) ...[
                  WidgetMetricPill(
                    label: 'CPI',
                    value: project.financials!.cpi.toString(),
                  ),
                  const SizedBox(width: 8),
                ],
                if (project.financials?.spi != null)
                  WidgetMetricPill(
                    label: 'SPI',
                    value: project.financials!.spi.toString(),
                  ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.neutral500,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
