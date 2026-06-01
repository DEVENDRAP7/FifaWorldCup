import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ════════════════════════════════════════════════════════════
///  PALETTE 9 — STADIUM OFFICIAL  (Deep Blue · Trophy Gold · Pitch Red)
/// ════════════════════════════════════════════════════════════
class AppTheme {
  static const bg = Color(0xFF0A2F75);              // Deep Stadium Blue
  static const surface = Color(0xFF0E3A8F);          // Lifted stadium blue
  static const card = Color(0xFF13408C);             // Card surface
  static const border = Color(0xFF1E4FA8);
  static const text = Color(0xFFFFFFFF);             // Crisp Stadium White
  static const textSecondary = Color(0xFFCBD8F0);
  static const muted = Color(0xFF8FA3CC);
  static const mutedSoft = Color(0xFF3D5FA0);

  static const primary = Color(0xFFC8102E);          // Pitch Red
  static const gold = Color(0xFFD4AF37);             // Trophy Gold
  static const goldSoft = Color(0xFFFFD700);         // Sunray Yellow

  static const usaBlue = Color(0xFF0A2F75);
  static const usaRed = Color(0xFFC8102E);
  static const canadaRed = Color(0xFFC8102E);
  static const mexicoGreen = Color(0xFF00A877);      // Championship Teal/Emerald
  static const mexicoRed = Color(0xFFC8102E);

  static const live = Color(0xFFC8102E);
  static const win = Color(0xFF00A877);
  static const accent = Color(0xFFD4AF37);           // Gold as secondary accent

  // ─── Spacing (4pt) ────────────────────────────────────────
  static const s2 = 2.0, s4 = 4.0, s8 = 8.0, s12 = 12.0, s16 = 16.0, s20 = 20.0, s24 = 24.0, s32 = 32.0, s48 = 48.0;
  static const rSm = 8.0, rMd = 12.0, rLg = 16.0, rPill = 999.0;

  static const shadowSm = [
    BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x20000000), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const shadowMd = [
    BoxShadow(color: Color(0x55000000), blurRadius: 16, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x30000000), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static const triGradient = LinearGradient(
    colors: [usaBlue, gold, primary],     // Stadium Blue → Gold → Pitch Red
    stops: [0.0, 0.5, 1.0],
  );
  static const stageGradient = LinearGradient(
    colors: [gold, goldSoft],
  );
  static const royalGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0B1A3A), Color(0xFF1E40AF), Color(0xFF0B1A3A)],
  );

  // ─── Typography ───────────────────────────────────────────
  static TextStyle _f(double size, FontWeight w, {Color c = text, double l = -0.2, double h = 1.25}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: c, letterSpacing: l, height: h);

  static TextStyle get displayLg => _f(34, FontWeight.w900, l: -0.8);
  static TextStyle get display   => _f(28, FontWeight.w900, l: -0.6);
  static TextStyle get headline  => _f(22, FontWeight.w800, l: -0.4);
  static TextStyle get title     => _f(17, FontWeight.w700, l: -0.2);
  static TextStyle get body      => _f(14, FontWeight.w500, l: 0);
  static TextStyle get bodyBold  => _f(14, FontWeight.w700, l: 0);
  static TextStyle get caption   => _f(12, FontWeight.w500, c: muted, l: 0);
  static TextStyle get captionBold => _f(12, FontWeight.w700, c: textSecondary, l: 0.2);
  static TextStyle get overline  => _f(10, FontWeight.w800, c: muted, l: 1.4, h: 1.0);
  static TextStyle get numeric   => GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.w800, color: text, letterSpacing: -1, height: 1);

  static ThemeData light() {
    final base = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primary, secondary: accent, surface: card, error: live, onSurface: text,
      ),
      dividerColor: border,
      splashFactory: InkSparkle.splashFactory,
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: card,
        centerTitle: false,
        titleTextStyle: _f(17, FontWeight.w800, l: -0.3),
        iconTheme: const IconThemeData(color: text),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: card, surfaceTintColor: card),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: gold.withValues(alpha: .25),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => _f(11, s.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w600, c: s.contains(WidgetState.selected) ? text : muted, l: 0)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rMd)),
          textStyle: _f(14, FontWeight.w800, c: Colors.white, l: 0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rMd)),
          textStyle: _f(13, FontWeight.w700, l: 0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: primary, width: 1.5)),
      ),
    );
  }

  static ThemeData dark() => light();
}
