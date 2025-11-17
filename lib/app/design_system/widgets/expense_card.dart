// lib/app/design_system/widgets/expense_card.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Expense card widget for displaying financial transactions
class ExpenseCard extends StatelessWidget {
  final String amount;
  final String description;
  final String status;
  final Widget? statusLabel;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const ExpenseCard({
    super.key,
    required this.amount,
    required this.description,
    required this.status,
    this.statusLabel,
    this.trailing,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundLight,
          borderRadius: AppRadius.radiusMd,
          border: Border.all(color: AppColors.dividerLight),
          boxShadow: AppShadows.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (statusLabel != null) ...[
                        statusLabel!,
                        SizedBox(height: AppSpacing.xs),
                      ],
                      Text(
                        amount,
                        style: AppTypography.headingMD.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        description,
                        style: AppTypography.bodySM.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}
