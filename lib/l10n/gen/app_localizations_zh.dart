// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '世界杯2026';

  @override
  String get navMatches => '比赛';

  @override
  String get navGroups => '小组';

  @override
  String get navBracket => '对阵图';

  @override
  String get navContest => '投票';

  @override
  String get navProfile => '个人';

  @override
  String get sectionLiveNow => '直播中';

  @override
  String get sectionUpcoming => '即将开始';

  @override
  String get sectionResults => '已结束';

  @override
  String get noMatches => '暂无比赛';

  @override
  String get noMatchesSub => '临近开赛再来';

  @override
  String get reconnecting => '重新连接…';

  @override
  String get retry => '重试';

  @override
  String get tbd => '待定';

  @override
  String get vs => 'VS';

  @override
  String get fullTime => '全场';

  @override
  String get live => '直播';

  @override
  String get ft => '完';

  @override
  String get countdownDays => '天';

  @override
  String get countdownHours => '时';

  @override
  String get countdownMinutes => '分';

  @override
  String get countdownSeconds => '秒';

  @override
  String get fifaOfficial => 'FIFA官方';

  @override
  String get kickoffIn => '距开赛';

  @override
  String get inProgress => '进行中';

  @override
  String get worldCupLabel => '世界杯';

  @override
  String get totalMatches => '场比赛';

  @override
  String get groupTeam => '球队';

  @override
  String get groupPlayed => '赛';

  @override
  String get groupWins => '胜';

  @override
  String get groupDraws => '平';

  @override
  String get groupLosses => '负';

  @override
  String get groupGoalDiff => '净胜';

  @override
  String get groupPoints => '积分';

  @override
  String get bracketTitle => '🏆 淘汰赛';

  @override
  String get bracketUnavailable => '暂不可用';

  @override
  String get bracketSub => '小组赛后显示';

  @override
  String get roundOf32 => '32强';

  @override
  String get roundOf16 => '16强';

  @override
  String get quarterFinals => '8强';

  @override
  String get semiFinals => '4强';

  @override
  String get finalLabel => '决赛';

  @override
  String get thirdPlace => '季军赛';

  @override
  String get champion => '🏆 冠军';

  @override
  String get contestBalance => '金币';

  @override
  String get contestYourTeam => '您的球队';

  @override
  String get contestActivePicks => '进行中预测';

  @override
  String get contestOtherMatches => '其他比赛';

  @override
  String get contestHistory => '历史';

  @override
  String get contestPickHome => '主胜';

  @override
  String get contestPickDraw => '平局';

  @override
  String get contestPickAway => '客胜';

  @override
  String contestStakeOn(Object side) {
    return '投注 $side';
  }

  @override
  String get contestPlacePick => '确认';

  @override
  String get contestStakeAmount => '投注金币';

  @override
  String contestPickPlaced(Object amt, Object side) {
    return '已投注: $amt 金币 / $side';
  }

  @override
  String get contestPickFailed => '失败';

  @override
  String get contestWon => '胜';

  @override
  String get contestLost => '负';

  @override
  String get contestPending => '待定';

  @override
  String get settingsProfile => '个人';

  @override
  String get settingsActions => '操作';

  @override
  String get settingsFavoriteTeam => '喜爱球队';

  @override
  String get settingsNotSet => '未设置';

  @override
  String get settingsCapsBalance => '金币余额';

  @override
  String get settingsResetCaps => '重置为1000';

  @override
  String get settingsResetCapsSub => '重置余额和记录';

  @override
  String get settingsSignOut => '退出登录';

  @override
  String get settingsGuest => '访客';

  @override
  String get settingsSignedIn => '已登录';

  @override
  String get settingsGuestSession => '访客会话';

  @override
  String get onboardWelcomeTitle => '欢迎';

  @override
  String get onboardSignInTitle => '登录参与竞猜';

  @override
  String get onboardSignInSub => '赢取金币，支持球队。也可使用访客模式。';

  @override
  String get onboardYourName => '您的名字';

  @override
  String get onboardSignIn => '登录';

  @override
  String get onboardGuest => '以访客继续';

  @override
  String get onboardPickTeam => '选择您的球队';

  @override
  String get onboardPickTeamSub => '选择您支持的国家队，为他们的比赛投注金币。';

  @override
  String get onboardContinue => '继续';

  @override
  String get matchDetailStage => '阶段';

  @override
  String get matchDetailGroup => '小组';

  @override
  String get matchDetailDate => '日期';

  @override
  String get matchDetailVenue => '球场';

  @override
  String get matchDetailCity => '城市';

  @override
  String get matchDetailPenalties => '点球';

  @override
  String get profileYourVotes => '你的投票';

  @override
  String profileVotesCount(Object count) {
    return '已为 $count 场比赛投票';
  }

  @override
  String get profileAboutSection => '关于';

  @override
  String get profileAbout => '关于';

  @override
  String get profileAppInfo => '应用信息';

  @override
  String get profilePrivacy => '隐私政策';

  @override
  String get profileRate => '评价应用';

  @override
  String get profileShare => '分享应用';

  @override
  String get profileComingSoon => '敬请期待';

  @override
  String get profileClearVotes => '清除我的投票';

  @override
  String get profileClearVotesSub => '删除你的所有比赛投票';

  @override
  String get profileDeleteAccount => '删除账户';

  @override
  String get profileDeleteAccountSub => '永久删除你的账户';

  @override
  String get profileChooseTeam => '选择你的球队';

  @override
  String get profileNoVotes => '暂无投票';

  @override
  String profileYouPicked(Object pick) {
    return '你选择了：$pick';
  }

  @override
  String get profileDraw => '平局';

  @override
  String get deleteTitle => '删除账户？';

  @override
  String get deleteBody => '这将永久删除你的账户和投票，无法撤销。';

  @override
  String get deleteConfirmPassword => '确认密码';

  @override
  String get deleteEnterPassword => '请输入你的密码。';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '删除';

  @override
  String get profileLanguage => '语言';

  @override
  String get languageSystem => '系统默认';
}
