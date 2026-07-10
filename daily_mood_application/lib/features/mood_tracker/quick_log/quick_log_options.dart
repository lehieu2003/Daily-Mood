import 'package:flutter/material.dart';

class MoodOption {
  const MoodOption({
    required this.score,
    required this.label,
    required this.assetPath,
    required this.background,
    required this.foreground,
  });

  final int score;
  final String label;
  final String assetPath;
  final Color background;
  final Color foreground;
}

class SubEmotionOption {
  const SubEmotionOption({
    required this.id,
    required this.label,
    required this.assetPath,
    required this.parentMoodScore,
  });

  final int id;
  final String label;
  final String assetPath;
  final int parentMoodScore;
}

const moodOptions = [
  MoodOption(
    score: 1,
    label: 'Awful',
    assetPath: 'assets/emojis/face-screaming-in-fear.png',
    background: Color(0xFFFCA5A5),
    foreground: Color(0xFF991B1B),
  ),
  MoodOption(
    score: 2,
    label: 'Bad',
    assetPath: 'assets/emojis/disappointed-face.png',
    background: Color(0xFFFED7AA),
    foreground: Color(0xFF9A3412),
  ),
  MoodOption(
    score: 3,
    label: 'Okay',
    assetPath: 'assets/emojis/neutral-face.png',
    background: Color(0xFFFEF08A),
    foreground: Color(0xFF854D0E),
  ),
  MoodOption(
    score: 4,
    label: 'Good',
    assetPath: 'assets/emojis/smiling-face.png',
    background: Color(0xFFBAE6FD),
    foreground: Color(0xFF075985),
  ),
  MoodOption(
    score: 5,
    label: 'Excellent',
    assetPath: 'assets/emojis/Property 1=star-struck.png',
    background: Color(0xFFA7F3D0),
    foreground: Color(0xFF065F46),
  ),
];

const subEmotionOptions = [
  SubEmotionOption(
    id: 1,
    label: 'Angry',
    assetPath: 'assets/emojis/pouting-face.png',
    parentMoodScore: 1,
  ),
  SubEmotionOption(
    id: 2,
    label: 'Overwhelmed',
    assetPath: 'assets/emojis/woozy-face.png',
    parentMoodScore: 1,
  ),
  SubEmotionOption(
    id: 3,
    label: 'Sad',
    assetPath: 'assets/emojis/disappointed-face.png',
    parentMoodScore: 1,
  ),
  SubEmotionOption(
    id: 4,
    label: 'Anxious',
    assetPath: 'assets/emojis/anxious-face-with-sweat.png',
    parentMoodScore: 2,
  ),
  SubEmotionOption(
    id: 5,
    label: 'Tired',
    assetPath: 'assets/emojis/grinning-face-with-sweat.png',
    parentMoodScore: 2,
  ),
  SubEmotionOption(
    id: 6,
    label: 'Down',
    assetPath: 'assets/emojis/nauseated-face.png',
    parentMoodScore: 2,
  ),
  SubEmotionOption(
    id: 7,
    label: 'Neutral',
    assetPath: 'assets/emojis/neutral-face.png',
    parentMoodScore: 3,
  ),
  SubEmotionOption(
    id: 8,
    label: 'Confused',
    assetPath: 'assets/emojis/confused-face.png',
    parentMoodScore: 3,
  ),
  SubEmotionOption(
    id: 9,
    label: 'Routine',
    assetPath: 'assets/emojis/face-with-open-mouth.png',
    parentMoodScore: 3,
  ),
  SubEmotionOption(
    id: 10,
    label: 'Calm',
    assetPath: 'assets/emojis/smiling-face-with-halo.png',
    parentMoodScore: 4,
  ),
  SubEmotionOption(
    id: 11,
    label: 'Satisfied',
    assetPath: 'assets/emojis/smiling-face-with-hearts.png',
    parentMoodScore: 4,
  ),
  SubEmotionOption(
    id: 12,
    label: 'Stable',
    assetPath: 'assets/emojis/hugging-face.png',
    parentMoodScore: 4,
  ),
  SubEmotionOption(
    id: 13,
    label: 'Excited',
    assetPath: 'assets/emojis/winking-face-with-tongue.png',
    parentMoodScore: 5,
  ),
  SubEmotionOption(
    id: 14,
    label: 'Proud',
    assetPath: 'assets/emojis/smiling-face-with-heart-eyes.png',
    parentMoodScore: 5,
  ),
  SubEmotionOption(
    id: 15,
    label: 'Energized',
    assetPath: 'assets/emojis/Property 1=star-struck.png',
    parentMoodScore: 5,
  ),
];
