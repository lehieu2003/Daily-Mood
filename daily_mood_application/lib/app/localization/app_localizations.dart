import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('vi')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return localizations ?? const AppLocalizations(Locale('en'));
  }

  bool get isVietnamese => locale.languageCode == 'vi';

  String get appTitle => _text('appTitle');
  String get home => _text('home');
  String get stats => _text('stats');
  String get addMood => _text('addMood');
  String get logMood => _text('logMood');
  String get greetingLead => _text('greetingLead');
  String get goodMorning => _text('goodMorning');
  String get goodAfternoon => _text('goodAfternoon');
  String get goodNight => _text('goodNight');
  String get history => _text('history');
  String get setting => _text('setting');
  String get settings => _text('settings');
  String get settingsSubtitle => _text('settingsSubtitle');
  String get privacyLock => _text('privacyLock');
  String get lockNow => _text('lockNow');
  String get lockNowSubtitle => _text('lockNowSubtitle');
  String get pinAndBiometrics => _text('pinAndBiometrics');
  String get pinAndBiometricsSubtitle => _text('pinAndBiometricsSubtitle');
  String get dataControl => _text('dataControl');
  String get exportData => _text('exportData');
  String get exportDataSubtitle => _text('exportDataSubtitle');
  String get importData => _text('importData');
  String get importDataSubtitle => _text('importDataSubtitle');
  String get deleteAllLocalData => _text('deleteAllLocalData');
  String get deleteAllLocalDataSubtitle => _text('deleteAllLocalDataSubtitle');
  String get experience => _text('experience');
  String get hapticFeedback => _text('hapticFeedback');
  String get appearance => _text('appearance');
  String get appearanceSubtitle => _text('appearanceSubtitle');
  String get systemMode => _text('systemMode');
  String get lightMode => _text('lightMode');
  String get darkMode => _text('darkMode');
  String get language => _text('language');
  String get languageSubtitle => _text('languageSubtitle');
  String get english => _text('english');
  String get vietnamese => _text('vietnamese');
  String get cancel => _text('cancel');
  String get delete => _text('delete');
  String get archive => _text('archive');
  String get restore => _text('restore');
  String get save => _text('save');
  String get continueLabel => _text('continueLabel');
  String get skipAndSave => _text('skipAndSave');
  String get back => _text('back');
  String get close => _text('close');
  String get gotIt => _text('gotIt');
  String get saved => _text('saved');
  String get all => _text('all');
  String get today => _text('today');
  String get yesterday => _text('yesterday');
  String get sevenDays => _text('sevenDays');
  String get thirtyDays => _text('thirtyDays');
  String get allMoods => _text('allMoods');
  String get searchNotesTagsEmotions => _text('searchNotesTagsEmotions');
  String get clearFilters => _text('clearFilters');
  String get noMatchingEntries => _text('noMatchingEntries');
  String get noMatchingEntriesBody => _text('noMatchingEntriesBody');
  String get loadingMoodHistory => _text('loadingMoodHistory');
  String get couldNotLoadMoodHistory => _text('couldNotLoadMoodHistory');
  String get loadingMoodEntries => _text('loadingMoodEntries');
  String get noMoodEntriesYet => _text('noMoodEntriesYet');
  String get addFirstMood => _text('addFirstMood');
  String get todaysCheckIn => _text('todaysCheckIn');
  String get moodChart => _text('moodChart');
  String get checkIn => _text('checkIn');
  String get connectWithNature => _text('connectWithNature');
  String get weeklyTrend => _text('weeklyTrend');
  String get weeklyTrendUnlocked => _text('weeklyTrendUnlocked');
  String get opensStatsTab => _text('opensStatsTab');
  String get weeklyTrendReady => _text('weeklyTrendReady');
  String get reflectionStreak => _text('reflectionStreak');
  String get streakNoPressure => _text('streakNoPressure');
  String get dailyReflection => _text('dailyReflection');
  String get dailyReflectionSubtitle => _text('dailyReflectionSubtitle');
  String get dailyReflectionPrompt => _text('dailyReflectionPrompt');
  String get reflectionHint => _text('reflectionHint');
  String get saveReflection => _text('saveReflection');
  String get editReflection => _text('editReflection');
  String get dailyChallenge => _text('dailyChallenge');
  String get dailyChallengeSubtitle => _text('dailyChallengeSubtitle');
  String get dailyChallengeCompleted => _text('dailyChallengeCompleted');
  String get markChallengeDone => _text('markChallengeDone');
  String get dailyChallengeDone => _text('dailyChallengeDone');
  String get noneYet => _text('noneYet');
  String get moodGarden => _text('moodGarden');
  String get moodGardenSubtitle => _text('moodGardenSubtitle');
  String get gardenNoReset => _text('gardenNoReset');
  String get viewGardenJourney => _text('viewGardenJourney');
  String get gardenJourney => _text('gardenJourney');
  String get gardenJourneySubtitle => _text('gardenJourneySubtitle');
  String get currentStage => _text('currentStage');
  String get unlockedStage => _text('unlockedStage');
  String get lockedStage => _text('lockedStage');
  String get onThisDay => _text('onThisDay');
  String get onThisDayTitle => _text('onThisDayTitle');
  String get onThisDaySubtitle => _text('onThisDaySubtitle');
  String get weeklyReflectionReport => _text('weeklyReflectionReport');
  String get weeklyReflectionReportSubtitle =>
      _text('weeklyReflectionReportSubtitle');
  String get weeklyReportEmpty => _text('weeklyReportEmpty');
  String get weeklyReportSparse => _text('weeklyReportSparse');
  String get weeklyReportSteady => _text('weeklyReportSteady');
  String get weeklyReportReflected => _text('weeklyReportReflected');
  String get weeklyReportAverageMoodLabel =>
      _text('weeklyReportAverageMoodLabel');
  String get topEmotion => _text('topEmotion');
  String get topReason => _text('topReason');
  String get dashboardEmptyBody => _text('dashboardEmptyBody');
  String get noCheckInsToday => _text('noCheckInsToday');
  String get tip => _text('tip');
  String get natureTipBody => _text('natureTipBody');
  String get recentAverage => _text('recentAverage');
  String get lastCheckIn => _text('lastCheckIn');
  String get noNoteAdded => _text('noNoteAdded');
  String get noHistoryYet => _text('noHistoryYet');
  String get historyEmptyBody => _text('historyEmptyBody');
  String get edit => _text('edit');
  String get notePrefix => _text('notePrefix');
  String get readMore => _text('readMore');
  String get loadingMoodInsights => _text('loadingMoodInsights');
  String get couldNotLoadMoodInsights => _text('couldNotLoadMoodInsights');
  String get week => _text('week');
  String get month => _text('month');
  String get year => _text('year');
  String get allStats => _text('allStats');
  String get moodStats => _text('moodStats');
  String get topActivities => _text('topActivities');
  String get guidedInsights => _text('guidedInsights');
  String get guidedInsightsSubtitle => _text('guidedInsightsSubtitle');
  String get trendShiftInsightTitle => _text('trendShiftInsightTitle');
  String get starterInsightTitle => _text('starterInsightTitle');
  String get starterInsightBody => _text('starterInsightBody');
  String get previousPeriod => _text('previousPeriod');
  String get nextPeriod => _text('nextPeriod');
  String get moodStatistics => _text('moodStatistics');
  String get moodDistributionEmpty => _text('moodDistributionEmpty');
  String get moodCalendar => _text('moodCalendar');
  String get activityImpact => _text('activityImpact');
  String get monthlyHeatmapEmpty => _text('monthlyHeatmapEmpty');
  String get activityCorrelationEmpty => _text('activityCorrelationEmpty');
  String get whatsYourMoodNow => _text('whatsYourMoodNow');
  String get quickLogMoodSubtitle => _text('quickLogMoodSubtitle');
  String get selectAtLeastOneEmotion => _text('selectAtLeastOneEmotion');
  String get quickLogReasonTitle => _text('quickLogReasonTitle');
  String get quickLogReasonSubtitle => _text('quickLogReasonSubtitle');
  String get quickLogNoteTitle => _text('quickLogNoteTitle');
  String get quickLogNoteSubtitle => _text('quickLogNoteSubtitle');
  String get couldNotSaveMoodEntry => _text('couldNotSaveMoodEntry');
  String get searchEmotions => _text('searchEmotions');
  String get recentlyUsed => _text('recentlyUsed');
  String get allEmotions => _text('allEmotions');
  String get searchReasons => _text('searchReasons');
  String get addAReason => _text('addAReason');
  String get allReasons => _text('allReasons');
  String get more => _text('more');
  String get noteHint => _text('noteHint');
  String get addPhoto => _text('addPhoto');
  String get addVoice => _text('addVoice');
  String get stopVoice => _text('stopVoice');
  String get microphonePermissionRequired =>
      _text('microphonePermissionRequired');
  String get photoTooLarge => _text('photoTooLarge');
  String get photoProcessingFailed => _text('photoProcessingFailed');
  String get photoAttached => _text('photoAttached');
  String get voiceAttached => _text('voiceAttached');
  String get replacePhoto => _text('replacePhoto');
  String get reasons => _text('reasons');
  String get emotions => _text('emotions');
  String get attachments => _text('attachments');
  String get addContextForMood => _text('addContextForMood');
  String get deleteEntryQuestion => _text('deleteEntryQuestion');
  String get deleteEntryBody => _text('deleteEntryBody');
  String get noReasonsYet => _text('noReasonsYet');
  String get noEmotionsYet => _text('noEmotionsYet');
  String get noReasonsAvailable => _text('noReasonsAvailable');
  String get noReasonsSelected => _text('noReasonsSelected');
  String get exportDataBody => _text('exportDataBody');
  String get exportFailed => _text('exportFailed');
  String get importFailed => _text('importFailed');
  String get localDataDeleted => _text('localDataDeleted');
  String get manageCustomTags => _text('manageCustomTags');
  String get manageCustomTagsSubtitle => _text('manageCustomTagsSubtitle');
  String get manageCustomTagsBody => _text('manageCustomTagsBody');
  String get noCustomTags => _text('noCustomTags');
  String get activeTag => _text('activeTag');
  String get archivedTag => _text('archivedTag');
  String get customTagUpdateFailed => _text('customTagUpdateFailed');
  String get dailyReminder => _text('dailyReminder');
  String get dailyReminderOff => _text('dailyReminderOff');
  String get deleteAllLocalDataBody => _text('deleteAllLocalDataBody');
  String get typeDeleteToConfirm => _text('typeDeleteToConfirm');
  String get hapticsOn => _text('hapticsOn');
  String get hapticsOff => _text('hapticsOff');
  String get lockTitle => _text('lockTitle');
  String get enterPasscodePin => _text('enterPasscodePin');
  String get useBiometrics => _text('useBiometrics');
  String get setPinTitle => _text('setPinTitle');
  String get confirmPinTitle => _text('confirmPinTitle');
  String get pinSavedTitle => _text('pinSavedTitle');
  String get protectYourDiary => _text('protectYourDiary');
  String get chooseFourDigitPin => _text('chooseFourDigitPin');
  String get pinsDidNotMatch => _text('pinsDidNotMatch');
  String get couldNotSavePin => _text('couldNotSavePin');
  String get selectMood => _text('selectMood');
  String get pickMoodFirst => _text('pickMoodFirst');
  String get selected => _text('selected');
  String selectedCount(int count) {
    return isVietnamese ? 'Đã chọn ($count)' : 'Selected ($count)';
  }

  String get clearAll => _text('clearAll');
  String get reasonTooLong => _text('reasonTooLong');
  String get couldNotAddReason => _text('couldNotAddReason');

  String checkInTitleForDate(DateTime selectedDate, DateTime todayDate) {
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final todayOnly = DateTime(todayDate.year, todayDate.month, todayDate.day);

    if (selected == todayOnly) return todaysCheckIn;
    if (selected == todayOnly.subtract(const Duration(days: 1))) {
      return isVietnamese ? 'Check-in hôm qua' : "Yesterday's check-in";
    }

    return isVietnamese
        ? 'Check-in ${selected.day} ${shortMonth(selected.month)}'
        : '${shortMonth(selected.month)} ${selected.day} check-in';
  }

  String weeklyTrendSummary(int count, double average) {
    return isVietnamese
        ? '$count mục đã sẵn sàng - Trung bình ${average.toStringAsFixed(1)}'
        : '$count entries ready - Average ${average.toStringAsFixed(1)}';
  }

  String streakDayCount(int count) {
    return isVietnamese
        ? '$count ngày nhịp ghi'
        : '$count day ${count == 1 ? 'rhythm' : 'rhythm'}';
  }

  String streakHelper(int count) {
    if (count == 0) {
      return isVietnamese
          ? 'Ghi một tâm trạng khi bạn sẵn sàng.'
          : 'Log a mood whenever you are ready.';
    }
    return isVietnamese
        ? 'Bạn đã ghi đều gần đây. Không cần hoàn hảo.'
        : 'You have checked in recently. No perfect streak required.';
  }

  String todayFelt(String mood) {
    return isVietnamese ? 'Hôm nay: $mood' : 'Today: $mood';
  }

  String commonEmotion(String emotion) {
    return isVietnamese ? 'Cảm xúc: $emotion' : 'Emotion: $emotion';
  }

  String commonReason(String reason) {
    return isVietnamese ? 'Lý do: $reason' : 'Reason: $reason';
  }

  String gardenStageLabel(String stage) {
    if (!isVietnamese) return stage;
    return switch (stage) {
      'Seed' => 'Hạt mầm',
      'Sprout' => 'Mầm non',
      'Leafy' => 'Nhiều lá',
      'Bloom' => 'Nở hoa',
      'Flourishing' => 'Tươi tốt',
      _ => stage,
    };
  }

  String gardenGrowthSummary({
    required int activeDays,
    required int reflections,
  }) {
    return isVietnamese
        ? '$activeDays ngày ghi mood - $reflections phản chiếu'
        : '$activeDays mood days - $reflections reflections';
  }

  String gardenRecentSummary(int count) {
    return isVietnamese
        ? '$count ngày chăm sóc gần đây'
        : '$count recent care days';
  }

  String gardenRequiredPoints(int points) {
    return isVietnamese
        ? 'Mở ở $points điểm phát triển'
        : 'Unlocks at $points growth points';
  }

  String weeklyReportRange(DateTime start, DateTime end) {
    final startText = isVietnamese
        ? '${start.day} ${shortMonth(start.month)}'
        : '${shortMonth(start.month)} ${start.day}';
    final endText = isVietnamese
        ? '${end.day} ${shortMonth(end.month)}'
        : '${shortMonth(end.month)} ${end.day}';
    return '$startText - $endText';
  }

  String onThisDayDate(DateTime date) {
    return isVietnamese
        ? '${date.day} ${shortMonth(date.month)} ${date.year}'
        : '${shortMonth(date.month)} ${date.day}, ${date.year}';
  }

  String weeklyReportCheckIns(int count, int days) {
    return isVietnamese
        ? '$count check-in trong $days ngày'
        : '$count check-ins across $days days';
  }

  String weeklyReportReflections(int count) {
    return isVietnamese ? '$count phản chiếu' : '$count reflections';
  }

  String weeklyReportAverage(double average) {
    return average.toStringAsFixed(1);
  }

  String dailyReminderOn(String time) {
    return isVietnamese
        ? 'Nhắc cục bộ mỗi ngày lúc $time.'
        : 'Local daily nudge at $time.';
  }

  String dailyChallengeTitle(String id) {
    return switch (id) {
      'goOutside' => _text('dailyChallengeGoOutside'),
      'gratitude' => _text('dailyChallengeGratitude'),
      'stretch' => _text('dailyChallengeStretch'),
      'drinkWater' => _text('dailyChallengeDrinkWater'),
      'breathe' => _text('dailyChallengeBreathe'),
      'shortWalk' => _text('dailyChallengeShortWalk'),
      _ => _text('dailyChallengeBreathe'),
    };
  }

  String entryCount(int count) {
    return isVietnamese ? '$count mục' : '$count entries';
  }

  String entryMultiplier(int count) {
    return '${count}x';
  }

  String logMoreMoods(int remaining) {
    return isVietnamese
        ? 'Ghi thêm $remaining mục tâm trạng để mở biểu đồ.'
        : 'Log $remaining more mood ${remaining == 1 ? 'entry' : 'entries'} to unlock the chart.';
  }

  String logMoreMoodsForTrend(int remaining) {
    return isVietnamese
        ? 'Ghi thêm $remaining tâm trạng để mở xu hướng đầu tiên.'
        : remaining == 1
        ? 'Log 1 more mood to unlock your first trend.'
        : 'Log $remaining more moods to unlock your first trend.';
  }

  String moodTooltip(double mood) {
    return isVietnamese
        ? 'Tâm trạng ${mood.toStringAsFixed(1)}'
        : 'Mood ${mood.toStringAsFixed(1)}';
  }

  String averageMood(double mood) {
    return isVietnamese
        ? 'TB ${mood.toStringAsFixed(1)}'
        : '${mood.toStringAsFixed(1)} avg';
  }

  String activityCorrelationSemantics({
    required String activityName,
    required int count,
    required double average,
  }) {
    return isVietnamese
        ? '$activityName, $count mục, tâm trạng trung bình ${average.toStringAsFixed(1)}'
        : '$activityName, $count entries, average mood ${average.toStringAsFixed(1)}';
  }

  String activityLiftInsightTitle(String activityName) {
    return isVietnamese
        ? '$activityName xuất hiện cùng tâm trạng cao hơn'
        : '$activityName showed up with higher moods';
  }

  String activityLiftInsightBody({
    required String activityName,
    required double activityAverage,
    required double overallAverage,
  }) {
    return isVietnamese
        ? '$activityName trung bình ${activityAverage.toStringAsFixed(1)}, so với mức chung ${overallAverage.toStringAsFixed(1)}. Bạn có thể ghi chú điều gì đã hỗ trợ những lúc đó.'
        : '$activityName averaged ${activityAverage.toStringAsFixed(1)}, compared with your overall ${overallAverage.toStringAsFixed(1)}. You might note what felt supportive in those moments.';
  }

  String activityWeightInsightTitle(String activityName) {
    return isVietnamese
        ? '$activityName xuất hiện cùng tâm trạng thấp hơn'
        : '$activityName showed up with lower moods';
  }

  String activityWeightInsightBody({
    required String activityName,
    required double activityAverage,
    required double overallAverage,
  }) {
    return isVietnamese
        ? '$activityName trung bình ${activityAverage.toStringAsFixed(1)}, thấp hơn mức chung ${overallAverage.toStringAsFixed(1)}. Lần tới bạn có thể thêm một chi tiết nhỏ về điều khiến ngày đó nặng hơn.'
        : '$activityName averaged ${activityAverage.toStringAsFixed(1)}, below your overall ${overallAverage.toStringAsFixed(1)}. Next time, one extra detail may help you spot what felt heavier.';
  }

  String trendShiftInsightBody({
    required double recentAverage,
    required double earlierAverage,
  }) {
    final direction = recentAverage >= earlierAverage;
    return isVietnamese
        ? direction
              ? 'Các ngày gần đây trung bình ${recentAverage.toStringAsFixed(1)}, cao hơn phần đầu kỳ ${earlierAverage.toStringAsFixed(1)}. Hãy nhìn lại điều gì đã giúp.'
              : 'Các ngày gần đây trung bình ${recentAverage.toStringAsFixed(1)}, thấp hơn phần đầu kỳ ${earlierAverage.toStringAsFixed(1)}. Một ghi chú ngắn về ngủ, năng lượng hoặc áp lực có thể hữu ích.'
        : direction
        ? 'Recent days averaged ${recentAverage.toStringAsFixed(1)}, up from ${earlierAverage.toStringAsFixed(1)} earlier. You may want to look back at what helped.'
        : 'Recent days averaged ${recentAverage.toStringAsFixed(1)}, down from ${earlierAverage.toStringAsFixed(1)} earlier. A short note about sleep, energy, or stress may help later.';
  }

  String pinErrorMessage(String message) {
    return switch (message) {
      "PINs didn't match. Please start again." => pinsDidNotMatch,
      'Could not save your PIN. Please try again.' => couldNotSavePin,
      _ => message,
    };
  }

  String entryReflectionLead() {
    return isVietnamese ? 'Bạn cảm thấy ' : 'You felt ';
  }

  String entryReflectionMood(int score) {
    return isVietnamese
        ? score <= 2
              ? 'Thất vọng, Bối rối'
              : 'Bình tĩnh, Tràn năng lượng'
        : score <= 2
        ? 'Disappointed, Confused'
        : 'Calm, Energized';
  }

  String entryReflectionReasonLead() {
    return isVietnamese ? '\nVì ' : '\nBecause of ';
  }

  String entryReflectionReason(int score) {
    return isVietnamese
        ? score <= 2
              ? 'Mối quan hệ'
              : 'Công việc'
        : score <= 2
        ? 'Relationships'
        : 'Work';
  }

  String quickLogEmotionTitle(String mood) {
    return isVietnamese
        ? 'Chọn cảm xúc khiến bạn thấy\n$mood'
        : 'Choose the emotions that make\nyou feel $mood';
  }

  String exportReady(String fileName) {
    return isVietnamese
        ? 'Tệp xuất đã sẵn sàng: $fileName'
        : 'Export file ready: $fileName';
  }

  String importFailedWithMessage(String message) {
    return isVietnamese ? 'Nhập thất bại: $message' : 'Import failed: $message';
  }

  String importSummary({
    required String fileName,
    required int added,
    required int updated,
    required int skipped,
  }) {
    return isVietnamese
        ? 'Đã nhập $fileName: thêm $added, cập nhật $updated, bỏ qua $skipped.'
        : 'Imported $fileName: $added added, $updated updated, $skipped skipped.';
  }

  String customTagArchived(String name) {
    return isVietnamese ? 'Đã lưu trữ $name.' : 'Archived $name.';
  }

  String customTagRestored(String name) {
    return isVietnamese ? 'Đã khôi phục $name.' : 'Restored $name.';
  }

  String moodLabel(int score) {
    final labels = isVietnamese ? _viMoodLabels : _enMoodLabels;
    return labels[score] ?? labels[3]!;
  }

  String moodFeelingLabel(int? score) {
    final labels = isVietnamese ? _viMoodFeelingLabels : _enMoodFeelingLabels;
    return labels[score] ?? labels[3]!;
  }

  String subEmotionLabel(int id, String fallback) {
    final labels = isVietnamese ? _viSubEmotionLabels : _enSubEmotionLabels;
    return labels[id] ?? fallback;
  }

  String activityLabel(String name) {
    final labels = isVietnamese ? _viActivityLabels : _enActivityLabels;
    return labels[name] ?? name;
  }

  String categoryLabel(String category) {
    final labels = isVietnamese ? _viCategoryLabels : _enCategoryLabels;
    return labels[category] ?? category;
  }

  String shortMonth(int month) {
    final months = isVietnamese ? _viShortMonths : _enShortMonths;
    return months[month - 1];
  }

  String monthName(int month) {
    final months = isVietnamese ? _viMonths : _enMonths;
    return months[month - 1];
  }

  String weekdayShort(int weekday) {
    final days = isVietnamese ? _viWeekdays : _enWeekdays;
    return days[weekday - 1];
  }

  String _text(String key) {
    final table = isVietnamese ? _vi : _en;
    return table[key] ?? _en[key] ?? key;
  }
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final languageCode = isSupported(locale) ? locale.languageCode : 'en';
    return AppLocalizations(Locale(languageCode));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

