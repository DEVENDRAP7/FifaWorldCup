// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppL10nFr extends AppL10n {
  AppL10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Coupe du Monde 2026';

  @override
  String get navMatches => 'Matchs';

  @override
  String get navGroups => 'Groupes';

  @override
  String get navBracket => 'Tableau';

  @override
  String get navContest => 'Vote';

  @override
  String get navProfile => 'Profil';

  @override
  String get sectionLiveNow => 'EN DIRECT';

  @override
  String get sectionUpcoming => 'À VENIR';

  @override
  String get sectionResults => 'RÉSULTATS';

  @override
  String get noMatches => 'Aucun match';

  @override
  String get noMatchesSub => 'Revenez près du coup d\'envoi';

  @override
  String get reconnecting => 'Reconnexion…';

  @override
  String get retry => 'Réessayer';

  @override
  String get tbd => 'À DÉF.';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => 'FIN';

  @override
  String get live => 'EN DIRECT';

  @override
  String get ft => 'FIN';

  @override
  String get countdownDays => 'JOURS';

  @override
  String get countdownHours => 'HRS';

  @override
  String get countdownMinutes => 'MIN';

  @override
  String get countdownSeconds => 'SEC';

  @override
  String get fifaOfficial => 'FIFA OFFICIEL';

  @override
  String get kickoffIn => 'COUP D\'ENVOI';

  @override
  String get inProgress => 'EN COURS';

  @override
  String get worldCupLabel => 'COUPE DU MONDE';

  @override
  String get totalMatches => 'MATCHS';

  @override
  String get groupTeam => 'Équipe';

  @override
  String get groupPlayed => 'J';

  @override
  String get groupWins => 'G';

  @override
  String get groupDraws => 'N';

  @override
  String get groupLosses => 'P';

  @override
  String get groupGoalDiff => 'DB';

  @override
  String get groupPoints => 'Pts';

  @override
  String get bracketTitle => '🏆 PHASE FINALE';

  @override
  String get bracketUnavailable => 'Tableau indisponible';

  @override
  String get bracketSub => 'Apparaît après la phase de groupes';

  @override
  String get roundOf32 => '16es de finale';

  @override
  String get roundOf16 => '8es de finale';

  @override
  String get quarterFinals => 'Quarts';

  @override
  String get semiFinals => 'Demi-finales';

  @override
  String get finalLabel => 'FINALE';

  @override
  String get thirdPlace => '3e PLACE';

  @override
  String get champion => '🏆 CHAMPION';

  @override
  String get contestBalance => 'JETONS';

  @override
  String get contestYourTeam => 'Votre Équipe';

  @override
  String get contestActivePicks => 'Paris Actifs';

  @override
  String get contestOtherMatches => 'Autres Matchs';

  @override
  String get contestHistory => 'Historique';

  @override
  String get contestPickHome => 'DOM.';

  @override
  String get contestPickDraw => 'NUL';

  @override
  String get contestPickAway => 'EXT.';

  @override
  String contestStakeOn(Object side) {
    return 'Parier sur $side';
  }

  @override
  String get contestPlacePick => 'Valider';

  @override
  String get contestStakeAmount => 'Jetons à miser';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'Pari : $amt jetons sur $side';
  }

  @override
  String get contestPickFailed => 'Échec (jetons insuffisants ou déjà parié)';

  @override
  String get contestWon => 'GAGNÉ';

  @override
  String get contestLost => 'PERDU';

  @override
  String get contestPending => 'EN ATTENTE';

  @override
  String get settingsProfile => 'PROFIL';

  @override
  String get settingsActions => 'ACTIONS';

  @override
  String get settingsFavoriteTeam => 'Équipe Favorite';

  @override
  String get settingsNotSet => 'Non défini';

  @override
  String get settingsCapsBalance => 'Solde Jetons';

  @override
  String get settingsResetCaps => 'Réinitialiser à 1000';

  @override
  String get settingsResetCapsSub => 'Réinitialise solde et historique';

  @override
  String get settingsSignOut => 'Déconnexion';

  @override
  String get settingsGuest => 'Invité';

  @override
  String get settingsSignedIn => 'Connecté';

  @override
  String get settingsGuestSession => 'Session invité';

  @override
  String get onboardWelcomeTitle => 'Bienvenue';

  @override
  String get onboardSignInTitle => 'Connectez-vous pour le Concours';

  @override
  String get onboardSignInSub =>
      'Gagnez des jetons, soutenez votre équipe. Mode invité disponible.';

  @override
  String get onboardYourName => 'Votre nom';

  @override
  String get onboardSignIn => 'Connexion';

  @override
  String get onboardGuest => 'Continuer en Invité';

  @override
  String get onboardPickTeam => 'Choisissez votre équipe';

  @override
  String get onboardPickTeamSub =>
      'Sélectionnez la nation que vous soutenez pour parier sur ses matchs.';

  @override
  String get onboardContinue => 'Continuer';

  @override
  String get matchDetailStage => 'Phase';

  @override
  String get matchDetailGroup => 'Groupe';

  @override
  String get matchDetailDate => 'Date';

  @override
  String get matchDetailVenue => 'Stade';

  @override
  String get matchDetailCity => 'Ville';

  @override
  String get matchDetailPenalties => 'Tirs au but';

  @override
  String get profileYourVotes => 'Vos votes';

  @override
  String profileVotesCount(Object count) {
    return '$count matchs votés';
  }

  @override
  String get profileAboutSection => 'À PROPOS';

  @override
  String get profileAbout => 'À propos';

  @override
  String get profileAppInfo => 'Infos de l\'appli';

  @override
  String get profilePrivacy => 'Politique de confidentialité';

  @override
  String get profileRate => 'Noter l\'appli';

  @override
  String get profileShare => 'Partager l\'appli';

  @override
  String get profileComingSoon => 'Bientôt disponible';

  @override
  String get profileClearVotes => 'Effacer mes votes';

  @override
  String get profileClearVotesSub => 'Supprime tous vos votes de matchs';

  @override
  String get profileDeleteAccount => 'Supprimer le compte';

  @override
  String get profileDeleteAccountSub => 'Supprime votre compte définitivement';

  @override
  String get profileChooseTeam => 'Choisissez votre équipe';

  @override
  String get profileNoVotes => 'Aucun vote pour l\'instant';

  @override
  String profileYouPicked(Object pick) {
    return 'Vous avez choisi : $pick';
  }

  @override
  String get profileDraw => 'Match nul';

  @override
  String get deleteTitle => 'Supprimer le compte ?';

  @override
  String get deleteBody =>
      'Ceci supprime définitivement votre compte et vos votes. Action irréversible.';

  @override
  String get deleteConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get deleteEnterPassword => 'Saisissez votre mot de passe.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get languageSystem => 'Par défaut du système';
}
