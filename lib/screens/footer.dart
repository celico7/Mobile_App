import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Importation des icônes officielles
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color tertiaryColor = Color(0xFFD78FEE);

class FestivalFooter extends StatelessWidget {
  const FestivalFooter({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          // Partenaires
          Image.asset(
            'assets/images/Footer-partenaires-2025.png',
            fit: BoxFit.contain,
            errorBuilder: (c, o, s) => const Icon(Icons.handshake, color: Colors.white24),
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24, indent: 50, endIndent: 50),
          const SizedBox(height: 30),

          const Text(
            "SUIVEZ-NOUS",
            style: TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12),
          ),
          const SizedBox(height: 25),

          // --- LOGOS OFFICIELS ---
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              _socialIcon(FontAwesomeIcons.facebook, "https://www.facebook.com/FantasticStras"),
              _socialIcon(FontAwesomeIcons.xTwitter, "https://x.com/fantasticstras"), // Le nouveau logo X
              _socialIcon(FontAwesomeIcons.youtube, "https://www.youtube.com/channel/UCOlimDLIczqAURJM58BGYxw/feed"),
              _socialIcon(FontAwesomeIcons.instagram, "https://www.instagram.com/fantasticstras/"),
              _socialIcon(FontAwesomeIcons.linkedin, "https://www.linkedin.com/company/feffs/"),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            "MENTIONS LÉGALES  •  POLITIQUE DE CONFIDENTIALITÉ",
            style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
          ),
          const SizedBox(height: 15),
          const Text(
            "© 2026 FESTIVAL EUROPÉEN DU FILM FANTASTIQUE DE STRASBOURG",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: tertiaryColor.withOpacity(0.3)),
          shape: BoxShape.circle,
        ),
        child: FaIcon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}