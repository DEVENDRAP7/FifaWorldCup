import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google UMP consent (GDPR/EEA). Must run before MobileAds.initialize().
/// Non-EEA users resolve instantly with no form shown.
class ConsentManager {
  ConsentManager._();
  static final ConsentManager instance = ConsentManager._();

  bool _canShowAds = true; // default true (most regions need no consent)
  bool get canShowAds => _canShowAds;

  Future<void> initialize() async {
    final completer = Completer<void>();
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        try {
          await ConsentForm.loadAndShowConsentFormIfRequired((formError) {});
        } catch (e) {
          if (kDebugMode) debugPrint('[Consent] form error: $e');
        }
        try {
          _canShowAds = await ConsentInformation.instance.canRequestAds();
        } catch (_) {
          _canShowAds = true;
        }
        if (!completer.isCompleted) completer.complete();
      },
      (error) {
        if (kDebugMode) debugPrint('[Consent] update error: ${error.message}');
        _canShowAds = true; // fail open
        if (!completer.isCompleted) completer.complete();
      },
    );
    return completer.future;
  }
}
