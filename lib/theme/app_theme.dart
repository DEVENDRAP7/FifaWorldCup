import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ════════════════════════════════════════════════════════════
///  PITCH — football stadium look. Grass-green field, white pitch
///  lines, stadium-board yellow, scoreboard type (Teko + Saira).
/// ════════════════════════════════════════════════════════════
class AppTheme {
  // Field surfaces
  static const bg = Color(0xFF0B5E34);          // grass green
  static const bgStripe = Color(0xFF0A5530);    // mown stripe (darker)
  static const deep = Color(0xFF063C20);        // dark panel / header bars
  static const card = Color(0xFF0C4A29);        // scoreboard panel
  static const paper = Color(0xFF0E5331);       // lighter panel
  static const surface = Color(0xFF0F5C36);     // chip fill
  static const border = Color(0x40FFFFFF);      // pitch line (white @ 25%)
  static const line = Color(0x59FFFFFF);        // brighter line

  // Text
  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFE6F4EC);
  static const muted = Color(0xFFAFCDBC);
  static const mutedSoft = Color(0x1FFFFFFF);
  static const ink = Color(0xFFFFFFFF);

  // Accents — stadium board yellow
  static const accent = Color(0xFFF4C430);
  static const gold = Color(0xFFF4C430);
  static const goldSoft = Color(0xFFFFDA63);
  static const primary = Color(0xFFF4C430);
  static const inputAccent = Color(0xFFF4C430);

  static const live = Color(0xFFFF4136);        // live red
  static const red = Color(0xFFFF4136);
  static const win = Color(0xFF7DE48A);         // bright pitch green-white

  static const usaBlue = Color(0xFFF4C430);
  static const usaRed = Color(0xFFFF4136);
  static const canadaRed = Color(0xFFFF4136);
  static const mexicoGreen = Color(0xFF7DE48A);
  static const mexicoRed = Color(0xFFFF4136);

  // ─── Spacing ──────────────────────────────────────────────
  static const s2 = 2.0, s4 = 4.0, s8 = 8.0, s12 = 12.0, s16 = 16.0, s20 = 20.0, s24 = 24.0, s32 = 32.0, s48 = 48.0;
  static const rSm = 6.0, rMd = 10.0, rLg = 14.0, rPill = 999.0;

  static const shadowSm = [
    BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const shadowMd = [
    BoxShadow(color: Color(0x4D000000), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const triGradient = LinearGradient(colors: [accent, goldSoft]);
  static const stageGradient = LinearGradient(colors: [accent, goldSoft]);
  static const royalGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [deep, Color(0xFF0B5E34), deep],
  );

  // ─── Typography ───────────────────────────────────────────
  // Teko — tall scoreboard numerals / big titles
  static TextStyle _score(double size, FontWeight w, {Color c = text, double l = 0.5, double h = 0.95}) =>
      GoogleFonts.teko(fontSize: size, fontWeight: w, color: c, letterSpacing: l, height: h);
  // Saira — sporty condensed headlines / labels
  static TextStyle _head(double size, FontWeight w, {Color c = text, double l = 0.4, double h = 1.1}) =>
      GoogleFonts.saira(fontSize: size, fontWeight: w, color: c, letterSpacing: l, height: h);
  // Inter — body / meta
  static TextStyle _body(double size, FontWeight w, {Color c = text, double l = 0, double h = 1.3}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: c, letterSpacing: l, height: h);

  static TextStyle get displayLg => _score(52, FontWeight.w700);
  static TextStyle get display   => _score(40, FontWeight.w700);
  static TextStyle get headline  => _head(22, FontWeight.w700, l: 0.3);
  static TextStyle get title     => _head(17, FontWeight.w600, l: 0.3);
  static TextStyle get teamName  => _head(18, FontWeight.w600, l: 0.4);
  static TextStyle get body      => _body(14, FontWeight.w500);
  static TextStyle get bodyBold  => _body(14, FontWeight.w700);
  static TextStyle get caption   => _body(12, FontWeight.w500, c: muted);
  static TextStyle get captionBold => _body(12, FontWeight.w700, c: textSecondary);
  static TextStyle get overline  => _head(11, FontWeight.w700, c: textSecondary, l: 1.4, h: 1.0);
  static TextStyle get numeric   => GoogleFonts.teko(fontSize: 38, fontWeight: FontWeight.w600, color: text, letterSpacing: 0, height: 0.9);

  static ThemeData light() {
    final base = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      cardColor: card,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: accent, secondary: win, surface: card, error: red, onSurface: text,
      ),
      dividerColor: border,
      splashFactory: InkSparkle.splashFactory,
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
        backgroundColor: deep,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: deep,
        centerTitle: true,
        titleTextStyle: _head(20, FontWeight.w700, l: 0.6),
        iconTheme: const IconThemeData(color: text),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: card, surfaceTintColor: card),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: deep,
        indicatorColor: accent.withValues(alpha: .25),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => _head(11, s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w600, c: s.contains(WidgetState.selected) ? accent : muted, l: 0.5)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: deep,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rMd)),
          textStyle: _head(14, FontWeight.w700, c: deep, l: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rMd)),
          textStyle: _head(13, FontWeight.w700, l: 0.3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: deep,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: WidgetStateColor.resolveWith((s) =>
            s.contains(WidgetState.focused) ? accent : muted),
        labelStyle: const TextStyle(color: muted, fontWeight: FontWeight.w600),
        floatingLabelStyle: const TextStyle(color: accent, fontWeight: FontWeight.w800),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: border, width: 1.2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: accent, width: 2.2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: red, width: 1.4)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(rMd), borderSide: const BorderSide(color: red, width: 2.2)),
      ),
    );
  }

  static ThemeData dark() => light();
}

/// Mown-grass vertical stripes for the pitch background.
class PitchStripes extends StatelessWidget {
  final Widget child;
  const PitchStripes({super.key, required this.child});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _StripePainter(), child: child);
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stripeW = 46.0;
    final p = Paint()..color = AppTheme.bgStripe;
    canvas.drawRect(Offset.zero & size, Paint()..color = AppTheme.bg);
    for (double x = 0; x < size.width; x += stripeW * 2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, stripeW, size.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
