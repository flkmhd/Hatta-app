import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Sell Page placeholder - matching React's SellPage.tsx multi-step form
class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  int _currentStep = 0;

  final List<String> _stepKeys = [
    'sell.step1',
    'sell.step2',
    'sell.step3',
    'sell.step4',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n?.translate('sell.title') ?? 'Vends ton article'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(4, (index) {
                  final isActive = index <= _currentStep;
                  final label =
                      l10n?.translate(_stepKeys[index]) ?? 'Step ${index + 1}';

                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.mutedForeground,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Step Content
            Expanded(child: _buildStepContent(context, l10n)),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: const Text('Retour'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < 3) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          // TODO: Submit product
                        }
                      },
                      child: Text(
                        _currentStep < 3
                            ? l10n?.translate('sell.continue') ?? 'Continuer'
                            : l10n?.translate('sell.publish') ??
                                  'Publier l\'article',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, AppLocalizations? l10n) {
    switch (_currentStep) {
      case 0:
        return _buildPhotosStep(context, l10n);
      case 1:
        return _buildDetailsStep(context, l10n);
      case 2:
        return _buildConditionStep(context, l10n);
      case 3:
        return _buildPriceStep(context, l10n);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPhotosStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Open image picker
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 64,
                        color: AppColors.mutedForeground,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.translate('sell.upload') ??
                            'Ajoute jusqu\'à 5 photos',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.mutedForeground),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n?.translate('sell.upload_hint') ??
                            'Glisse ou clique pour ajouter',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep(BuildContext context, AppLocalizations? l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText:
                  l10n?.translate('sell.item_title') ?? 'Titre de l\'article',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.category') ?? 'Catégorie',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.description') ?? 'Description',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.size') ?? 'Taille',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.translate('search.condition') ?? 'État',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildConditionOption(
            context,
            l10n?.translate('condition.new') ?? 'Neuf',
            'Avec étiquette, jamais porté',
            true,
          ),
          const SizedBox(height: 12),
          _buildConditionOption(
            context,
            l10n?.translate('condition.very_good') ?? 'Très bon',
            'Quelques utilisations, aucun défaut',
            false,
          ),
          const SizedBox(height: 12),
          _buildConditionOption(
            context,
            l10n?.translate('condition.good') ?? 'Bon',
            'Usure légère mais bien entretenu',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildConditionOption(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle condition selection
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceStep(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              labelText: l10n?.translate('sell.price') ?? 'Prix en DZD',
              suffixText: 'DZD',
            ),
          ),
        ],
      ),
    );
  }
}