const _en = {
  'appTitle': 'Daily Mood',
  'home': 'Home',
  'stats': 'Stats',
  'addMood': 'Add mood',
  'logMood': 'Log mood',
  'greetingLead': 'Hey, ',
  'goodMorning': 'Good morning',
  'goodAfternoon': 'Good afternoon',
  'goodNight': 'Good night',
  'history': 'History',
  'setting': 'Setting',
  'settings': 'Settings',
  'settingsSubtitle': 'Local privacy, data control, and app preferences.',
  'privacyLock': 'Privacy lock',
  'lockNow': 'Lock now',
  'lockNowSubtitle': 'Require PIN or biometrics before continuing.',
  'pinAndBiometrics': 'PIN & biometrics',
  'pinAndBiometricsSubtitle': 'PIN setup exists; change controls arrive next.',
  'dataControl': 'Data control',
  'exportData': 'Export data',
  'exportDataSubtitle': 'Create a readable JSON or CSV backup file.',
  'importData': 'Import data',
  'importDataSubtitle': 'Restore a JSON or CSV backup file.',
  'deleteAllLocalData': 'Delete all local data',
  'deleteAllLocalDataSubtitle':
      'Permanent local reset will require confirmation.',
  'experience': 'Experience',
  'appearance': 'Appearance',
  'appearanceSubtitle': 'Match your device or choose a fixed theme.',
  'systemMode': 'System',
  'lightMode': 'Light',
  'darkMode': 'Dark',
  'hapticFeedback': 'Haptic feedback',
  'language': 'Language',
  'languageSubtitle': 'Choose the app display language.',
  'english': 'English',
  'vietnamese': 'Tiếng Việt',
  'cancel': 'Cancel',
  'delete': 'Delete',
  'archive': 'Archive',
  'restore': 'Restore',
  'save': 'Save',
  'continueLabel': 'Continue',
  'skipAndSave': 'Skip and Save',
  'back': 'Back',
  'close': 'Close',
  'gotIt': 'Got it',
  'saved': 'Saved',
  'all': 'All',
  'today': 'Today',
  'yesterday': 'Yesterday',
  'sevenDays': '7 days',
  'thirtyDays': '30 days',
  'allMoods': 'All moods',
  'searchNotesTagsEmotions': 'Search notes, tags, or emotions',
  'clearFilters': 'Clear filters',
  'noMatchingEntries': 'No matching entries',
  'noMatchingEntriesBody':
      'Try clearing a filter or searching another note, tag, or emotion.',
  'loadingMoodHistory': 'Loading mood history',
  'couldNotLoadMoodHistory': 'Could not load mood history.',
  'loadingMoodEntries': 'Loading your mood entries',
  'noMoodEntriesYet': 'No mood entries yet',
  'addFirstMood': 'Add first mood',
  'todaysCheckIn': "Today's check-in",
  'moodChart': 'Mood chart',
  'checkIn': 'Check-in',
  'connectWithNature': 'Connect with nature',
  'weeklyTrend': 'Weekly trend',
  'weeklyTrendUnlocked': 'Weekly trend unlocked',
  'opensStatsTab': 'Opens the Stats tab',
  'weeklyTrendReady': 'Weekly trend is ready for the next analytics slice.',
  'reflectionStreak': 'Reflection streak',
  'streakNoPressure': 'Private and pressure-free',
  'dailyReflection': 'Daily reflection',
  'dailyReflectionSubtitle': 'One sentence to remember the day.',
  'dailyReflectionPrompt': 'What made today better?',
  'reflectionHint': 'Write one private sentence...',
  'saveReflection': 'Save reflection',
  'editReflection': 'Update reflection',
  'dailyChallenge': 'Daily challenge',
  'dailyChallengeSubtitle': 'Optional and local. It never blocks mood logging.',
  'dailyChallengeCompleted': 'Marked complete for today.',
  'markChallengeDone': 'Mark done',
  'dailyChallengeDone': 'Done today',
  'dailyChallengeGoOutside': 'Go outside for 10 minutes',
  'dailyChallengeGratitude': 'Write one gratitude sentence',
  'dailyChallengeStretch': 'Stretch for one minute',
  'dailyChallengeDrinkWater': 'Drink a glass of water',
  'dailyChallengeBreathe': 'Breathe slowly for one minute',
  'dailyChallengeShortWalk': 'Take a short walk',
  'noneYet': 'None yet',
  'moodGarden': 'Mood garden',
  'moodGardenSubtitle': 'Gentle growth from check-ins and reflections.',
  'gardenNoReset': 'Missed days never reset it',
  'viewGardenJourney': 'View journey',
  'gardenJourney': 'Garden journey',
  'gardenJourneySubtitle': 'See every stage your tree can grow into.',
  'currentStage': 'Current stage',
  'unlockedStage': 'Unlocked',
  'lockedStage': 'Locked',
  'onThisDay': 'On this day',
  'onThisDayTitle': 'A memory from this day',
  'onThisDaySubtitle': 'A past check-in from your private history.',
  'weeklyReflectionReport': 'Weekly report',
  'weeklyReflectionReportSubtitle':
      'A private recap from this week of check-ins.',
  'weeklyReportEmpty': 'No report yet. Check in when you have a moment.',
  'weeklyReportSparse':
      'A quiet start. Add one more check-in to see a clearer pattern.',
  'weeklyReportSteady':
      'You checked in enough to notice a gentle weekly pattern.',
  'weeklyReportReflected': 'You paired check-ins with reflections this week.',
  'weeklyReportAverageMoodLabel': 'Average mood',
  'topEmotion': 'Top emotion',
  'topReason': 'Top reason',
  'dashboardEmptyBody':
      'Start with one quick check-in. Your first entry will appear here.',
  'noCheckInsToday': 'No check-ins today',
  'tip': 'Tip',
  'natureTipBody': 'Spend time outdoors, surrounded by greenery and fresh air',
  'recentAverage': 'Recent average',
  'lastCheckIn': 'Last check-in',
  'noNoteAdded': 'No note added',
  'noHistoryYet': 'No history yet',
  'historyEmptyBody':
      'Your saved mood entries will appear here after check-ins.',
  'edit': 'Edit',
  'notePrefix': 'Note: ',
  'readMore': '+ Read more',
  'loadingMoodInsights': 'Loading mood insights',
  'couldNotLoadMoodInsights': 'Could not load mood insights.',
  'week': 'Week',
  'month': 'Month',
  'year': 'Year',
  'allStats': 'All',
  'moodStats': 'Mood Stats',
  'topActivities': 'Top Activities',
  'guidedInsights': 'Guided insights',
  'guidedInsightsSubtitle':
      'Generated privately from your local mood patterns, not medical advice.',
  'trendShiftInsightTitle': 'Your recent mood shifted',
  'starterInsightTitle': 'More check-ins will make this clearer',
  'starterInsightBody':
      'A few more moods with tags or notes will help the app reflect patterns back to you.',
  'previousPeriod': 'Previous period',
  'nextPeriod': 'Next period',
  'moodStatistics': 'Mood Statistics',
  'moodDistributionEmpty':
      'Log moods in this period to build your mood distribution.',
  'moodCalendar': 'Mood calendar',
  'activityImpact': 'Activity impact',
  'monthlyHeatmapEmpty': 'Log moods this month to build your calendar heatmap.',
  'activityCorrelationEmpty':
      'Add reasons to mood entries to reveal activity patterns.',
  'whatsYourMoodNow': "What's your mood now?",
  'quickLogMoodSubtitle':
      'Select mood that reflects the most how you are\nfeeling at this moment.',
  'selectAtLeastOneEmotion': 'Select at least 1 emotion',
  'quickLogReasonTitle': "What's reason making you feel\nthis way?",
  'quickLogReasonSubtitle': 'Select reasons that reflected your emotions',
  'quickLogNoteTitle': 'Any thing you want to add',
  'quickLogNoteSubtitle':
      'Add your notes on any thought that reflating your mood',
  'couldNotSaveMoodEntry': 'Could not save mood entry',
  'searchEmotions': 'Search emotions',
  'recentlyUsed': 'Recently used',
  'allEmotions': 'All emotions',
  'searchReasons': 'Search reasons',
  'addAReason': 'Add a reason',
  'allReasons': 'All reasons',
  'more': 'More',
  'noteHint':
      'Write about your day, your body, or anything you want to remember.',
  'addPhoto': 'Add photo',
  'addVoice': 'Add voice',
  'stopVoice': 'Stop voice',
  'microphonePermissionRequired': 'Microphone permission is required.',
  'photoTooLarge': 'Choose a smaller photo.',
  'photoProcessingFailed': 'Could not prepare this photo. Please try another.',
  'photoAttached': 'Photo attached',
  'voiceAttached': 'Voice attached',
  'replacePhoto': 'Replace photo',
  'reasons': 'Reasons',
  'emotions': 'Emotions',
  'attachments': 'Attachments',
  'addContextForMood': 'Add context for this mood',
  'deleteEntryQuestion': 'Delete entry?',
  'deleteEntryBody': 'This hides the entry from your history and dashboard.',
  'noReasonsYet': 'No reasons yet.',
  'noEmotionsYet': 'No emotions yet.',
  'noReasonsAvailable': 'No reasons available',
  'noReasonsSelected': 'No reasons selected',
  'exportDataBody':
      'Choose a readable backup format. Photos and voice files are exported as relative path references for now.',
  'exportFailed': 'Export failed. Please try again.',
  'importFailed': 'Import failed. Please try again.',
  'localDataDeleted': 'Local data deleted.',
  'manageCustomTags': 'Manage custom tags',
  'manageCustomTagsSubtitle':
      'Archive rarely used reasons or restore them later.',
  'manageCustomTagsBody':
      'Archived custom tags are hidden from new check-ins but stay attached to older entries.',
  'noCustomTags': 'No custom tags yet.',
  'activeTag': 'Active',
  'archivedTag': 'Archived',
  'customTagUpdateFailed': 'Could not update this tag. Please try again.',
  'dailyReminder': 'Daily reminder',
  'dailyReminderOff': 'Off. Turn on a local nudge when it helps.',
  'deleteAllLocalDataBody':
      'This permanently removes mood entries, notes, media links, and custom tags from this device.',
  'typeDeleteToConfirm': 'Type DELETE to confirm.',
  'hapticsOn': 'Light taps stay enabled for mood selection.',
  'hapticsOff': 'Mood logging will stay quiet.',
  'lockTitle': 'Daily Mood',
  'enterPasscodePin': 'Enter Passcode PIN',
  'useBiometrics': 'Use biometrics',
  'setPinTitle': 'Set your PIN',
  'confirmPinTitle': 'Confirm your PIN',
  'pinSavedTitle': 'PIN saved',
  'protectYourDiary': 'Protect your diary',
  'chooseFourDigitPin': 'Choose a 4-digit PIN',
  'pinsDidNotMatch': "PINs didn't match. Please start again.",
  'couldNotSavePin': 'Could not save your PIN. Please try again.',
  'selectMood': 'Select mood',
  'pickMoodFirst': 'Pick a mood first',
  'selected': 'Selected',
  'clearAll': 'Clear all',
  'reasonTooLong': 'Reason must be 20 characters or fewer',
  'couldNotAddReason': 'Could not add reason',
};

