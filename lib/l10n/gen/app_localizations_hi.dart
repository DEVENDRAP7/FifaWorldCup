// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppL10nHi extends AppL10n {
  AppL10nHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'विश्व कप 2026';

  @override
  String get navMatches => 'मैच';

  @override
  String get navGroups => 'ग्रुप';

  @override
  String get navBracket => 'ब्रैकेट';

  @override
  String get navContest => 'वोट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get sectionLiveNow => 'लाइव';

  @override
  String get sectionUpcoming => 'आगामी';

  @override
  String get sectionResults => 'परिणाम';

  @override
  String get noMatches => 'कोई मैच नहीं';

  @override
  String get noMatchesSub => 'किकऑफ़ के पास वापस आएं';

  @override
  String get reconnecting => 'पुनः कनेक्ट हो रहा…';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get tbd => 'तय नहीं';

  @override
  String get vs => 'बनाम';

  @override
  String get fullTime => 'पूर्ण समय';

  @override
  String get live => 'लाइव';

  @override
  String get ft => 'FT';

  @override
  String get countdownDays => 'दिन';

  @override
  String get countdownHours => 'घंटे';

  @override
  String get countdownMinutes => 'मिनट';

  @override
  String get countdownSeconds => 'सेकंड';

  @override
  String get fifaOfficial => 'फीफा आधिकारिक';

  @override
  String get kickoffIn => 'किकऑफ़ में';

  @override
  String get inProgress => 'जारी है';

  @override
  String get worldCupLabel => 'विश्व कप';

  @override
  String get totalMatches => 'मैच';

  @override
  String get groupTeam => 'टीम';

  @override
  String get groupPlayed => 'खे';

  @override
  String get groupWins => 'जी';

  @override
  String get groupDraws => 'ड्र';

  @override
  String get groupLosses => 'हा';

  @override
  String get groupGoalDiff => 'गोल अं';

  @override
  String get groupPoints => 'अंक';

  @override
  String get bracketTitle => '🏆 नॉकआउट ब्रैकेट';

  @override
  String get bracketUnavailable => 'ब्रैकेट उपलब्ध नहीं';

  @override
  String get bracketSub => 'ग्रुप चरण के बाद दिखेगा';

  @override
  String get roundOf32 => 'राउंड ऑफ़ 32';

  @override
  String get roundOf16 => 'राउंड ऑफ़ 16';

  @override
  String get quarterFinals => 'क्वार्टर फ़ाइनल';

  @override
  String get semiFinals => 'सेमी फ़ाइनल';

  @override
  String get finalLabel => 'फ़ाइनल';

  @override
  String get thirdPlace => 'तीसरा स्थान';

  @override
  String get champion => '🏆 चैंपियन';

  @override
  String get contestBalance => 'कैप्स';

  @override
  String get contestYourTeam => 'आपकी टीम';

  @override
  String get contestActivePicks => 'सक्रिय पिक्स';

  @override
  String get contestOtherMatches => 'अन्य मैच';

  @override
  String get contestHistory => 'इतिहास';

  @override
  String get contestPickHome => 'होम';

  @override
  String get contestPickDraw => 'ड्र';

  @override
  String get contestPickAway => 'अवे';

  @override
  String contestStakeOn(Object side) {
    return '$side पर दांव';
  }

  @override
  String get contestPlacePick => 'पुष्टि करें';

  @override
  String get contestStakeAmount => 'दांव के कैप्स';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'दांव: $amt कैप्स $side पर';
  }

  @override
  String get contestPickFailed => 'विफल (अपर्याप्त कैप्स या पहले से दांव)';

  @override
  String get contestWon => 'जीत';

  @override
  String get contestLost => 'हार';

  @override
  String get contestPending => 'लंबित';

  @override
  String get settingsProfile => 'प्रोफ़ाइल';

  @override
  String get settingsActions => 'क्रियाएं';

  @override
  String get settingsFavoriteTeam => 'पसंदीदा टीम';

  @override
  String get settingsNotSet => 'सेट नहीं';

  @override
  String get settingsCapsBalance => 'कैप्स शेष';

  @override
  String get settingsResetCaps => '1000 पर रीसेट';

  @override
  String get settingsResetCapsSub => 'शेष और इतिहास रीसेट';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsGuest => 'अतिथि';

  @override
  String get settingsSignedIn => 'साइन इन';

  @override
  String get settingsGuestSession => 'अतिथि सत्र';

  @override
  String get onboardWelcomeTitle => 'स्वागत है';

  @override
  String get onboardSignInTitle => 'कॉन्टेस्ट के लिए साइन इन करें';

  @override
  String get onboardSignInSub =>
      'कैप्स कमाएं, अपनी टीम का समर्थन करें। अतिथि मोड भी उपलब्ध।';

  @override
  String get onboardYourName => 'आपका नाम';

  @override
  String get onboardSignIn => 'साइन इन';

  @override
  String get onboardGuest => 'अतिथि के रूप में जारी';

  @override
  String get onboardPickTeam => 'अपनी टीम चुनें';

  @override
  String get onboardPickTeamSub =>
      'अपनी पसंदीदा टीम चुनें ताकि उनके मैचों पर कैप्स दांव लगा सकें।';

  @override
  String get onboardContinue => 'जारी रखें';

  @override
  String get matchDetailStage => 'चरण';

  @override
  String get matchDetailGroup => 'ग्रुप';

  @override
  String get matchDetailDate => 'तारीख';

  @override
  String get matchDetailVenue => 'स्टेडियम';

  @override
  String get matchDetailCity => 'शहर';

  @override
  String get matchDetailPenalties => 'पेनल्टी';

  @override
  String get profileYourVotes => 'आपके वोट';

  @override
  String profileVotesCount(Object count) {
    return '$count मैच पर वोट किया';
  }

  @override
  String get profileAboutSection => 'परिचय';

  @override
  String get profileAbout => 'परिचय';

  @override
  String get profileAppInfo => 'ऐप जानकारी';

  @override
  String get profilePrivacy => 'गोपनीयता नीति';

  @override
  String get profileRate => 'ऐप को रेट करें';

  @override
  String get profileShare => 'ऐप शेयर करें';

  @override
  String get profileComingSoon => 'जल्द आ रहा है';

  @override
  String get profileClearVotes => 'मेरे वोट हटाएँ';

  @override
  String get profileClearVotesSub => 'आपके सभी मैच वोट हटा देता है';

  @override
  String get profileDeleteAccount => 'खाता हटाएँ';

  @override
  String get profileDeleteAccountSub => 'आपका खाता स्थायी रूप से हटा देता है';

  @override
  String get profileChooseTeam => 'अपनी टीम चुनें';

  @override
  String get profileNoVotes => 'अभी कोई वोट नहीं';

  @override
  String profileYouPicked(Object pick) {
    return 'आपने चुना: $pick';
  }

  @override
  String get profileDraw => 'ड्रॉ';

  @override
  String get deleteTitle => 'खाता हटाएँ?';

  @override
  String get deleteBody =>
      'यह आपका खाता और वोट स्थायी रूप से हटा देगा। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get deleteConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get deleteEnterPassword => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';
}
