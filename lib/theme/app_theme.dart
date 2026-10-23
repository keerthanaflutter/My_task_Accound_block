import 'package:flutter/material.dart';

/// Background / foreground / border for one status pill. Kept as an explicit
/// triple per theme rather than an alpha blend, so the light palette can use
/// tinted backgrounds with dark text while the dark palette inverts that.
@immutable
class StatusColors {
  final Color background;
  final Color foreground;
  final Color border;

  const StatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  static StatusColors lerp(StatusColors a, StatusColors b, double t) => StatusColors(
        background: Color.lerp(a.background, b.background, t)!,
        foreground: Color.lerp(a.foreground, b.foreground, t)!,
        border: Color.lerp(a.border, b.border, t)!,
      );
}

/// Every colour the UI is allowed to use, resolved per theme. Reached through
/// `context.colors` so a widget never names a literal colour — that is what
/// made the old palette dark-only.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Surfaces
  final Color background;
  final Color cardBackground;
  final Color secondaryBackground;
  final Color divider;

  // Brand + text
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;

  // Semantic feedback
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Status pills — one per DisplayStatus (see widgets/status_style.dart).
  final StatusColors statusApproved;
  final StatusColors statusDone;
  final StatusColors statusInProgress;
  final StatusColors statusWaiting;
  final StatusColors statusDelayed;
  final StatusColors statusTodo;

  const AppColors({
    required this.background,
    required this.cardBackground,
    required this.secondaryBackground,
    required this.divider,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.statusApproved,
    required this.statusDone,
    required this.statusInProgress,
    required this.statusWaiting,
    required this.statusDelayed,
    required this.statusTodo,
  });

  /// The palette the app shipped with — dark values are unchanged so the dark
  /// UI looks exactly as it did before theming was introduced.
  static const dark = AppColors(
    background: Color(0xFF070B17),
    cardBackground: Color(0xFF222938),
    secondaryBackground: Color(0xFF1A2130),
    divider: Color(0xFF2A3244),
    primary: Color(0xFF5B5CFF),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF98A2B3),
    success: Color(0xFF12B76A),
    warning: Color(0xFFF79009),
    error: Color(0xFFF04438),
    info: Color(0xFF2E90FA),
    statusApproved: StatusColors(
      background: Color(0xFF053321),
      foreground: Color(0xFF75E0A7),
      border: Color(0xFF085D3A),
    ),
    statusDone: StatusColors(
      background: Color(0xFF053321),
      foreground: Color(0xFF75E0A7),
      border: Color(0xFF053321),
    ),
    statusInProgress: StatusColors(
      background: Color(0xFF102A56),
      foreground: Color(0xFF84CAFF),
      border: Color(0xFF102A56),
    ),
    statusWaiting: StatusColors(
      background: Color(0xFF4E1D09),
      foreground: Color(0xFFFEC84B),
      border: Color(0xFF4E1D09),
    ),
    statusDelayed: StatusColors(
      background: Color(0xFF55160C),
      foreground: Color(0xFFFDA29B),
      border: Color(0xFF55160C),
    ),
    statusTodo: StatusColors(
      background: Color(0xFF1A2130),
      foreground: Color(0xFF98A2B3),
      border: Color(0xFF1A2130),
    ),
  );

  static const light = AppColors(
    background: Color(0xFFF7F8FA),
    cardBackground: Colors.white,
    secondaryBackground: Color(0xFFEFF1F5),
    divider: Color(0xFFE4E7EC),
    primary: Color(0xFF2563EB),
    textPrimary: Color(0xFF101828),
    textSecondary: Color(0xFF667085),
    success: Color(0xFF039855),
    warning: Color(0xFFDC6803),
    error: Color(0xFFD92D20),
    info: Color(0xFF1570EF),
    statusApproved: StatusColors(
      background: Color(0xFFECFDF3),
      foreground: Color(0xFF027A48),
      border: Color(0xFFA6F4C5),
    ),
    statusDone: StatusColors(
      background: Color(0xFFECFDF3),
      foreground: Color(0xFF027A48),
      border: Color(0xFFECFDF3),
    ),
    statusInProgress: StatusColors(
      background: Color(0xFFEFF8FF),
      foreground: Color(0xFF175CD3),
      border: Color(0xFFEFF8FF),
    ),
    statusWaiting: StatusColors(
      background: Color(0xFFFFFAEB),
      foreground: Color(0xFFB54708),
      border: Color(0xFFFFFAEB),
    ),
    statusDelayed: StatusColors(
      background: Color(0xFFFEF3F2),
      foreground: Color(0xFFB42318),
      border: Color(0xFFFEF3F2),
    ),
    statusTodo: StatusColors(
      background: Color(0xFFF2F4F7),
      foreground: Color(0xFF475467),
      border: Color(0xFFF2F4F7),
    ),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? cardBackground,
    Color? secondaryBackground,
    Color? divider,
    Color? primary,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    StatusColors? statusApproved,
    StatusColors? statusDone,
    StatusColors? statusInProgress,
    StatusColors? statusWaiting,
    StatusColors? statusDelayed,
    StatusColors? statusTodo,
  }) =>
      AppColors(
        background: background ?? this.background,
        cardBackground: cardBackground ?? this.cardBackground,
        secondaryBackground: secondaryBackground ?? this.secondaryBackground,
        divider: divider ?? this.divider,
        primary: primary ?? this.primary,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        error: error ?? this.error,
        info: info ?? this.info,
        statusApproved: statusApproved ?? this.statusApproved,
        statusDone: statusDone ?? this.statusDone,
        statusInProgress: statusInProgress ?? this.statusInProgress,
        statusWaiting: statusWaiting ?? this.statusWaiting,
        statusDelayed: statusDelayed ?? this.statusDelayed,
        statusTodo: statusTodo ?? this.statusTodo,
      );

  /// Drives the cross-fade when [MaterialApp] animates between themes.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      statusApproved: StatusColors.lerp(statusApproved, other.statusApproved, t),
      statusDone: StatusColors.lerp(statusDone, other.statusDone, t),
      statusInProgress: StatusColors.lerp(statusInProgress, other.statusInProgress, t),
      statusWaiting: StatusColors.lerp(statusWaiting, other.statusWaiting, t),
      statusDelayed: StatusColors.lerp(statusDelayed, other.statusDelayed, t),
      statusTodo: StatusColors.lerp(statusTodo, other.statusTodo, t),
    );
  }
}

