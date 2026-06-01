// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppL10nPt extends AppL10n {
  AppL10nPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Copa do Mundo 2026';

  @override
  String get navMatches => 'Jogos';

  @override
  String get navGroups => 'Grupos';

  @override
  String get navBracket => 'Chaveamento';

  @override
  String get navContest => 'Votação';

  @override
  String get navProfile => 'Perfil';

  @override
  String get sectionLiveNow => 'AO VIVO';

  @override
  String get sectionUpcoming => 'PRÓXIMOS';

  @override
  String get sectionResults => 'RESULTADOS';

  @override
  String get noMatches => 'Sem jogos';

  @override
  String get noMatchesSub => 'Volte perto do início';

  @override
  String get reconnecting => 'Reconectando…';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get tbd => 'TBD';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => 'FIM';

  @override
  String get live => 'AO VIVO';

  @override
  String get ft => 'FIM';

  @override
  String get countdownDays => 'DIAS';

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
  String get inProgress => 'EM ANDAMENTO';

  @override
  String get worldCupLabel => 'COPA DO MUNDO';

  @override
  String get totalMatches => 'JOGOS';

  @override
  String get groupTeam => 'Time';

  @override
  String get groupPlayed => 'PJ';

  @override
  String get groupWins => 'V';

  @override
  String get groupDraws => 'E';

  @override
  String get groupLosses => 'D';

  @override
  String get groupGoalDiff => 'SG';

  @override
  String get groupPoints => 'Pts';

  @override
  String get bracketTitle => '🏆 MATA-MATA';

  @override
  String get bracketUnavailable => 'Chaveamento indisponível';

  @override
  String get bracketSub => 'Surge após a fase de grupos';

  @override
  String get roundOf32 => 'Round of 32';

  @override
  String get roundOf16 => 'Oitavas';

  @override
  String get quarterFinals => 'Quartas';

  @override
  String get semiFinals => 'Semifinais';

  @override
  String get finalLabel => 'FINAL';

  @override
  String get thirdPlace => '3º LUGAR';

  @override
  String get champion => '🏆 CAMPEÃO';

  @override
  String get contestBalance => 'FICHAS';

  @override
  String get contestYourTeam => 'Seu Time';

  @override
  String get contestActivePicks => 'Palpites Ativos';

  @override
  String get contestOtherMatches => 'Outros Jogos';

  @override
  String get contestHistory => 'Histórico';

  @override
  String get contestPickHome => 'CASA';

  @override
  String get contestPickDraw => 'EMPATE';

  @override
  String get contestPickAway => 'FORA';

  @override
  String contestStakeOn(Object side) {
    return 'Apostar em $side';
  }

  @override
  String get contestPlacePick => 'Confirmar';

  @override
  String get contestStakeAmount => 'Fichas para apostar';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return 'Aposta: $amt fichas em $side';
  }

  @override
  String get contestPickFailed => 'Falhou (sem fichas ou já apostado)';

  @override
  String get contestWon => 'GANHOU';

  @override
  String get contestLost => 'PERDEU';

  @override
  String get contestPending => 'PENDENTE';

  @override
  String get settingsProfile => 'PERFIL';

  @override
  String get settingsActions => 'AÇÕES';

  @override
  String get settingsFavoriteTeam => 'Time Favorito';

  @override
  String get settingsNotSet => 'Não definido';

  @override
  String get settingsCapsBalance => 'Saldo de Fichas';

  @override
  String get settingsResetCaps => 'Resetar para 1000';

  @override
  String get settingsResetCapsSub => 'Reseta saldo e histórico';

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get settingsGuest => 'Convidado';

  @override
  String get settingsSignedIn => 'Conectado';

  @override
  String get settingsGuestSession => 'Sessão de convidado';

  @override
  String get onboardWelcomeTitle => 'Bem-vindo';

  @override
  String get onboardSignInTitle => 'Entre para jogar o Concurso';

  @override
  String get onboardSignInSub =>
      'Ganhe fichas, apoie seu time. Modo convidado também disponível.';

  @override
  String get onboardYourName => 'Seu nome';

  @override
  String get onboardSignIn => 'Entrar';

  @override
  String get onboardGuest => 'Continuar como Convidado';

  @override
  String get onboardPickTeam => 'Escolha seu time';

  @override
  String get onboardPickTeamSub =>
      'Selecione a seleção que apoia para apostar fichas nos jogos.';

  @override
  String get onboardContinue => 'Continuar';

  @override
  String get matchDetailStage => 'Fase';

  @override
  String get matchDetailGroup => 'Grupo';

  @override
  String get matchDetailDate => 'Data';

  @override
  String get matchDetailVenue => 'Estádio';

  @override
  String get matchDetailCity => 'Cidade';

  @override
  String get matchDetailPenalties => 'Pênaltis';

  @override
  String get profileYourVotes => 'Seus votos';

  @override
  String profileVotesCount(Object count) {
    return '$count jogos votados';
  }

  @override
  String get profileAboutSection => 'SOBRE';

  @override
  String get profileAbout => 'Sobre';

  @override
  String get profileAppInfo => 'Informações do app';

  @override
  String get profilePrivacy => 'Política de Privacidade';

  @override
  String get profileRate => 'Avaliar o app';

  @override
  String get profileShare => 'Compartilhar o app';

  @override
  String get profileComingSoon => 'Em breve';

  @override
  String get profileClearVotes => 'Limpar meus votos';

  @override
  String get profileClearVotesSub => 'Remove todos os seus votos de jogos';

  @override
  String get profileDeleteAccount => 'Excluir conta';

  @override
  String get profileDeleteAccountSub => 'Exclui sua conta permanentemente';

  @override
  String get profileChooseTeam => 'Escolha seu time';

  @override
  String get profileNoVotes => 'Ainda sem votos';

  @override
  String profileYouPicked(Object pick) {
    return 'Você escolheu: $pick';
  }

  @override
  String get profileDraw => 'Empate';

  @override
  String get deleteTitle => 'Excluir conta?';

  @override
  String get deleteBody =>
      'Isso exclui permanentemente sua conta e seus votos. Não pode ser desfeito.';

  @override
  String get deleteConfirmPassword => 'Confirmar senha';

  @override
  String get deleteEnterPassword => 'Digite sua senha.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';
}
