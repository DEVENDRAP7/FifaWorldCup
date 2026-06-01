import 'package:flutter/foundation.dart';

/// Live ad unit IDs are used ONLY in release builds. Debug/profile use Google's
/// official test IDs — tapping a live ad from a dev device = AdMob suspension.
class AdIds {
  // Google official Android TEST ids
  static const _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';

  // Live (publisher ca-app-pub-2519904265266366)
  static const _liveBanner = 'ca-app-pub-2519904265266366/2085559701';
  static const _liveInterstitial = 'ca-app-pub-2519904265266366/9287438474';
  static const _liveAppOpen = 'ca-app-pub-2519904265266366/3745821812';

  static String get banner => kReleaseMode ? _liveBanner : _testBanner;
  static String get interstitial => kReleaseMode ? _liveInterstitial : _testInterstitial;
  static String get appOpen => kReleaseMode ? _liveAppOpen : _testAppOpen;
}
