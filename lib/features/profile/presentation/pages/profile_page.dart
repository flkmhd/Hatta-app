import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Profile Page placeholder - matching React's ProfilePage.tsx
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar and Edit button
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amina Benali',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@amina_style',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // TODO: Edit profile
                        },
                        child: Text(
                          l10n?.translate('profile.edit') ?? 'Modifier',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        context,
                        '127',
                        l10n?.translate('profile.followers') ?? 'Abonnés',
                      ),
                      Container(width: 1, height: 30, color: AppColors.border),
                      _buildStat(
                        context,
                        '89',
                        l10n?.translate('profile.following') ?? 'Abonnements',
                      ),
                      Container(width: 1, height: 30, color: AppColors.border),
                      _buildStat(
                        context,
                        '42',
                        l10n?.translate('profile.sales') ?? 'Mes ventes',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedForeground,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: l10n?.translate('profile.selling') ?? 'En vente'),
                  Tab(text: l10n?.translate('profile.sold') ?? 'Vendus'),
                  Tab(text: l10n?.translate('profile.favorites') ?? 'Favoris'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmptyState(
                    context,
                    Icons.sell_outlined,
                    'Aucun article en vente',
                  ),
                  _buildEmptyState(
                    context,
                    Icons.check_circle_outline,
                    'Aucun article vendu',
                  ),
                  _buildEmptyState(
                    context,
                    Icons.favorite_outline,
                    'Aucun favori',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.mutedForeground),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