/// `context.colors.textPrimary` — the only sanctioned way to name a colour.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}

class AppTheme {
  // Border radii are theme-independent, so they stay compile-time constants.
  static const double borderRadiusSm = 12.0;
  static const double borderRadiusMd = 18.0;
  static const double borderRadiusLg = 24.0;
  static const double borderRadiusXl = 32.0;

  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);
  static ThemeData get light => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,
      primaryColor: c.primary,
      dividerColor: c.divider,
      extensions: [c],
      colorScheme: (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
        brightness: brightness,
        primary: c.primary,
        onPrimary: Colors.white,
        surface: c.background,
        onSurface: c.textPrimary,
        surfaceContainer: c.cardBackground,
        surfaceContainerHighest: c.secondaryBackground,
        onSurfaceVariant: c.textSecondary,
        error: c.error,
        outlineVariant: c.divider,
      ),
      // The bundled family, applied to every style in the base theme. Replaces
      // GoogleFonts.interTextTheme, which fetched the same typeface at runtime.
      textTheme: base.textTheme.apply(fontFamily: 'Inter').copyWith(
        // copyWith replaces each style outright, so the family has to be named
        // again here — apply() above does not reach a style this overwrites.
        bodyLarge: TextStyle(fontFamily: 'Inter', color: c.textPrimary),
        bodyMedium: TextStyle(fontFamily: 'Inter', color: c.textPrimary),
        bodySmall: TextStyle(fontFamily: 'Inter', color: c.textSecondary),
        titleLarge: TextStyle(
            fontFamily: 'Inter', color: c.textPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(
            fontFamily: 'Inter', color: c.textPrimary, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
            fontFamily: 'Inter', color: c.textPrimary, fontWeight: FontWeight.w500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      dividerTheme: DividerThemeData(color: c.divider, space: 1, thickness: 1),
      cardTheme: CardThemeData(
        color: c.cardBackground,
        // Light mode wants a soft shadow; the dark surfaces read better flat.
        elevation: isDark ? 4 : 1,
        shadowColor: isDark ? Colors.black : Colors.black.withValues(alpha: 0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusMd)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.secondaryBackground,
        hintStyle: TextStyle(color: c.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusLg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusLg),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.secondaryBackground,
        selectedItemColor: c.primary,
        unselectedItemColor: c.textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
