// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Copa Mundial 2026';

  @override
  String get navMatches => 'Partidos';

  @override
  String get navGroups => 'Grupos';

  @override
  String get navBracket => 'Llaves';

  @override
  String get navContest => 'Votar';

  @override
  String get navProfile => 'Perfil';

  @override
  String get sectionLiveNow => 'EN VIVO';

  @override
  String get sectionUpcoming => 'PRÓXIMOS';

  @override
  String get sectionResults => 'RESULTADOS';

  @override
  String get noMatches => 'No hay partidos';

  @override
  String get noMatchesSub => 'Vuelve cerca del inicio';

  @override
  String get reconnecting => 'Reconectando…';

  @override
  String get retry => 'Reintentar';

  @override
  String get tbd => 'POR DEF.';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => 'FIN';

  @override
  String get live => 'EN VIVO';

  @override
  String get ft => 'FIN';

  @override
  String get countdownDays => 'DÍAS';

  @override
  String get countdownHours => 'HRS';

  @override
  String get countdownMinutes => 'MIN';

  @override
  String get countdownSeconds => 'SEG';

  @override
  String get fifaOfficial => 'FIFA OFICIAL';

  @override
  String get kickoffIn => 'FALTA';

  @override
  String get inProgress => 'EN CURSO';

  @override
  String get worldCupLabel => 'COPA MUNDIAL';

  @override
  String get totalMatches => 'PARTIDOS';

  @override
  String get groupTeam => 'Equipo';

  @override
  String get groupPlayed => 'PJ';

  @override
  String get groupWins => 'G';

  @override
  String get groupDraws => 'E';

  @override
  String get groupLosses => 'P';

  @override
  String get groupGoalDiff => 'DG';

  @override
  String get groupPoints => 'Pts';

  @override
  String get bracketTitle => '🏆 LLAVES ELIMINATORIAS';

  @override
  String get bracketUnavailable => 'Llaves no disponibles';

  @override
  String get bracketSub => 'Las llaves aparecen tras la fase de grupos';

  @override
  String get roundOf32 => 'Dieciseisavos';

  @override
  String get roundOf16 => 'Octavos';

  @override
  String get quarterFinals => 'Cuartos';

  @override
  String get semiFinals => 'Semifinales';

  @override
  String get finalLabel => 'FINAL';

  @override
  String get thirdPlace => '3er PUESTO';

  @override
  String get champion => '🏆 CAMPEÓN';

  @override
  String get contestBalance => 'FICHAS';

  @override
  String get contestYourTeam => 'Tu Equipo';

  @override
  String get contestActivePicks => 'Apuestas Activas';

  @override
  String get contestOtherMatches => 'Otros Partidos';

  @override
  String get contestHistory => 'Historial';

  @override
  String get contestPickHome => 'LOCAL';

  @override
  String get contestPickDraw => 'EMPATE';

  @override
  String get contestPickAway => 'VISITA';

  @override
  String contestStakeOn(Object side) {
    return 'Apostar a $side';
  }

  @override
  String get contestPlacePick => 'Confirmar';

  @override
  String get contestStakeAmount => 'Fichas a apostar';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'Apuesta: $amt fichas a $side';
  }

  @override
  String get contestPickFailed => 'Error (sin fichas o ya apostado)';

  @override
  String get contestWon => 'GANADA';

  @override
  String get contestLost => 'PERDIDA';

  @override
  String get contestPending => 'PENDIENTE';

  @override
  String get settingsProfile => 'PERFIL';

  @override
  String get settingsActions => 'ACCIONES';

  @override
  String get settingsFavoriteTeam => 'Equipo Favorito';

  @override
  String get settingsNotSet => 'No definido';

  @override
  String get settingsCapsBalance => 'Saldo de Fichas';

  @override
  String get settingsResetCaps => 'Restablecer a 1000';

  @override
  String get settingsResetCapsSub => 'Reinicia saldo e historial';

  @override
  String get settingsSignOut => 'Cerrar Sesión';

  @override
  String get settingsGuest => 'Invitado';

  @override
  String get settingsSignedIn => 'Sesión iniciada';

  @override
  String get settingsGuestSession => 'Sesión invitado';

  @override
  String get onboardWelcomeTitle => 'Bienvenido';

  @override
  String get onboardSignInTitle => 'Inicia sesión para el Concurso';

  @override
  String get onboardSignInSub =>
      'Gana fichas, apoya a tu equipo. Modo invitado también disponible.';

  @override
  String get onboardYourName => 'Tu nombre';

  @override
  String get onboardSignIn => 'Iniciar Sesión';

  @override
  String get onboardGuest => 'Continuar como Invitado';

  @override
  String get onboardPickTeam => 'Elige tu equipo';

  @override
  String get onboardPickTeamSub =>
      'Selecciona la selección que apoyas para apostar fichas en sus partidos.';

  @override
  String get onboardContinue => 'Continuar';

  @override
  String get matchDetailStage => 'Fase';

  @override
  String get matchDetailGroup => 'Grupo';

  @override
  String get matchDetailDate => 'Fecha';

  @override
  String get matchDetailVenue => 'Estadio';

  @override
  String get matchDetailCity => 'Ciudad';

  @override
  String get matchDetailPenalties => 'Penales';

  @override
  String get profileYourVotes => 'Tus votos';

  @override
  String profileVotesCount(Object count) {
    return '$count partidos votados';
  }

  @override
  String get profileAboutSection => 'ACERCA DE';

  @override
  String get profileAbout => 'Acerca de';

  @override
  String get profileAppInfo => 'Información de la app';

  @override
  String get profilePrivacy => 'Política de privacidad';

  @override
  String get profileRate => 'Valorar la app';

  @override
  String get profileShare => 'Compartir la app';

  @override
  String get profileComingSoon => 'Próximamente';

  @override
  String get profileClearVotes => 'Borrar mis votos';

  @override
  String get profileClearVotesSub => 'Elimina todos tus votos de partidos';

  @override
  String get profileDeleteAccount => 'Eliminar cuenta';

  @override
  String get profileDeleteAccountSub => 'Elimina tu cuenta de forma permanente';

  @override
  String get profileChooseTeam => 'Elige tu equipo';

  @override
  String get profileNoVotes => 'Aún no hay votos';

  @override
  String profileYouPicked(Object pick) {
    return 'Elegiste: $pick';
  }

  @override
  String get profileDraw => 'Empate';

  @override
  String get deleteTitle => '¿Eliminar cuenta?';

  @override
  String get deleteBody =>
      'Esto elimina permanentemente tu cuenta y tus votos. No se puede deshacer.';

  @override
  String get deleteConfirmPassword => 'Confirmar contraseña';

  @override
  String get deleteEnterPassword => 'Introduce tu contraseña.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';
}
