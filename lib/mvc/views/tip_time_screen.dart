import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/tip_time_controller.dart';
import '../models/tip_calculator.dart';

/// Tip calculator UI (View).
class TipTimeScreen extends StatefulWidget {
  const TipTimeScreen({super.key});

  @override
  State<TipTimeScreen> createState() => _TipTimeScreenState();
}

class _TipTimeScreenState extends State<TipTimeScreen> {
  final TipTimeController _tipController = TipTimeController();
  final FocusNode _billFocus = FocusNode();
  final FocusNode _tipFocus = FocusNode();

  @override
  void dispose() {
    _tipFocus.dispose();
    _billFocus.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = (width * 0.055).clamp(18.0, 36.0);
    final maxContentWidth = width.clamp(0.0, 520.0);

    return ListenableBuilder(
      listenable: _tipController,
      builder: (context, _) {
        final tip = TipCalculator.calculateTip(
          amount: _tipController.amount,
          tipPercent: _tipController.tipPercent,
          roundUp: _tipController.roundUp,
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Tip Time')),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.surface,
                  Color.lerp(scheme.surface, scheme.primaryContainer, 0.12)!,
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPad,
                          20,
                          horizontalPad,
                          28 + bottomInset,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ScreenHeader(theme: theme, scheme: scheme),
                            SizedBox(
                              height: (constraints.maxHeight * 0.04).clamp(
                                16.0,
                                32.0,
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  22,
                                  20,
                                  20,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Details',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 18),
                                    _TipTextField(
                                      focusNode: _billFocus,
                                      label: 'Bill amount',
                                      hint: '0.00',
                                      icon: Icons.restaurant_menu_outlined,
                                      textInputAction: TextInputAction.next,
                                      onChanged: _tipController.setAmountInput,
                                      onSubmitted: (_) => FocusScope.of(
                                        context,
                                      ).requestFocus(_tipFocus),
                                    ),
                                    const SizedBox(height: 16),
                                    _TipTextField(
                                      focusNode: _tipFocus,
                                      label: 'Tip (%)',
                                      hint: '15',
                                      icon: Icons.percent_outlined,
                                      textInputAction: TextInputAction.done,
                                      onChanged: _tipController.setTipInput,
                                      onSubmitted: (_) =>
                                          FocusScope.of(context).unfocus(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: scheme.outlineVariant.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    _RoundUpRow(
                                      roundUp: _tipController.roundUp,
                                      onChanged: _tipController.setRoundUp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (constraints.maxHeight * 0.06).clamp(
                                20.0,
                                48.0,
                              ),
                            ),
                            _TipResultPanel(tip: tip, scheme: scheme),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.theme, required this.scheme});

  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.calculate_rounded,
            size: 32,
            color: scheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Calculate tip',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the bill and your preferred percentage.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _TipTextField extends StatelessWidget {
  const _TipTextField({
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.textInputAction,
    required this.onChanged,
    required this.onSubmitted,
  });

  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.titleMedium,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
          minHeight: 48,
        ),
      ),
    );
  }
}

class _TipResultPanel extends StatelessWidget {
  const _TipResultPanel({required this.tip, required this.scheme});

  final String tip;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.onPrimaryContainer.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TIP AMOUNT',
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.75,
              color: scheme.onPrimaryContainer,
            ),
            child: Text(
              tip,
              key: ValueKey<String>(tip),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundUpRow extends StatelessWidget {
  const _RoundUpRow({required this.roundUp, required this.onChanged});

  final bool roundUp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      container: true,
      label: 'Round up tip',
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => onChanged(!roundUp),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 22,
                  color: scheme.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Round up tip?',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Round to the next whole currency unit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(value: roundUp, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
