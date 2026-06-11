import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final bool hapticEnabled;
  final bool voiceEnabled;
  final bool motionEnabled;
  final String defaultMode;
  final bool autoSpeakEnabled;
  final String sensitivity;
  final bool highContrastEnabled;
  final String textSize;
  final bool dailyRemindersEnabled;
  final bool streakWarningsEnabled;
  final String language;

  AppSettings({
    this.hapticEnabled = true,
    this.voiceEnabled = false,
    this.motionEnabled = false,
    this.defaultMode = 'Sign to Speech',
    this.autoSpeakEnabled = true,
    this.sensitivity = 'High',
    this.highContrastEnabled = false,
    this.textSize = 'Default',
    this.dailyRemindersEnabled = true,
    this.streakWarningsEnabled = true,
    this.language = 'English',
  });

  AppSettings copyWith({
    bool? hapticEnabled,
    bool? voiceEnabled,
    bool? motionEnabled,
    String? defaultMode,
    bool? autoSpeakEnabled,
    String? sensitivity,
    bool? highContrastEnabled,
    String? textSize,
    bool? dailyRemindersEnabled,
    bool? streakWarningsEnabled,
    String? language,
  }) {
    return AppSettings(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      motionEnabled: motionEnabled ?? this.motionEnabled,
      defaultMode: defaultMode ?? this.defaultMode,
      autoSpeakEnabled: autoSpeakEnabled ?? this.autoSpeakEnabled,
      sensitivity: sensitivity ?? this.sensitivity,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      textSize: textSize ?? this.textSize,
      dailyRemindersEnabled: dailyRemindersEnabled ?? this.dailyRemindersEnabled,
      streakWarningsEnabled: streakWarningsEnabled ?? this.streakWarningsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings());

  void toggleHaptic() => state = state.copyWith(hapticEnabled: !state.hapticEnabled);
  void toggleVoice() => state = state.copyWith(voiceEnabled: !state.voiceEnabled);
  void toggleMotion() => state = state.copyWith(motionEnabled: !state.motionEnabled);
  void toggleAutoSpeak() => state = state.copyWith(autoSpeakEnabled: !state.autoSpeakEnabled);
  void toggleHighContrast() => state = state.copyWith(highContrastEnabled: !state.highContrastEnabled);
  void toggleDailyReminders() => state = state.copyWith(dailyRemindersEnabled: !state.dailyRemindersEnabled);
  void toggleStreakWarnings() => state = state.copyWith(streakWarningsEnabled: !state.streakWarningsEnabled);

  void setDefaultMode(String val) => state = state.copyWith(defaultMode: val);
  void setSensitivity(String val) => state = state.copyWith(sensitivity: val);
  void setTextSize(String val) => state = state.copyWith(textSize: val);
  void setLanguage(String val) => state = state.copyWith(language: val);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

final settingsSearchQueryProvider = StateProvider<String>((ref) => '');
final isSettingsSearchActiveProvider = StateProvider<bool>((ref) => false);
