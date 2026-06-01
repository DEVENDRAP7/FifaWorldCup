// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppL10nAr extends AppL10n {
  AppL10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كأس العالم 2026';

  @override
  String get navMatches => 'المباريات';

  @override
  String get navGroups => 'المجموعات';

  @override
  String get navBracket => 'خريطة الإقصاء';

  @override
  String get navContest => 'تصويت';

  @override
  String get navProfile => 'الملف';

  @override
  String get sectionLiveNow => 'مباشر الآن';

  @override
  String get sectionUpcoming => 'القادمة';

  @override
  String get sectionResults => 'النتائج';

  @override
  String get noMatches => 'لا توجد مباريات';

  @override
  String get noMatchesSub => 'عُد قريبًا قبل الانطلاق';

  @override
  String get reconnecting => 'إعادة الاتصال…';

  @override
  String get retry => 'إعادة';

  @override
  String get tbd => 'يحدد لاحقًا';

  @override
  String get vs => 'ضد';

  @override
  String get fullTime => 'نهاية المباراة';

  @override
  String get live => 'مباشر';

  @override
  String get ft => 'نهاية';

  @override
  String get countdownDays => 'يوم';

  @override
  String get countdownHours => 'ساعة';

  @override
  String get countdownMinutes => 'دقيقة';

  @override
  String get countdownSeconds => 'ثانية';

  @override
  String get fifaOfficial => 'فيفا الرسمي';

  @override
  String get kickoffIn => 'الانطلاق بعد';

  @override
  String get inProgress => 'جارٍ الآن';

  @override
  String get worldCupLabel => 'كأس العالم';

  @override
  String get totalMatches => 'مباراة';

  @override
  String get groupTeam => 'الفريق';

  @override
  String get groupPlayed => 'ل';

  @override
  String get groupWins => 'ف';

  @override
  String get groupDraws => 'ت';

  @override
  String get groupLosses => 'خ';

  @override
  String get groupGoalDiff => 'فا';

  @override
  String get groupPoints => 'نق';

  @override
  String get bracketTitle => '🏆 مرحلة الإقصاء';

  @override
  String get bracketUnavailable => 'غير متاح';

  @override
  String get bracketSub => 'يظهر بعد انتهاء دور المجموعات';

  @override
  String get roundOf32 => 'دور الـ32';

  @override
  String get roundOf16 => 'دور الـ16';

  @override
  String get quarterFinals => 'ربع النهائي';

  @override
  String get semiFinals => 'نصف النهائي';

  @override
  String get finalLabel => 'النهائي';

  @override
  String get thirdPlace => 'المركز الثالث';

  @override
  String get champion => '🏆 البطل';

  @override
  String get contestBalance => 'نقاط';

  @override
  String get contestYourTeam => 'فريقك';

  @override
  String get contestActivePicks => 'الرهانات النشطة';

  @override
  String get contestOtherMatches => 'مباريات أخرى';

  @override
  String get contestHistory => 'السجل';

  @override
  String get contestPickHome => 'المضيف';

  @override
  String get contestPickDraw => 'تعادل';

  @override
  String get contestPickAway => 'الضيف';

  @override
  String contestStakeOn(Object side) {
    return 'راهن على $side';
  }

  @override
  String get contestPlacePick => 'تأكيد';

  @override
  String get contestStakeAmount => 'النقاط للمراهنة';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'تم: $amt نقطة على $side';
  }

  @override
  String get contestPickFailed => 'فشل (نقاط غير كافية أو سبق المراهنة)';

  @override
  String get contestWon => 'ربح';

  @override
  String get contestLost => 'خسارة';

  @override
  String get contestPending => 'قيد الانتظار';

  @override
  String get settingsProfile => 'الملف';

  @override
  String get settingsActions => 'الإجراءات';

  @override
  String get settingsFavoriteTeam => 'الفريق المفضل';

  @override
  String get settingsNotSet => 'غير محدد';

  @override
  String get settingsCapsBalance => 'رصيد النقاط';

  @override
  String get settingsResetCaps => 'إعادة 1000 نقطة';

  @override
  String get settingsResetCapsSub => 'تعيد الرصيد والسجل';

  @override
  String get settingsSignOut => 'تسجيل الخروج';

  @override
  String get settingsGuest => 'زائر';

  @override
  String get settingsSignedIn => 'مسجل الدخول';

  @override
  String get settingsGuestSession => 'جلسة زائر';

  @override
  String get onboardWelcomeTitle => 'أهلاً بك';

  @override
  String get onboardSignInTitle => 'سجّل الدخول للمسابقة';

  @override
  String get onboardSignInSub => 'اكسب نقاطًا وادعم فريقك. الوضع كزائر متاح.';

  @override
  String get onboardYourName => 'اسمك';

  @override
  String get onboardSignIn => 'تسجيل الدخول';

  @override
  String get onboardGuest => 'متابعة كزائر';

  @override
  String get onboardPickTeam => 'اختر فريقك';

  @override
  String get onboardPickTeamSub =>
      'اختر المنتخب الذي تدعمه لتراهن على مبارياته.';

  @override
  String get onboardContinue => 'متابعة';

  @override
  String get matchDetailStage => 'المرحلة';

  @override
  String get matchDetailGroup => 'المجموعة';

  @override
  String get matchDetailDate => 'التاريخ';

  @override
  String get matchDetailVenue => 'الملعب';

  @override
  String get matchDetailCity => 'المدينة';

  @override
  String get matchDetailPenalties => 'ركلات الترجيح';

  @override
  String get profileYourVotes => 'أصواتك';

  @override
  String profileVotesCount(Object count) {
    return 'صوّتت على $count مباراة';
  }

  @override
  String get profileAboutSection => 'حول';

  @override
  String get profileAbout => 'حول';

  @override
  String get profileAppInfo => 'معلومات التطبيق';

  @override
  String get profilePrivacy => 'سياسة الخصوصية';

  @override
  String get profileRate => 'قيّم التطبيق';

  @override
  String get profileShare => 'شارك التطبيق';

  @override
  String get profileComingSoon => 'قريبًا';

  @override
  String get profileClearVotes => 'مسح أصواتي';

  @override
  String get profileClearVotesSub => 'يزيل جميع أصوات المباريات';

  @override
  String get profileDeleteAccount => 'حذف الحساب';

  @override
  String get profileDeleteAccountSub => 'يحذف حسابك نهائيًا';

  @override
  String get profileChooseTeam => 'اختر فريقك';

  @override
  String get profileNoVotes => 'لا توجد أصوات بعد';

  @override
  String profileYouPicked(Object pick) {
    return 'اخترت: $pick';
  }

  @override
  String get profileDraw => 'تعادل';

  @override
  String get deleteTitle => 'حذف الحساب؟';

  @override
  String get deleteBody =>
      'سيؤدي هذا إلى حذف حسابك وأصواتك نهائيًا. لا يمكن التراجع.';

  @override
  String get deleteConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get deleteEnterPassword => 'أدخل كلمة المرور.';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDelete => 'حذف';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get languageSystem => 'الإعداد الافتراضي للنظام';
}
