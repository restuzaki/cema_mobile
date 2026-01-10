// lib/app/modules/notification/widgets/notification_card_pm.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/notification/notification_model.dart';
import 'package:cema_mobile/app/modules/notification/controllers/notification_controller.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';

class NotificationCardPM extends StatelessWidget {
  final NotificationItem item;

  const NotificationCardPM({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    // Use ExpenseCard widget from design system (same as Finance tab)
    if (item.expenseId != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.sm),
        child: ExpenseCard(
          amount: item.amount ?? 'Rp 0',
          description: item.title,
          status: 'PENDING',
          statusLabel: StatusLabel(
            label: 'Menunggu Persetujuan',
            type: StatusLabelType.warning,
            icon: Icons.warning_amber,
          ),
          trailing: Row(
            children: [
              Icon(
                Icons.person,
                size: AppIconSize.md,
                color: AppColors.textSecondaryLight,
              ),
              SizedBox(width: AppSpacing.xxs),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary500,
                child: Text(
                  'S', // Staff
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.neutral000,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Accept',
              size: ButtonSize.small,
              variant: ButtonVariant.primary,
              onPressed: () => controller.approveExpense(item.expenseId!),
            ),
            SizedBox(width: AppSpacing.xs),
            CustomButton(
              text: 'Reject',
              size: ButtonSize.small,
              variant: ButtonVariant.danger,
              onPressed: () =>
                  _showRejectDialog(context, item.expenseId!, controller),
            ),
          ],
        ),
      );
    }

    // For tasks, use a simple card
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: AppColors.warning500),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTypography.bodyMD.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              item.subtitle,
              style: AppTypography.bodyLG.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              item.timestamp,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.warning700,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: 'Tandai Selesai',
              size: ButtonSize.small,
              variant: ButtonVariant.primary,
              onPressed: () => controller.approveTask(item.taskId!),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    String expenseId,
    NotificationController controller,
  ) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tolak Pengeluaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Berikan alasan penolakan:'),
            SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'Contoh: Bukti tidak lengkap',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                Navigator.pop(context);
                controller.rejectExpense(expenseId, noteController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Alasan penolakan harus diisi')),
                );
              }
            },
            child: Text('Tolak', style: TextStyle(color: AppColors.error500)),
          ),
        ],
      ),
    );
  }
}
