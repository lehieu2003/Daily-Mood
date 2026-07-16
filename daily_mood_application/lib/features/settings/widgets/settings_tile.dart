import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    final textOpacity = enabled ? 1.0 : 0.54;
    final trailingWidget = trailing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stackTrailing =
                trailingWidget != null && constraints.maxWidth < 420;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: stackTrailing
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: effectiveColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: effectiveColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: textOpacity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: textOpacity),
                            height: 1.25,
                          ),
                        ),
                        if (stackTrailing) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: trailingWidget,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!stackTrailing) ...[
                    const SizedBox(width: 12),
                    trailingWidget ??
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: enabled ? 1.0 : 0.45,
                          ),
                        ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
