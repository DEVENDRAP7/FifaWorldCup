// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'World Cup 2026';

  @override
  String get navMatches => 'Matches';

  @override
  String get navGroups => 'Groups';

  @override
  String get navBracket => 'Bracket';

  @override
  String get navContest => 'Vote';

  @override
  String get navProfile => 'Profile';

  @override
  String get sectionLiveNow => 'LIVE NOW';

  @override
  String get sectionUpcoming => 'UPCOMING';

  @override
  String get sectionResults => 'RESULTS';

  @override
  String get noMatches => 'No matches yet';

  @override
  String get noMatchesSub => 'Check back closer to kickoff';

  @override
  String get reconnecting => 'Reconnecting…';

  @override
  String get retry => 'Retry';

  @override
  String get tbd => 'TBD';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => 'FULL TIME';

  @override
  String get live => 'LIVE';

  @override
  String get ft => 'FT';

  @override
  String get countdownDays => 'DAYS';

  @override
  String get countdownHours => 'HRS';

  @override
  String get countdownMinutes => 'MIN';

  @override
  String get countdownSeconds => 'SEC';

  @override
  String get fifaOfficial => 'FIFA OFFICIAL';

  @override
  String get kickoffIn => 'KICKOFF IN';

  @override
  String get inProgress => 'IN PROGRESS';

  @override
  String get worldCupLabel => 'WORLD CUP';

  @override
  String get totalMatches => 'MATCHES';

  @override
  String get groupTeam => 'Team';

  @override
  String get groupPlayed => 'P';

  @override
  String get groupWins => 'W';

  @override
  String get groupDraws => 'D';

  @override
  String get groupLosses => 'L';

  @override
  String get groupGoalDiff => 'GD';

  @override
  String get groupPoints => 'Pts';

  @override
  String get bracketTitle => '🏆 KNOCKOUT BRACKET';

  @override
  String get bracketUnavailable => 'Bracket unavailable';

  @override
  String get bracketSub => 'Knockout stage fixtures appear after group play';

  @override
  String get roundOf32 => 'Round of 32';

  @override
  String get roundOf16 => 'Round of 16';

  @override
  String get quarterFinals => 'Quarter-finals';

  @override
  String get semiFinals => 'Semi-finals';

  @override
  String get finalLabel => 'FINAL';

  @override
  String get thirdPlace => '3rd PLACE';

  @override
  String get champion => '🏆 CHAMPION';

  @override
  String get contestBalance => 'CAPS';

  @override
  String get contestYourTeam => 'Your Team';

  @override
  String get contestActivePicks => 'Active Picks';

  @override
  String get contestOtherMatches => 'Other Matches';

  @override
  String get contestHistory => 'History';

  @override
  String get contestPickHome => 'HOME';

  @override
  String get contestPickDraw => 'DRAW';

  @override
  String get contestPickAway => 'AWAY';

  @override
  String contestStakeOn(Object side) {
    return 'Stake on $side';
  }

  @override
  String get contestPlacePick => 'Place Pick';

  @override
  String get contestStakeAmount => 'Caps to stake';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'Pick placed: $amt caps on $side';
  }

  @override
  String get contestPickFailed =>
      'Failed (insufficient caps or already picked)';

  @override
  String get contestWon => 'WON';

  @override
  String get contestLost => 'LOST';

  @override
  String get contestPending => 'PENDING';

  @override
  String get settingsProfile => 'PROFILE';

  @override
  String get settingsActions => 'ACTIONS';

  @override
  String get settingsFavoriteTeam => 'Favorite Team';

  @override
  String get settingsNotSet => 'Not set';

  @override
  String get settingsCapsBalance => 'Caps Balance';

  @override
  String get settingsResetCaps => 'Reset Caps to 1000';

  @override
  String get settingsResetCapsSub => 'Resets balance and picks history';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsGuest => 'Guest';

  @override
  String get settingsSignedIn => 'Signed in';

  @override
  String get settingsGuestSession => 'Guest session';

  @override
  String get onboardWelcomeTitle => 'Welcome';

  @override
  String get onboardSignInTitle => 'Sign in to play Contest';

  @override
  String get onboardSignInSub =>
      'Earn caps, support your team, win more. Guest mode also available for testing.';

  @override
  String get onboardYourName => 'Your name';

  @override
  String get onboardSignIn => 'Sign In';

  @override
  String get onboardGuest => 'Continue as Guest (Test)';

  @override
  String get onboardPickTeam => 'Pick your team';

  @override
  String get onboardPickTeamSub =>
      'Choose the nation you support. You can stake caps on their matches in Contest.';

  @override
  String get onboardContinue => 'Continue';

  @override
  String get matchDetailStage => 'Stage';

  @override
  String get matchDetailGroup => 'Group';

  @override
  String get matchDetailDate => 'Date';

  @override
  String get matchDetailVenue => 'Venue';

  @override
  String get matchDetailCity => 'City';

  @override
  String get matchDetailPenalties => 'Penalties';

  @override
  String get profileYourVotes => 'Your Votes';

  @override
  String profileVotesCount(Object count) {
    return '$count matches voted';
  }

  @override
  String get profileAboutSection => 'ABOUT';

  @override
  String get profileAbout => 'About';

  @override
  String get profileAppInfo => 'App info';

  @override
  String get profilePrivacy => 'Privacy Policy';

  @override
  String get profileRate => 'Rate App';

  @override
  String get profileShare => 'Share App';

  @override
  String get profileComingSoon => 'Coming soon';

  @override
  String get profileClearVotes => 'Clear My Votes';

  @override
  String get profileClearVotesSub => 'Removes all your match votes';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileDeleteAccountSub => 'Permanently delete your account';

  @override
  String get profileChooseTeam => 'Choose your team';

  @override
  String get profileNoVotes => 'No votes yet';

  @override
  String profileYouPicked(Object pick) {
    return 'You picked: $pick';
  }

  @override
  String get profileDraw => 'Draw';

  @override
  String get deleteTitle => 'Delete account?';

  @override
  String get deleteBody =>
      'This permanently deletes your account and votes. This cannot be undone.';

  @override
  String get deleteConfirmPassword => 'Confirm password';

  @override
  String get deleteEnterPassword => 'Enter your password.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get profileLanguage => 'Language';

  @override
  String get languageSystem => 'System default';
}