const _vi = {
  'appTitle': 'Daily Mood',
  'home': 'Trang chủ',
  'stats': 'Thống kê',
  'addMood': 'Thêm tâm trạng',
  'logMood': 'Ghi tâm trạng',
  'greetingLead': 'Chào, ',
  'goodMorning': 'Chào buổi sáng',
  'goodAfternoon': 'Chào buổi chiều',
  'goodNight': 'Chúc ngủ ngon',
  'history': 'Lịch sử',
  'setting': 'Cài đặt',
  'settings': 'Cài đặt',
  'settingsSubtitle':
      'Quyền riêng tư cục bộ, quản lý dữ liệu và tùy chọn ứng dụng.',
  'privacyLock': 'Khóa riêng tư',
  'lockNow': 'Khóa ngay',
  'lockNowSubtitle': 'Yêu cầu PIN hoặc sinh trắc học trước khi tiếp tục.',
  'pinAndBiometrics': 'PIN & sinh trắc học',
  'pinAndBiometricsSubtitle':
      'Thiết lập PIN đã có; phần thay đổi sẽ được bổ sung sau.',
  'dataControl': 'Quản lý dữ liệu',
  'exportData': 'Xuất dữ liệu',
  'exportDataSubtitle': 'Tạo tệp sao lưu JSON hoặc CSV dễ đọc.',
  'importData': 'Nhập dữ liệu',
  'importDataSubtitle': 'Khôi phục tệp sao lưu JSON hoặc CSV.',
  'deleteAllLocalData': 'Xóa toàn bộ dữ liệu cục bộ',
  'deleteAllLocalDataSubtitle': 'Đặt lại cục bộ vĩnh viễn cần xác nhận.',
  'experience': 'Trải nghiệm',
  'appearance': 'Giao diện',
  'appearanceSubtitle': 'Theo thiết bị hoặc chọn giao diện cố định.',
  'systemMode': 'Hệ thống',
  'lightMode': 'Sáng',
  'darkMode': 'Tối',
  'hapticFeedback': 'Phản hồi rung',
  'language': 'Ngôn ngữ',
  'languageSubtitle': 'Chọn ngôn ngữ hiển thị của ứng dụng.',
  'english': 'English',
  'vietnamese': 'Tiếng Việt',
  'cancel': 'Hủy',
  'delete': 'Xóa',
  'archive': 'Lưu trữ',
  'restore': 'Khôi phục',
  'save': 'Lưu',
  'continueLabel': 'Tiếp tục',
  'skipAndSave': 'Bỏ qua và lưu',
  'back': 'Quay lại',
  'close': 'Đóng',
  'gotIt': 'Đã hiểu',
  'saved': 'Đã lưu',
  'all': 'Tất cả',
  'today': 'Hôm nay',
  'yesterday': 'Hôm qua',
  'sevenDays': '7 ngày',
  'thirtyDays': '30 ngày',
  'allMoods': 'Mọi tâm trạng',
  'searchNotesTagsEmotions': 'Tìm ghi chú, thẻ hoặc cảm xúc',
  'clearFilters': 'Xóa bộ lọc',
  'noMatchingEntries': 'Không có mục phù hợp',
  'noMatchingEntriesBody':
      'Hãy xóa bộ lọc hoặc tìm ghi chú, thẻ, cảm xúc khác.',
  'loadingMoodHistory': 'Đang tải lịch sử tâm trạng',
  'couldNotLoadMoodHistory': 'Không thể tải lịch sử tâm trạng.',
  'loadingMoodEntries': 'Đang tải các mục tâm trạng',
  'noMoodEntriesYet': 'Chưa có mục tâm trạng',
  'addFirstMood': 'Thêm tâm trạng đầu tiên',
  'todaysCheckIn': 'Check-in hôm nay',
  'moodChart': 'Biểu đồ tâm trạng',
  'checkIn': 'Check-in',
  'connectWithNature': 'Kết nối với thiên nhiên',
  'weeklyTrend': 'Xu hướng tuần',
  'weeklyTrendUnlocked': 'Đã mở xu hướng tuần',
  'opensStatsTab': 'Mở tab Thống kê',
  'weeklyTrendReady': 'Xu hướng tuần đã sẵn sàng cho phần phân tích tiếp theo.',
  'reflectionStreak': 'Nhịp ghi chép',
  'streakNoPressure': 'Riêng tư và không áp lực',
  'dailyReflection': 'Phản chiếu hôm nay',
  'dailyReflectionSubtitle': 'Một câu ngắn để nhớ về ngày này.',
  'dailyReflectionPrompt': 'Điều gì làm hôm nay tốt hơn?',
  'reflectionHint': 'Viết một câu riêng tư...',
  'saveReflection': 'Lưu phản chiếu',
  'editReflection': 'Cập nhật phản chiếu',
  'dailyChallenge': 'Thử thách hôm nay',
  'dailyChallengeSubtitle':
      'Tùy chọn và cục bộ. Không bao giờ chặn việc ghi tâm trạng.',
  'dailyChallengeCompleted': 'Đã đánh dấu hoàn thành cho hôm nay.',
  'markChallengeDone': 'Đánh dấu xong',
  'dailyChallengeDone': 'Hôm nay đã xong',
  'dailyChallengeGoOutside': 'Ra ngoài trong 10 phút',
  'dailyChallengeGratitude': 'Viết một câu biết ơn',
  'dailyChallengeStretch': 'Duỗi người trong một phút',
  'dailyChallengeDrinkWater': 'Uống một ly nước',
  'dailyChallengeBreathe': 'Thở chậm trong một phút',
  'dailyChallengeShortWalk': 'Đi bộ ngắn',
  'noneYet': 'Chưa có',
  'moodGarden': 'Vườn tâm trạng',
  'moodGardenSubtitle': 'Lớn nhẹ nhàng từ check-in và phản chiếu.',
  'gardenNoReset': 'Ngày bỏ lỡ không đặt lại vườn',
  'viewGardenJourney': 'Xem hành trình',
  'gardenJourney': 'Hành trình khu vườn',
  'gardenJourneySubtitle': 'Xem các giai đoạn cây có thể phát triển.',
  'currentStage': 'Giai đoạn hiện tại',
  'unlockedStage': 'Đã mở',
  'lockedStage': 'Đang khóa',
  'onThisDay': 'Ngày này năm xưa',
  'onThisDayTitle': 'Một kỷ niệm từ ngày này',
  'onThisDaySubtitle': 'Một check-in cũ từ lịch sử riêng tư của bạn.',
  'weeklyReflectionReport': 'Báo cáo tuần',
  'weeklyReflectionReportSubtitle':
      'Tóm tắt riêng tư từ các check-in trong tuần.',
  'weeklyReportEmpty': 'Chưa có báo cáo. Hãy check-in khi bạn có thời gian.',
  'weeklyReportSparse':
      'Một khởi đầu nhẹ. Thêm một check-in để thấy mẫu rõ hơn.',
  'weeklyReportSteady': 'Bạn đã check-in đủ để nhìn thấy nhịp tuần nhẹ nhàng.',
  'weeklyReportReflected': 'Tuần này bạn đã kết hợp check-in với phản chiếu.',
  'weeklyReportAverageMoodLabel': 'Mood trung bình',
  'topEmotion': 'Cảm xúc nổi bật',
  'topReason': 'Lý do nổi bật',
  'dashboardEmptyBody':
      'Bắt đầu bằng một lần check-in nhanh. Mục đầu tiên của bạn sẽ xuất hiện ở đây.',
  'noCheckInsToday': 'Hôm nay chưa có check-in',
  'tip': 'Gợi ý',
  'natureTipBody':
      'Dành thời gian ngoài trời, ở cạnh cây xanh và không khí trong lành',
  'recentAverage': 'Trung bình gần đây',
  'lastCheckIn': 'Check-in gần nhất',
  'noNoteAdded': 'Chưa thêm ghi chú',
  'noHistoryYet': 'Chưa có lịch sử',
  'historyEmptyBody':
      'Các mục tâm trạng đã lưu sẽ xuất hiện ở đây sau khi check-in.',
  'edit': 'Sửa',
  'notePrefix': 'Ghi chú: ',
  'readMore': '+ Đọc thêm',
  'loadingMoodInsights': 'Đang tải thông tin tâm trạng',
  'couldNotLoadMoodInsights': 'Không thể tải thông tin tâm trạng.',
  'week': 'Tuần',
  'month': 'Tháng',
  'year': 'Năm',
  'allStats': 'Tất cả',
  'moodStats': 'Tâm trạng',
  'topActivities': 'Hoạt động',
  'guidedInsights': 'Gợi ý phản chiếu',
  'guidedInsightsSubtitle':
      'Tạo riêng tư từ mô thức tâm trạng cục bộ, không phải lời khuyên y tế.',
  'trendShiftInsightTitle': 'Tâm trạng gần đây đã thay đổi',
  'starterInsightTitle': 'Thêm check-in sẽ giúp rõ hơn',
  'starterInsightBody':
      'Một vài tâm trạng kèm thẻ hoặc ghi chú sẽ giúp ứng dụng phản chiếu mô thức lại cho bạn.',
  'previousPeriod': 'Giai đoạn trước',
  'nextPeriod': 'Giai đoạn sau',
  'moodStatistics': 'Thống kê tâm trạng',
  'moodDistributionEmpty':
      'Ghi tâm trạng trong giai đoạn này để tạo phân bố tâm trạng.',
  'moodCalendar': 'Lịch tâm trạng',
  'activityImpact': 'Tác động hoạt động',
  'monthlyHeatmapEmpty': 'Ghi tâm trạng trong tháng này để tạo lịch heatmap.',
  'activityCorrelationEmpty':
      'Thêm lý do vào mục tâm trạng để thấy mô thức hoạt động.',
  'whatsYourMoodNow': 'Bây giờ bạn thấy thế nào?',
  'quickLogMoodSubtitle':
      'Chọn tâm trạng phản ánh rõ nhất cảm giác\ncủa bạn lúc này.',
  'selectAtLeastOneEmotion': 'Chọn ít nhất 1 cảm xúc',
  'quickLogReasonTitle': 'Điều gì khiến bạn cảm thấy\nnhư vậy?',
  'quickLogReasonSubtitle': 'Chọn lý do phản ánh cảm xúc của bạn',
  'quickLogNoteTitle': 'Bạn muốn thêm điều gì không?',
  'quickLogNoteSubtitle': 'Ghi lại suy nghĩ liên quan đến tâm trạng của bạn',
  'couldNotSaveMoodEntry': 'Không thể lưu tâm trạng',
  'searchEmotions': 'Tìm cảm xúc',
  'recentlyUsed': 'Dùng gần đây',
  'allEmotions': 'Tất cả cảm xúc',
  'searchReasons': 'Tìm lý do',
  'addAReason': 'Thêm lý do',
  'allReasons': 'Tất cả lý do',
  'more': 'Thêm',
  'noteHint': 'Viết về ngày của bạn, cơ thể bạn, hoặc điều muốn ghi nhớ.',
  'addPhoto': 'Thêm ảnh',
  'addVoice': 'Thêm giọng nói',
  'stopVoice': 'Dừng ghi âm',
  'microphonePermissionRequired': 'Cần quyền truy cập micro.',
  'photoTooLarge': 'Hãy chọn ảnh nhỏ hơn.',
  'photoProcessingFailed': 'Không thể xử lý ảnh này. Vui lòng thử ảnh khác.',
  'photoAttached': 'Đã đính kèm ảnh',
  'voiceAttached': 'Đã đính kèm ghi âm',
  'replacePhoto': 'Thay ảnh',
  'reasons': 'Lý do',
  'emotions': 'Cảm xúc',
  'attachments': 'Tệp đính kèm',
  'addContextForMood': 'Thêm bối cảnh cho tâm trạng này',
  'deleteEntryQuestion': 'Xóa mục này?',
  'deleteEntryBody': 'Mục này sẽ bị ẩn khỏi lịch sử và trang chủ.',
  'noReasonsYet': 'Chưa có lý do.',
  'noEmotionsYet': 'Chưa có cảm xúc.',
  'noReasonsAvailable': 'Không có lý do khả dụng',
  'noReasonsSelected': 'Chưa chọn lý do',
  'exportDataBody':
      'Chọn định dạng sao lưu dễ đọc. Hiện tại ảnh và ghi âm được xuất dưới dạng đường dẫn tương đối.',
  'exportFailed': 'Xuất dữ liệu thất bại. Vui lòng thử lại.',
  'importFailed': 'Nhập dữ liệu thất bại. Vui lòng thử lại.',
  'localDataDeleted': 'Đã xóa dữ liệu cục bộ.',
  'manageCustomTags': 'Quản lý thẻ tùy chỉnh',
  'manageCustomTagsSubtitle': 'Lưu trữ lý do ít dùng hoặc khôi phục lại sau.',
  'manageCustomTagsBody':
      'Thẻ tùy chỉnh đã lưu trữ sẽ ẩn khỏi check-in mới nhưng vẫn gắn với mục cũ.',
  'noCustomTags': 'Chưa có thẻ tùy chỉnh.',
  'activeTag': 'Đang dùng',
  'archivedTag': 'Đã lưu trữ',
  'customTagUpdateFailed': 'Không thể cập nhật thẻ này. Vui lòng thử lại.',
  'dailyReminder': 'Nhắc hằng ngày',
  'dailyReminderOff': 'Đang tắt. Bật nhắc cục bộ khi hữu ích.',
  'deleteAllLocalDataBody':
      'Thao tác này xóa vĩnh viễn tâm trạng, ghi chú, liên kết media và thẻ tùy chỉnh khỏi thiết bị này.',
  'typeDeleteToConfirm': 'Nhập DELETE để xác nhận.',
  'hapticsOn': 'Chạm nhẹ vẫn bật khi chọn tâm trạng.',
  'hapticsOff': 'Ghi tâm trạng sẽ không rung.',
  'lockTitle': 'Daily Mood',
  'enterPasscodePin': 'Nhập mã PIN',
  'useBiometrics': 'Dùng sinh trắc học',
  'setPinTitle': 'Tạo mã PIN',
  'confirmPinTitle': 'Xác nhận mã PIN',
  'pinSavedTitle': 'Đã lưu PIN',
  'protectYourDiary': 'Bảo vệ nhật ký của bạn',
  'chooseFourDigitPin': 'Chọn mã PIN 4 số',
  'pinsDidNotMatch': 'PIN không khớp. Vui lòng bắt đầu lại.',
  'couldNotSavePin': 'Không thể lưu PIN. Vui lòng thử lại.',
  'selectMood': 'Chọn tâm trạng',
  'pickMoodFirst': 'Chọn tâm trạng trước',
  'selected': 'Đã chọn',
  'clearAll': 'Xóa hết',
  'reasonTooLong': 'Lý do phải từ 20 ký tự trở xuống',
  'couldNotAddReason': 'Không thể thêm lý do',
};

