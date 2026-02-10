import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Tag data class
class _TrendingTag {
  final String id;
  final String label;
  final IconData? icon;

  const _TrendingTag({required this.id, required this.label, this.icon});
}

/// Trending Tags component matching React's TrendingTags.tsx exactly
class TrendingTags extends StatelessWidget {
  final Function(String)? onTagClick;

  const TrendingTags({super.key, this.onTagClick});

  static const List<_TrendingTag> _tags = [
    _TrendingTag(id: '1', label: '#VintageAlger', icon: Icons.auto_awesome),
    _TrendingTag(id: '2', label: '#CaftanModern', icon: Icons.checkroom),
    _TrendingTag(id: '3', label: '#StreetWear', icon: Icons.trending_up),
    _TrendingTag(id: '4', label: '#LuxeOran', icon: Icons.watch),
    _TrendingTag(id: '5', label: '#HijabStyle'),
    _TrendingTag(id: '6', label: '#Karakou2024'),
    _TrendingTag(id: '7', label: '#SneakersAlgeria'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Section header with icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                l10n?.translate('home.trends') ?? 'Tendances',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Horizontal scrolling tags with accent color styling
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tags.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final tag = _tags[index];
              return GestureDetector(
                onTap: () => onTagClick?.call(tag.label),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tag.icon != null) ...[
                        Icon(
                          tag.icon,
                          size: 14,
                          color: AppColors.accentForeground,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        tag.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accentForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
