import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ════════════════════════════════════════════════════════════
///  PITCH · FIFA 26 — bright grass field, electric-lime accents,
///  translucent glass cards edged with the FIFA-26 tri-colour
///  (red · yellow · green · blue) sweep. Scoreboard type (Teko +
///  Saira). Matches the match-ball icon's coloured panels.
/// ════════════════════════════════════════════════════════════
class AppTheme {
  // Field surfaces — bright pitch grass
  static const bgTop = Color(0xFF28B257);       // bright grass (top of gradient)
  static const bg = Color(0xFF19984A);          // pitch base (scaffold)
  static const bgBot = Color(0xFF0D7338);       // deeper grass (bottom)
  static const bgStripe = Color(0x12FFFFFF);    // subtle mown stripe (white @ 7%)
  static const deep = Color(0xFF0B1A12);         // dark bar — headers / nav / bands
  static const card = Color(0x7A0A1811);         // translucent glass card (~48%)
  static const band = Color(0x4D000000);         // translucent header/footer band
  static const cardHi = Color(0xFF12281C);       // raised opaque panel
  static const panel = Color(0xFF0E1F16);        // sheets / dialogs (opaque)
  static const paper = Color(0xFF12281C);        // lighter panel
  static const surface = Color(0x14FFFFFF);      // glass chip fill (white @ 8%)
  static const border = Color(0x33FFFFFF);       // hairline (white @ 20%)
  static const line = Color(0x52FFFFFF);         // brighter hairline

  // Text
  static const text = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFEAF3EC);
  static const muted = Color(0xFFA6C6B4);
  static const mutedSoft = Color(0x1FFFFFFF);
  static const ink = Color(0xFFFFFFFF);

  // Accents — electric lime
  static const accent = Color(0xFFC8FF3D);       // electric lime
  static const gold = Color(0xFFC8FF3D);          // repurposed → lime
  static const goldSoft = Color(0xFFE4FF9A);     // light lime highlight
  static const goldDeep = Color(0xFF9FD42A);     // deep lime
  static const primary = Color(0xFFC8FF3D);
  static const inputAccent = Color(0xFFC8FF3D);
  static const mint = Color(0xFF39D353);          // positive / win

  static const live = Color(0xFFFF4D5E);          // live red
  static const red = Color(0xFFFF4D5E);
  static const win = Color(0xFF39D353);           // win green

  // FIFA-26 tri-colour (ball panels): red · yellow · green · blue
  static const fifaRed = Color(0xFFFF4D5E);
  static const fifaYellow = Color(0xFFFFD93D);
  static const fifaGreen = Color(0xFF39D353);
  static const fifaBlue = Color(0xFF3D9BFF);

  static const usaBlue = Color(0xFF3D9BFF);
  static const usaRed = Color(0xFFFF4D5E);
  static const canadaRed = Color(0xFFFF4D5E);
  static const mexicoGreen = Color(0xFF39D353);
  static const mexicoRed = Color(0xFFFF4D5E);

  // ─── Spacing ──────────────────────────────────────────────
  static const s2 = 2.0, s4 = 4.0, s8 = 8.0, s12 = 12.0, s16 = 16.0, s20 = 20.0, s24 = 24.0, s32 = 32.0, s48 = 48.0;
  static const rSm = 8.0, rMd = 12.0, rLg = 16.0, rPill = 999.0;

  static const shadowSm = [
    BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
  static const shadowMd = [
    BoxShadow(color: Color(0x59000000), blurRadius: 28, offset: Offset(0, 12)),
  ];

  // FIFA-26 tri-colour sweep — card / panel borders
  static const fifaGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [fifaRed, fifaYellow, fifaGreen, fifaBlue],
    stops: [0.0, 0.30, 0.62, 1.0],
  );
  static const triGradient = fifaGradient;
  static const stageGradient = LinearGradient(colors: [goldSoft, accent]);
  static const royalGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [bgTop, bg, bgBot],
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
        primary: accent, onPrimary: deep, secondary: mint, surface: panel, error: red, onSurface: text,
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
      dialogTheme: DialogThemeData(
        backgroundColor: panel, surfaceTintColor: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rLg)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: panel, surfaceTintColor: panel),
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

/// Bright pitch backdrop — vivid grass gradient with alternating
/// mown stripes, a warm gold light-bloom up top, and a gentle
/// vignette for depth.
class PitchStripes extends StatelessWidget {
  final Widget child;
  const PitchStripes({super.key, required this.child});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _PitchPainter(), child: child);
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base vivid grass gradient (bright top → deeper bottom).
    canvas.drawRect(rect, Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [AppTheme.bgTop, AppTheme.bg, AppTheme.bgBot],
      stops: [0.0, 0.55, 1.0],
    ).createShader(rect));

    // Mown stripes — subtle alternating bands across the field.
    final bandW = size.width / 6;
    final stripe = Paint()..color = AppTheme.bgStripe;
    for (double x = 0; x < size.width; x += bandW * 2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, bandW, size.height), stripe);
    }

    // Lime light-bloom near the top — stadium floodlight wash.
    final glowCenter = Offset(size.width * 0.5, size.height * 0.10);
    canvas.drawRect(rect, Paint()..shader = RadialGradient(
      center: const Alignment(0, -0.82), radius: 1.0,
      colors: const [Color(0x24C8FF3D), Color(0x00000000)],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: glowCenter, radius: size.width * 0.95)));

    // Gentle corner vignette for depth so the bright grass isn't flat.
    canvas.drawRect(rect, Paint()..shader = RadialGradient(
      center: Alignment.center, radius: 1.0,
      colors: const [Color(0x00000000), Color(0x40000000)],
      stops: const [0.55, 1.0],
    ).createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tri-colour gradient border around a translucent panel. The outer box
/// is painted with [gradient]; [width] of it shows as the border, and the
/// child is clipped to the inner radius. Used for FIFA-26 match cards / hero.
class GradientBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final double width;
  final Gradient gradient;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  const GradientBorder({
    super.key,
    required this.child,
    this.radius = AppTheme.rLg,
    this.width = 1.6,
    this.gradient = AppTheme.fifaGradient,
    this.boxShadow,
    this.margin,
  });
  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        padding: EdgeInsets.all(width),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - width),
          child: child,
        ),
      );
}
