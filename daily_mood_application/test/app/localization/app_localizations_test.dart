import 'package:daily_mood_application/app/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            l10n = context.l10n;
            return Text(l10n.settings);
          },
        ),
      ),
    );
    await tester.pump();

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

  test('retention loop copy is localized and privacy safe', () {
    final en = AppLocalizations(const Locale('en'));
    final vi = AppLocalizations(const Locale('vi'));

    final englishCopy = [
      en.dailyReflection,
      en.moodGarden,
      en.weeklyReflectionReport,
      en.onThisDayTitle,
      en.dailyChallenge,
      en.dailyChallengeSubtitle,
      en.guidedInsightsSubtitle,
    ];
    final vietnameseCopy = [
      vi.dailyReflection,
      vi.moodGarden,
      vi.weeklyReflectionReport,
      vi.onThisDayTitle,
      vi.dailyChallenge,
      vi.dailyChallengeSubtitle,
      vi.guidedInsightsSubtitle,
    ];

    expect(englishCopy, contains('Daily reflection'));
    expect(englishCopy, contains('A memory from this day'));
    expect(englishCopy, contains('Daily challenge'));
    expect(
      englishCopy,
      contains('Optional and local. It never blocks mood logging.'),
    );
    expect(vietnameseCopy, contains('Phản chiếu hôm nay'));
    expect(vietnameseCopy, contains('Một kỷ niệm từ ngày này'));
    expect(vietnameseCopy, contains('Thử thách hôm nay'));

    final combined = [...englishCopy, ...vietnameseCopy].join(' ').toLowerCase();
    expect(combined, isNot(contains('diagnose')));
    expect(combined, isNot(contains('treatment')));
    expect(combined, isNot(contains('remote ai')));
    expect(combined, isNot(contains('cloud')));
  });
}
