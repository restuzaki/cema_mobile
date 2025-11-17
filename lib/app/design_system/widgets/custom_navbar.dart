// lib/app/design_system/widgets/custom_navbar.dart
import 'package:flutter/material.dart';
import '../design_system.dart';

/// Custom navigation bar widget for bottom navigation
class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<CustomNavbarItem> items;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.neutral900,
        boxShadow: AppShadows.shadowLg,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _NavbarItemWidget(
              item: items[index],
              isActive: currentIndex == index,
              onTap: () => onTap(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarItemWidget extends StatelessWidget {
  final CustomNavbarItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavbarItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  size: AppIconSize.lg,
                  color: isActive ? AppColors.primary500 : AppColors.neutral000,
                ),
                if (isActive)
                  Positioned(
                    top: -16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary500,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppRadius.full),
                            bottomRight: Radius.circular(AppRadius.full),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              item.label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.primary500 : AppColors.neutral000,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation bar item model
class CustomNavbarItem {
  final String label;
  final IconData icon;
  final int? badgeCount;

  const CustomNavbarItem({
    required this.label,
    required this.icon,
    this.badgeCount,
  });
}
