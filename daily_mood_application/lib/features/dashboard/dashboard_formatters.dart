import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/models/mood_entry.dart';

bool isToday(MoodEntryModel entry, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final date = entry.createdAt;
  return current.year == date.year &&
      current.month == date.month &&
      current.day == date.day;
}

String formatMonth(DateTime date) {
  const months = [
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
  return '${months[date.month - 1]} ${date.year}';
}

String formatCompactDate(DateTime date) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${days[date.weekday - 1]}, ${date.day} ${_shortMonth(date.month)}';
}

String historyGroupLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final localDate = date.toLocal();
  final day = DateTime(localDate.year, localDate.month, localDate.day);

  if (day == today) return 'Today';
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';

  return '${_shortMonth(day.month)} ${day.day}, ${day.year}';
}

String formatEntryDate(DateTime date) {
  final now = DateTime.now();
  final local = date.toLocal();
  final hour = local.hour == 0
      ? 12
      : local.hour > 12
      ? local.hour - 12
      : local.hour;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';

  if (now.year == local.year &&
      now.month == local.month &&
      now.day == local.day) {
    return '$hour:$minute $period';
  }

  return '${_shortMonth(local.month)} ${local.day}';
}

String moodLabel(int score) {
  return switch (score) {
    1 => 'Awful',
    2 => 'Bad',
    3 => 'Okay',
    4 => 'Good',
    _ => 'Great',
  };
}

Color moodColor(int score) {
  return switch (score) {
    1 => AppColors.accentRed,
    2 => AppColors.chartOrange,
    3 => AppColors.accentYellow,
    4 => AppColors.chartGreen,
    _ => AppColors.primaryPurple,
  };
}

String _shortMonth(int month) {
  const months = [
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
  return months[month - 1];
}