const _enMoodLabels = {1: 'Awful', 2: 'Bad', 3: 'Okay', 4: 'Good', 5: 'Great'};

const _viMoodLabels = {1: 'Rất tệ', 2: 'Tệ', 3: 'Ổn', 4: 'Tốt', 5: 'Tuyệt'};

const _enMoodFeelingLabels = {
  1: 'awful',
  2: 'bad',
  3: 'neutral',
  4: 'good',
  5: 'amazing',
};

const _viMoodFeelingLabels = {
  1: 'rất tệ',
  2: 'tệ',
  3: 'bình thường',
  4: 'tốt',
  5: 'tuyệt vời',
};

const _enSubEmotionLabels = {
  1: 'Angry',
  2: 'Overwhelmed',
  3: 'Sad',
  4: 'Anxious',
  5: 'Tired',
  6: 'Down',
  7: 'Neutral',
  8: 'Confused',
  9: 'Routine',
  10: 'Calm',
  11: 'Satisfied',
  12: 'Stable',
  13: 'Excited',
  14: 'Proud',
  15: 'Energized',
};

const _viSubEmotionLabels = {
  1: 'Tức giận',
  2: 'Quá tải',
  3: 'Buồn',
  4: 'Lo âu',
  5: 'Mệt mỏi',
  6: 'Xuống tinh thần',
  7: 'Bình thường',
  8: 'Bối rối',
  9: 'Theo thói quen',
  10: 'Bình tĩnh',
  11: 'Hài lòng',
  12: 'Ổn định',
  13: 'Hào hứng',
  14: 'Tự hào',
  15: 'Tràn năng lượng',
};

