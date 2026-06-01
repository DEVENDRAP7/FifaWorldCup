// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppL10nDe extends AppL10n {
  AppL10nDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Weltmeisterschaft 2026';

  @override
  String get navMatches => 'Spiele';

  @override
  String get navGroups => 'Gruppen';

  @override
  String get navBracket => 'K.O.-Runde';

  @override
  String get navContest => 'Abstimmung';

  @override
  String get navProfile => 'Profil';

  @override
  String get sectionLiveNow => 'JETZT LIVE';

  @override
  String get sectionUpcoming => 'BEVORSTEHEND';

  @override
  String get sectionResults => 'ERGEBNISSE';

  @override
  String get noMatches => 'Keine Spiele';

  @override
  String get noMatchesSub => 'Schau später wieder rein';

  @override
  String get reconnecting => 'Verbinde…';

  @override
  String get retry => 'Erneut';

  @override
  String get tbd => 'OFFEN';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => 'ABPFIFF';

  @override
  String get live => 'LIVE';

  @override
  String get ft => 'ENDE';

  @override
  String get countdownDays => 'TAGE';

  @override
  String get countdownHours => 'STD';

  @override
  String get countdownMinutes => 'MIN';

  @override
  String get countdownSeconds => 'SEK';

  @override
  String get fifaOfficial => 'FIFA OFFIZIELL';

  @override
  String get kickoffIn => 'ANSTOSS IN';

  @override
  String get inProgress => 'LÄUFT';

  @override
  String get worldCupLabel => 'WELTMEISTERSCHAFT';

  @override
  String get totalMatches => 'SPIELE';

  @override
  String get groupTeam => 'Team';

  @override
  String get groupPlayed => 'Sp';

  @override
  String get groupWins => 'S';

  @override
  String get groupDraws => 'U';

  @override
  String get groupLosses => 'N';

  @override
  String get groupGoalDiff => 'TD';

  @override
  String get groupPoints => 'Pkt';

  @override
  String get bracketTitle => '🏆 K.O.-PHASE';

  @override
  String get bracketUnavailable => 'Nicht verfügbar';

  @override
  String get bracketSub => 'Erscheint nach der Gruppenphase';

  @override
  String get roundOf32 => 'Sechzehntelfinale';

  @override
  String get roundOf16 => 'Achtelfinale';

  @override
  String get quarterFinals => 'Viertelfinale';

  @override
  String get semiFinals => 'Halbfinale';

  @override
  String get finalLabel => 'FINALE';

  @override
  String get thirdPlace => '3. PLATZ';

  @override
  String get champion => '🏆 CHAMPION';

  @override
  String get contestBalance => 'MARKEN';

  @override
  String get contestYourTeam => 'Dein Team';

  @override
  String get contestActivePicks => 'Aktive Tipps';

  @override
  String get contestOtherMatches => 'Weitere Spiele';

  @override
  String get contestHistory => 'Verlauf';

  @override
  String get contestPickHome => 'HEIM';

  @override
  String get contestPickDraw => 'UNENTSCHIEDEN';

  @override
  String get contestPickAway => 'AUSWÄRTS';

  @override
  String contestStakeOn(Object side) {
    return 'Tipp auf $side';
  }

  @override
  String get contestPlacePick => 'Bestätigen';

  @override
  String get contestStakeAmount => 'Einsatz';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'Tipp: $amt auf $side';
  }

  @override
  String get contestPickFailed => 'Fehlgeschlagen';

  @override
  String get contestWon => 'GEWONNEN';

  @override
  String get contestLost => 'VERLOREN';

  @override
  String get contestPending => 'OFFEN';

  @override
  String get settingsProfile => 'PROFIL';

  @override
  String get settingsActions => 'AKTIONEN';

  @override
  String get settingsFavoriteTeam => 'Lieblingsteam';

  @override
  String get settingsNotSet => 'Nicht gesetzt';

  @override
  String get settingsCapsBalance => 'Marken-Saldo';

  @override
  String get settingsResetCaps => 'Auf 1000 zurücksetzen';

  @override
  String get settingsResetCapsSub => 'Saldo und Verlauf zurücksetzen';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsGuest => 'Gast';

  @override
  String get settingsSignedIn => 'Angemeldet';

  @override
  String get settingsGuestSession => 'Gast-Sitzung';

  @override
  String get onboardWelcomeTitle => 'Willkommen';

  @override
  String get onboardSignInTitle => 'Anmelden fürs Tippspiel';

  @override
  String get onboardSignInSub =>
      'Marken verdienen, dein Team unterstützen. Gastmodus verfügbar.';

  @override
  String get onboardYourName => 'Dein Name';

  @override
  String get onboardSignIn => 'Anmelden';

  @override
  String get onboardGuest => 'Als Gast fortfahren';

  @override
  String get onboardPickTeam => 'Wähle dein Team';

  @override
  String get onboardPickTeamSub =>
      'Wähle die Nation, die du unterstützt, um auf ihre Spiele zu tippen.';

  @override
  String get onboardContinue => 'Weiter';

  @override
  String get matchDetailStage => 'Phase';

  @override
  String get matchDetailGroup => 'Gruppe';

  @override
  String get matchDetailDate => 'Datum';

  @override
  String get matchDetailVenue => 'Stadion';

  @override
  String get matchDetailCity => 'Stadt';

  @override
  String get matchDetailPenalties => 'Elfmeterschießen';

  @override
  String get profileYourVotes => 'Deine Stimmen';

  @override
  String profileVotesCount(Object count) {
    return '$count Spiele abgestimmt';
  }

  @override
  String get profileAboutSection => 'ÜBER';

  @override
  String get profileAbout => 'Über';

  @override
  String get profileAppInfo => 'App-Info';

  @override
  String get profilePrivacy => 'Datenschutzrichtlinie';

  @override
  String get profileRate => 'App bewerten';

  @override
  String get profileShare => 'App teilen';

  @override
  String get profileComingSoon => 'Demnächst';

  @override
  String get profileClearVotes => 'Meine Stimmen löschen';

  @override
  String get profileClearVotesSub => 'Entfernt alle deine Spielstimmen';

  @override
  String get profileDeleteAccount => 'Konto löschen';

  @override
  String get profileDeleteAccountSub => 'Löscht dein Konto dauerhaft';

  @override
  String get profileChooseTeam => 'Wähle dein Team';

  @override
  String get profileNoVotes => 'Noch keine Stimmen';

  @override
  String profileYouPicked(Object pick) {
    return 'Du hast gewählt: $pick';
  }

  @override
  String get profileDraw => 'Unentschieden';

  @override
  String get deleteTitle => 'Konto löschen?';

  @override
  String get deleteBody =>
      'Dies löscht dein Konto und deine Stimmen dauerhaft. Kann nicht rückgängig gemacht werden.';

  @override
  String get deleteConfirmPassword => 'Passwort bestätigen';

  @override
  String get deleteEnterPassword => 'Gib dein Passwort ein.';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get profileLanguage => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';
}
