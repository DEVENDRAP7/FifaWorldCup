import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'World Cup 2026'**
  String get appTitle;

  /// No description provided for @navMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get navMatches;

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// No description provided for @navBracket.
  ///
  /// In en, this message translates to:
  /// **'Bracket'**
  String get navBracket;

  /// No description provided for @navContest.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get navContest;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @sectionLiveNow.
  ///
  /// In en, this message translates to:
  /// **'LIVE NOW'**
  String get sectionLiveNow;

  /// No description provided for @sectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get sectionUpcoming;

  /// No description provided for @sectionResults.
  ///
  /// In en, this message translates to:
  /// **'RESULTS'**
  String get sectionResults;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatches;

  /// No description provided for @noMatchesSub.
  ///
  /// In en, this message translates to:
  /// **'Check back closer to kickoff'**
  String get noMatchesSub;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get reconnecting;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @tbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get tbd;

  /// No description provided for @vs.
  ///
  /// In en, this message translates to:
  /// **'VS'**
  String get vs;

  /// No description provided for @fullTime.
  ///
  /// In en, this message translates to:
  /// **'FULL TIME'**
  String get fullTime;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @ft.
  ///
  /// In en, this message translates to:
  /// **'FT'**
  String get ft;

  /// No description provided for @countdownDays.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get countdownDays;

  /// No description provided for @countdownHours.
  ///
  /// In en, this message translates to:
  /// **'HRS'**
  String get countdownHours;

  /// No description provided for @countdownMinutes.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get countdownMinutes;

  /// No description provided for @countdownSeconds.
  ///
  /// In en, this message translates to:
  /// **'SEC'**
  String get countdownSeconds;

  /// No description provided for @fifaOfficial.
  ///
  /// In en, this message translates to:
  /// **'FIFA OFFICIAL'**
  String get fifaOfficial;

  /// No description provided for @kickoffIn.
  ///
  /// In en, this message translates to:
  /// **'KICKOFF IN'**
  String get kickoffIn;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get inProgress;

  /// No description provided for @worldCupLabel.
  ///
  /// In en, this message translates to:
  /// **'WORLD CUP'**
  String get worldCupLabel;

  /// No description provided for @totalMatches.
  ///
  /// In en, this message translates to:
  /// **'MATCHES'**
  String get totalMatches;

  /// No description provided for @groupTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get groupTeam;

  /// No description provided for @groupPlayed.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get groupPlayed;

  /// No description provided for @groupWins.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get groupWins;

  /// No description provided for @groupDraws.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get groupDraws;

  /// No description provided for @groupLosses.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get groupLosses;

  /// No description provided for @groupGoalDiff.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get groupGoalDiff;

  /// No description provided for @groupPoints.
  ///
  /// In en, this message translates to:
  /// **'Pts'**
  String get groupPoints;

  /// No description provided for @bracketTitle.
  ///
  /// In en, this message translates to:
  /// **'🏆 KNOCKOUT BRACKET'**
  String get bracketTitle;

  /// No description provided for @bracketUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Bracket unavailable'**
  String get bracketUnavailable;

  /// No description provided for @bracketSub.
  ///
  /// In en, this message translates to:
  /// **'Knockout stage fixtures appear after group play'**
  String get bracketSub;

  /// No description provided for @roundOf32.
  ///
  /// In en, this message translates to:
  /// **'Round of 32'**
  String get roundOf32;

  /// No description provided for @roundOf16.
  ///
  /// In en, this message translates to:
  /// **'Round of 16'**
  String get roundOf16;

  /// No description provided for @quarterFinals.
  ///
  /// In en, this message translates to:
  /// **'Quarter-finals'**
  String get quarterFinals;

  /// No description provided for @semiFinals.
  ///
  /// In en, this message translates to:
  /// **'Semi-finals'**
  String get semiFinals;

  /// No description provided for @finalLabel.
  ///
  /// In en, this message translates to:
  /// **'FINAL'**
  String get finalLabel;

  /// No description provided for @thirdPlace.
  ///
  /// In en, this message translates to:
  /// **'3rd PLACE'**
  String get thirdPlace;

  /// No description provided for @champion.
  ///
  /// In en, this message translates to:
  /// **'🏆 CHAMPION'**
  String get champion;

  /// No description provided for @contestBalance.
  ///
  /// In en, this message translates to:
  /// **'CAPS'**
  String get contestBalance;

  /// No description provided for @contestYourTeam.
  ///
  /// In en, this message translates to:
  /// **'Your Team'**
  String get contestYourTeam;

  /// No description provided for @contestActivePicks.
  ///
  /// In en, this message translates to:
  /// **'Active Picks'**
  String get contestActivePicks;

  /// No description provided for @contestOtherMatches.
  ///
  /// In en, this message translates to:
  /// **'Other Matches'**
  String get contestOtherMatches;

  /// No description provided for @contestHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get contestHistory;

  /// No description provided for @contestPickHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get contestPickHome;

  /// No description provided for @contestPickDraw.
  ///
  /// In en, this message translates to:
  /// **'DRAW'**
  String get contestPickDraw;

  /// No description provided for @contestPickAway.
  ///
  /// In en, this message translates to:
  /// **'AWAY'**
  String get contestPickAway;

  /// No description provided for @contestStakeOn.
  ///
  /// In en, this message translates to:
  /// **'Stake on {side}'**
  String contestStakeOn(Object side);

  /// No description provided for @contestPlacePick.
  ///
  /// In en, this message translates to:
  /// **'Place Pick'**
  String get contestPlacePick;

  /// No description provided for @contestStakeAmount.
  ///
  /// In en, this message translates to:
  /// **'Caps to stake'**
  String get contestStakeAmount;

  /// No description provided for @contestPickPlaced.
  ///
  /// In en, this message translates to:
  /// **'Pick placed: {amt} caps on {side}'**
  String contestPickPlaced(Object amt, Object side);

  /// No description provided for @contestPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed (insufficient caps or already picked)'**
  String get contestPickFailed;

  /// No description provided for @contestWon.
  ///
  /// In en, this message translates to:
  /// **'WON'**
  String get contestWon;

  /// No description provided for @contestLost.
  ///
  /// In en, this message translates to:
  /// **'LOST'**
  String get contestLost;

  /// No description provided for @contestPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get contestPending;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get settingsProfile;

  /// No description provided for @settingsActions.
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get settingsActions;

  /// No description provided for @settingsFavoriteTeam.
  ///
  /// In en, this message translates to:
  /// **'Favorite Team'**
  String get settingsFavoriteTeam;

  /// No description provided for @settingsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsNotSet;

  /// No description provided for @settingsCapsBalance.
  ///
  /// In en, this message translates to:
  /// **'Caps Balance'**
  String get settingsCapsBalance;

  /// No description provided for @settingsResetCaps.
  ///
  /// In en, this message translates to:
  /// **'Reset Caps to 1000'**
  String get settingsResetCaps;

  /// No description provided for @settingsResetCapsSub.
  ///
  /// In en, this message translates to:
  /// **'Resets balance and picks history'**
  String get settingsResetCapsSub;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// No description provided for @settingsGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get settingsGuest;

  /// No description provided for @settingsSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settingsSignedIn;

  /// No description provided for @settingsGuestSession.
  ///
  /// In en, this message translates to:
  /// **'Guest session'**
  String get settingsGuestSession;

  /// No description provided for @onboardWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardWelcomeTitle;

  /// No description provided for @onboardSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to play Contest'**
  String get onboardSignInTitle;

  /// No description provided for @onboardSignInSub.
  ///
  /// In en, this message translates to:
  /// **'Earn caps, support your team, win more. Guest mode also available for testing.'**
  String get onboardSignInSub;

  /// No description provided for @onboardYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardYourName;

  /// No description provided for @onboardSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get onboardSignIn;

  /// No description provided for @onboardGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest (Test)'**
  String get onboardGuest;

  /// No description provided for @onboardPickTeam.
  ///
  /// In en, this message translates to:
  /// **'Pick your team'**
  String get onboardPickTeam;

  /// No description provided for @onboardPickTeamSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the nation you support. You can stake caps on their matches in Contest.'**
  String get onboardPickTeamSub;

  /// No description provided for @onboardContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardContinue;

  /// No description provided for @matchDetailStage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get matchDetailStage;

  /// No description provided for @matchDetailGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get matchDetailGroup;

  /// No description provided for @matchDetailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get matchDetailDate;

  /// No description provided for @matchDetailVenue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get matchDetailVenue;

  /// No description provided for @matchDetailCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get matchDetailCity;

  /// No description provided for @matchDetailPenalties.
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get matchDetailPenalties;

  /// No description provided for @profileYourVotes.
  ///
  /// In en, this message translates to:
  /// **'Your Votes'**
  String get profileYourVotes;

  /// No description provided for @profileVotesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} matches voted'**
  String profileVotesCount(Object count);

  /// No description provided for @profileAboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get profileAboutSection;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAbout;

  /// No description provided for @profileAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get profileAppInfo;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacy;

  /// No description provided for @profileRate.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get profileRate;

  /// No description provided for @profileShare.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get profileShare;

  /// No description provided for @profileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileComingSoon;

  /// No description provided for @profileClearVotes.
  ///
  /// In en, this message translates to:
  /// **'Clear My Votes'**
  String get profileClearVotes;

  /// No description provided for @profileClearVotesSub.
  ///
  /// In en, this message translates to:
  /// **'Removes all your match votes'**
  String get profileClearVotesSub;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get profileDeleteAccountSub;

  /// No description provided for @profileChooseTeam.
  ///
  /// In en, this message translates to:
  /// **'Choose your team'**
  String get profileChooseTeam;

  /// No description provided for @profileNoVotes.
  ///
  /// In en, this message translates to:
  /// **'No votes yet'**
  String get profileNoVotes;

  /// No description provided for @profileYouPicked.
  ///
  /// In en, this message translates to:
  /// **'You picked: {pick}'**
  String profileYouPicked(Object pick);

  /// No description provided for @profileDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get profileDraw;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and votes. This cannot be undone.'**
  String get deleteBody;

  /// No description provided for @deleteConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get deleteConfirmPassword;

  /// No description provided for @deleteEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get deleteEnterPassword;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppL10nAr();
    case 'de':
      return AppL10nDe();
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
    case 'fr':
      return AppL10nFr();
    case 'hi':
      return AppL10nHi();
    case 'ja':
      return AppL10nJa();
    case 'pt':
      return AppL10nPt();
    case 'zh':
      return AppL10nZh();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