const _enActivityLabels = {
  'Work': 'Work',
  'Exercise': 'Exercise',
  'Social': 'Social',
  'Sleep': 'Sleep',
  'Nutrition': 'Nutrition',
  'Family': 'Family',
  'Hobbies': 'Hobbies',
  'Self esteem': 'Self esteem',
  'Breakup': 'Breakup',
  'Weather': 'Weather',
  'Wife': 'Wife',
  'Party': 'Party',
  'Love': 'Love',
  'Food': 'Food',
};

const _viActivityLabels = {
  'Work': 'Công việc',
  'Exercise': 'Tập luyện',
  'Social': 'Xã hội',
  'Sleep': 'Giấc ngủ',
  'Nutrition': 'Dinh dưỡng',
  'Family': 'Gia đình',
  'Hobbies': 'Sở thích',
  'Self esteem': 'Tự trọng',
  'Breakup': 'Chia tay',
  'Weather': 'Thời tiết',
  'Wife': 'Vợ',
  'Party': 'Tiệc',
  'Love': 'Tình yêu',
  'Food': 'Ăn uống',
};

const _enCategoryLabels = {
  'Health': 'Health',
  'Life': 'Life',
  'Other': 'Other',
};
const _viCategoryLabels = {
  'Health': 'Sức khỏe',
  'Life': 'Cuộc sống',
  'Other': 'Khác',
};

const _enShortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _viShortMonths = [
  'Th1',
  'Th2',
  'Th3',
  'Th4',
  'Th5',
  'Th6',
  'Th7',
  'Th8',
  'Th9',
  'Th10',
  'Th11',
  'Th12',
];

const _enMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _viMonths = [
  'Tháng 1',
  'Tháng 2',
  'Tháng 3',
  'Tháng 4',
  'Tháng 5',
  'Tháng 6',
  'Tháng 7',
  'Tháng 8',
  'Tháng 9',
  'Tháng 10',
  'Tháng 11',
  'Tháng 12',
];

const _enWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _viWeekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
