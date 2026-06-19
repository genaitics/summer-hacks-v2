import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_fin_os/core/router/app_router.dart';
import 'package:student_fin_os/features/assistant/ui/voice_assistant_sheet.dart';
import 'package:student_fin_os/features/shell/ui/alerts_sheet.dart';
import 'package:student_fin_os/features/wealth_advisor/ui/avatar_widget.dart';
import 'package:student_fin_os/features/wealth_advisor/ui/health_score_ring.dart';
import 'package:student_fin_os/providers/auth_providers.dart';
import 'package:student_fin_os/providers/wealth_advisor_providers.dart';
import 'package:student_fin_os/providers/dashboard_providers.dart';
import 'package:student_fin_os/providers/aws_providers.dart';
import 'package:student_fin_os/core/widgets/gemini_key_setup_widget.dart';

class WealthAdvisorScreen extends ConsumerStatefulWidget {
  const WealthAdvisorScreen({super.key});

  @override
  ConsumerState<WealthAdvisorScreen> createState() => _WealthAdvisorScreenState();
}

class _WealthAdvisorScreenState extends ConsumerState<WealthAdvisorScreen> {
  final TextEditingController _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _openChatWithQuery(String text) {
    if (text.trim().isEmpty) return;
    context.push(AppRoutes.chatAssistant, extra: text);
    _queryController.clear();
  }

  Future<void> _openVoiceAssistant() async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.92,
          child: VoiceAssistantSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Auth & Profile
    final user = ref.watch(authStateProvider).value;
    final String displayName = user?.displayName?.trim().isNotEmpty == true
        ? (user!.displayName!.split(' ').first)
        : 'Wealth Builder';

    // Wealth Health Data
    final health = ref.watch(wealthHealthProvider);
    final snapshot = ref.watch(dashboardSnapshotProvider);
    final prompts = ref.watch(wealthQuickPromptsProvider);

    final hasKey = ref.watch(hasGeminiKeyProvider);
    if (!hasKey) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerLowest,
              ],
            ),
          ),
          child: const SafeArea(
            child: GeminiKeySetupWidget(),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Welcome Header Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Namaste, $displayName!',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your personal AI Wealth Advisor is active.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Alerts',
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AlertsSheet(),
                              );
                            },
                            icon: const Badge(child: Icon(Icons.notifications_none, color: Colors.white)),
                          ),
                          IconButton(
                            tooltip: 'AI Voice Mode',
                            onPressed: _openVoiceAssistant,
                            icon: Icon(Icons.mic, color: colorScheme.primary),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // Avatar & Health Ring Layout
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side: Score Ring
                        HealthScoreRing(
                          score: health.score,
                          label: health.label,
                        ),
                        const SizedBox(width: 24),
                        // Right side: Avatar
                        Expanded(
                          child: Center(
                            child: AvatarWidget(
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Speech Bubble / Explanation
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 16, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'ADVISOR INSIGHT',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          health.explanation,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Financial Health Metrics Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _MetricCard(
                        title: 'Safe to Spend',
                        value: '₹${snapshot.safeToSpend.toStringAsFixed(0)}',
                        icon: Icons.check_circle_outline,
                        color: snapshot.safeToSpend >= 0 ? const Color(0xFF00C896) : const Color(0xFFFF3D00),
                      ),
                      _MetricCard(
                        title: 'Total Savings',
                        value: '₹${snapshot.totalSavings.toStringAsFixed(0)}',
                        icon: Icons.savings_outlined,
                        color: colorScheme.primary,
                      ),
                      _MetricCard(
                        title: 'Monthly Spend',
                        value: '₹${snapshot.monthlySpend.toStringAsFixed(0)}',
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.white70,
                      ),
                      _MetricCard(
                        title: 'Available Balance',
                        value: '₹${snapshot.totalBalance.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Prompts Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask about your wealth',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: prompts.map((prompt) {
                          return ActionChip(
                            label: Text(
                              prompt,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: colorScheme.outlineVariant.withOpacity(0.1),
                              ),
                            ),
                            onPressed: () => _openChatWithQuery(prompt),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom spacing for input field
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      // Sticky Chat Input Bar
      bottomSheet: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _queryController,
                    onSubmitted: _openChatWithQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask your Wealth Advisor...',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primary,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () => _openChatWithQuery(_queryController.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 16, color: color.withOpacity(0.8)),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
