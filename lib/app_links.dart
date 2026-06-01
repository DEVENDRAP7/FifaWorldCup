import 'package:url_launcher/url_launcher.dart';

/// Hosted on GitHub Pages. Edit docs/privacy-policy.html + push to update —
/// this URL stays the same, so no app change is needed later.
const String kPrivacyPolicyUrl =
    'https://devendrap7.github.io/FifaWorldCup/';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<void> openPrivacyPolicy() => openUrl(kPrivacyPolicyUrl);
