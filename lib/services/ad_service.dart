import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_ids.dart';
import 'consent_manager.dart';

/// Master ads switch — set false to kill ALL ads (banner, interstitial,
/// app-open). Off for store screenshots. Set true before release.
const bool kAdsEnabled = true;

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _ready = false;
  bool get ready => _ready;

  // No paid tier yet; flip via setPremium when a remove-ads purchase ships.
  bool _isPremium = false;
  bool get isPremium => _isPremium;
  void setPremium(bool value) => _isPremium = value;

  InterstitialAd? _interstitial;
  DateTime? _lastInterstitialShown; // when an interstitial was last presented

  AppOpenAd? _appOpen;
  bool _showingFullScreen = false;
  // Set when WE present a full-screen ad. Dismissing it fires an app
  // `resumed` event; without this guard that resume would chain an
  // app-open ad on top of the just-closed ad (AdMob policy violation).
  bool _suppressNextAppOpen = false;
  DateTime? _appOpenLoadTime;   // when the cached ad was loaded (for max-age)
  DateTime? _lastAppOpenShown;  // when an app-open ad was last presented

  // Show full-screen ads at most once per minute; reload app-open older than 4h.
  static const Duration _interstitialCooldown = Duration(minutes: 1);
  static const Duration _appOpenCooldown = Duration(minutes: 1);
  static const Duration _appOpenMaxAge = Duration(hours: 4);

  Future<void> init() async {
    if (_ready) return;
    if (_isPremium) return;
    if (!ConsentManager.instance.canShowAds) return;
    try {
      await MobileAds.instance.initialize();
      _ready = true;
      loadInterstitial();
      loadAppOpen();
    } catch (e) {
      if (kDebugMode) debugPrint('[Ad] init error: $e');
    }
  }

  bool get _canServe => kAdsEnabled && _ready && !_isPremium && ConsentManager.instance.canShowAds;

  // ── Banner (adaptive anchored) ───────────────────────────────
  Future<BannerAd?> createBannerAd(double width, {VoidCallback? onLoaded}) async {
    if (isPremium) return null;
    if (!_canServe) return null;
    // Anchored adaptive banner: fills the full screen width, no side letterbox.
    // Normal-height anchored adaptive (~50dp), full screen width — no tall box.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
    if (size == null) return null;
    final banner = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, e) {
          if (kDebugMode) debugPrint('[Ad] banner failed: ${e.message}');
          ad.dispose();
        },
      ),
    );
    await banner.load();
    return banner;
  }

  // ── Interstitial ─────────────────────────────────────────────
  void loadInterstitial() {
    if (!_canServe) return;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (e) => _interstitial = null,
      ),
    );
  }

  /// Shows an interstitial if one is ready and the 1-min cooldown has elapsed
  /// since the last one (and never overlaps another full-screen ad).
  void maybeShowInterstitial() {
    if (_isPremium || !_canServe || _showingFullScreen) return;

    // Cooldown: at most one interstitial per minute, no matter how many taps.
    final last = _lastInterstitialShown;
    if (last != null && DateTime.now().difference(last) < _interstitialCooldown) {
      return;
    }

    final ad = _interstitial;
    if (ad == null) {
      loadInterstitial();
      return;
    }
    _interstitial = null;
    _lastInterstitialShown = DateTime.now();
    _showingFullScreen = true;
    _suppressNextAppOpen = true; // don't chain an app-open on the dismiss resume
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _showingFullScreen = false;
        ad.dispose();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, e) {
        _showingFullScreen = false;
        ad.dispose();
        loadInterstitial();
      },
    );
    ad.show();
  }

  // ── App Open (shown on return from background) ───────────────
  void loadAppOpen() {
    if (!_canServe) return;
    AppOpenAd.load(
      adUnitId: AdIds.appOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpen = ad;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (e) => _appOpen = null,
      ),
    );
  }

  void showAppOpenIfAvailable() {
    if (!_canServe || _showingFullScreen) return;

    // This resume came from dismissing our own interstitial/app-open —
    // consume the flag and skip so we never stack two full-screen ads.
    if (_suppressNextAppOpen) {
      _suppressNextAppOpen = false;
      return;
    }

    // Cooldown: at most one app-open ad per minute.
    final last = _lastAppOpenShown;
    if (last != null && DateTime.now().difference(last) < _appOpenCooldown) {
      return;
    }

    final ad = _appOpen;
    if (ad == null) {
      loadAppOpen();
      return;
    }

    // Drop a stale ad (>4h old) and reload — never show an expired one.
    final loaded = _appOpenLoadTime;
    if (loaded != null && DateTime.now().difference(loaded) > _appOpenMaxAge) {
      ad.dispose();
      _appOpen = null;
      _appOpenLoadTime = null;
      loadAppOpen();
      return;
    }

    _appOpen = null;
    _lastAppOpenShown = DateTime.now();
    _showingFullScreen = true;
    _suppressNextAppOpen = true; // ignore the resume fired when this ad closes
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _showingFullScreen = false;
        _appOpenLoadTime = null;
        ad.dispose();
        loadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (ad, e) {
        _showingFullScreen = false;
        _appOpenLoadTime = null;
        ad.dispose();
        loadAppOpen();
      },
    );
    ad.show();
  }
}
