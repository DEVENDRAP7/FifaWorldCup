// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppL10nJa extends AppL10n {
  AppL10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ワールドカップ2026';

  @override
  String get navMatches => '試合';

  @override
  String get navGroups => 'グループ';

  @override
  String get navBracket => 'トーナメント';

  @override
  String get navContest => '投票';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get sectionLiveNow => 'ライブ';

  @override
  String get sectionUpcoming => '今後の試合';

  @override
  String get sectionResults => '結果';

  @override
  String get noMatches => '試合はありません';

  @override
  String get noMatchesSub => '開幕直前にご確認ください';

  @override
  String get reconnecting => '再接続中…';

  @override
  String get retry => '再試行';

  @override
  String get tbd => '未定';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => '試合終了';

  @override
  String get live => 'ライブ';

  @override
  String get ft => '終了';

  @override
  String get countdownDays => '日';

  @override
  String get countdownHours => '時間';

  @override
  String get countdownMinutes => '分';

  @override
  String get countdownSeconds => '秒';

  @override
  String get fifaOfficial => 'FIFA公式';

  @override
  String get kickoffIn => 'キックオフまで';

  @override
  String get inProgress => '開催中';

  @override
  String get worldCupLabel => 'ワールドカップ';

  @override
  String get totalMatches => '試合';

  @override
  String get groupTeam => 'チーム';

  @override
  String get groupPlayed => '試';

  @override
  String get groupWins => '勝';

  @override
  String get groupDraws => '分';

  @override
  String get groupLosses => '敗';

  @override
  String get groupGoalDiff => '得失';

  @override
  String get groupPoints => '勝点';

  @override
  String get bracketTitle => '🏆 ノックアウト';

  @override
  String get bracketUnavailable => '未公開';

  @override
  String get bracketSub => 'グループステージ終了後に表示';

  @override
  String get roundOf32 => 'ラウンド32';

  @override
  String get roundOf16 => 'ラウンド16';

  @override
  String get quarterFinals => '準々決勝';

  @override
  String get semiFinals => '準決勝';

  @override
  String get finalLabel => '決勝';

  @override
  String get thirdPlace => '3位決定戦';

  @override
  String get champion => '🏆 優勝';

  @override
  String get contestBalance => 'コイン';

  @override
  String get contestYourTeam => 'あなたのチーム';

  @override
  String get contestActivePicks => '現在の予想';

  @override
  String get contestOtherMatches => '他の試合';

  @override
  String get contestHistory => '履歴';

  @override
  String get contestPickHome => 'ホーム';

  @override
  String get contestPickDraw => '引分';

  @override
  String get contestPickAway => 'アウェー';

  @override
  String contestStakeOn(Object side) {
    return '$sideに賭ける';
  }

  @override
  String get contestPlacePick => '確定';

  @override
  String get contestStakeAmount => '賭けるコイン';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return '予想: $amtコイン → $side';
  }

  @override
  String get contestPickFailed => '失敗';

  @override
  String get contestWon => '勝利';

  @override
  String get contestLost => '敗北';

  @override
  String get contestPending => '進行中';

  @override
  String get settingsProfile => 'プロフィール';

  @override
  String get settingsActions => '操作';

  @override
  String get settingsFavoriteTeam => 'お気に入りチーム';

  @override
  String get settingsNotSet => '未設定';

  @override
  String get settingsCapsBalance => 'コイン残高';

  @override
  String get settingsResetCaps => '1000にリセット';

  @override
  String get settingsResetCapsSub => '残高と履歴をリセット';

  @override
  String get settingsSignOut => 'サインアウト';

  @override
  String get settingsGuest => 'ゲスト';

  @override
  String get settingsSignedIn => 'サインイン中';

  @override
  String get settingsGuestSession => 'ゲストセッション';

  @override
  String get onboardWelcomeTitle => 'ようこそ';

  @override
  String get onboardSignInTitle => 'コンテストに参加するにはサインイン';

  @override
  String get onboardSignInSub => 'コインを獲得し、チームを応援。ゲストモードも利用可能。';

  @override
  String get onboardYourName => 'お名前';

  @override
  String get onboardSignIn => 'サインイン';

  @override
  String get onboardGuest => 'ゲストで続行';

  @override
  String get onboardPickTeam => '応援チームを選択';

  @override
  String get onboardPickTeamSub => '応援する代表チームを選んで試合にコインを賭けましょう。';

  @override
  String get onboardContinue => '続ける';

  @override
  String get matchDetailStage => 'ステージ';

  @override
  String get matchDetailGroup => 'グループ';

  @override
  String get matchDetailDate => '日時';

  @override
  String get matchDetailVenue => '会場';

  @override
  String get matchDetailCity => '都市';

  @override
  String get matchDetailPenalties => 'PK戦';

  @override
  String get profileYourVotes => 'あなたの投票';

  @override
  String profileVotesCount(Object count) {
    return '$count試合に投票';
  }

  @override
  String get profileAboutSection => 'アプリについて';

  @override
  String get profileAbout => 'アプリについて';

  @override
  String get profileAppInfo => 'アプリ情報';

  @override
  String get profilePrivacy => 'プライバシーポリシー';

  @override
  String get profileRate => 'アプリを評価';

  @override
  String get profileShare => 'アプリを共有';

  @override
  String get profileComingSoon => '近日公開';

  @override
  String get profileClearVotes => '投票を消去';

  @override
  String get profileClearVotesSub => 'すべての試合の投票を削除します';

  @override
  String get profileDeleteAccount => 'アカウントを削除';

  @override
  String get profileDeleteAccountSub => 'アカウントを完全に削除します';

  @override
  String get profileChooseTeam => 'チームを選択';

  @override
  String get profileNoVotes => 'まだ投票がありません';

  @override
  String profileYouPicked(Object pick) {
    return '選択: $pick';
  }

  @override
  String get profileDraw => '引き分け';

  @override
  String get deleteTitle => 'アカウントを削除しますか？';

  @override
  String get deleteBody => 'アカウントと投票が完全に削除されます。元に戻せません。';

  @override
  String get deleteConfirmPassword => 'パスワードを確認';

  @override
  String get deleteEnterPassword => 'パスワードを入力してください。';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonDelete => '削除';

  @override
  String get profileLanguage => '言語';

  @override
  String get languageSystem => 'システムの既定';
}
