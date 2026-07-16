import 'package:daily_mood_application/app/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loads Vietnamese strings from the widget locale', (
    tester,
  ) async {
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate],
        home: Builder(
          builder: (context) {
            l10n = context.l10n;
            return Text(l10n.settings);
          },
        ),
      ),
    );

    expect(find.text('Cài đặt'), findsOneWidget);
    expect(l10n.home, 'Trang chủ');
    expect(l10n.moodLabel(5), 'Tuyệt');
    expect(l10n.activityLabel('Work'), 'Công việc');
  });

  test('delegate falls back to English for unsupported locales', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('fr'));

    expect(l10n.locale.languageCode, 'en');
    expect(l10n.settings, 'Settings');
    expect(l10n.appearance, 'Appearance');
    expect(l10n.darkMode, 'Dark');
    expect(l10n.moodLabel(1), 'Awful');
  });
}
