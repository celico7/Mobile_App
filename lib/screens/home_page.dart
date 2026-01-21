import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/news_item.dart';
import 'footer.dart';
import 'pass_page.dart';

const Color tertiaryColor = Color(0xFFD78FEE);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<NewsItem> get _festivalNews => [
    NewsItem(
      title: "À vos candidatures !",
      description: "Postulez jusqu’au 20 février 2026 pour rejoindre l'aventure.",
      imageUrl: "assets/images/news1.png",
      date: DateTime(2026, 01, 15),
    ),
    NewsItem(
      title: "Palmarès de la 18e édition",
      description: "Et les gagnants sont… Découvrez le verdict du jury.",
      imageUrl: "assets/images/news2.png",
      date: DateTime(2025, 10, 05),
    ),
    NewsItem(
      title: "FEFFS 2025 : Invité d’honneur",
      description: "Alexandre Aja sera l’invité d’honneur de cette nouvelle édition !",
      imageUrl: "assets/images/aja.png",
      date: DateTime(2025, 09, 20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListView(
        children: [
          _HomeSlider(),
          _HeroDates(),
          _PassActionCard(),
          _WelcomeSection(),
          _AboutExpandable(),
          _buildSectionTitle(context, "Aperçu d'un des films du festival !"),
          const _VideoPlayerSection(videoId: "2dx5uTN_zgY"),

          _buildSectionTitle(context, "Dernières Actualités"),
          ..._festivalNews.map((item) => _NewsCard(item: item)),
          const SizedBox(height: 20),
          const FestivalFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _VideoPlayerSection extends StatefulWidget {
  final String videoId;
  const _VideoPlayerSection({required this.videoId});

  @override
  State<_VideoPlayerSection> createState() => _VideoPlayerSectionState();
}

class _VideoPlayerSectionState extends State<_VideoPlayerSection> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: tertiaryColor,
          progressColors: const ProgressBarColors(
            playedColor: tertiaryColor,
            handleColor: tertiaryColor,
          ),
        ),
      ),
    );
  }
}

// --- 1. LE SLIDER ---
class _HomeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/home_header.png',
      'assets/images/home_header2.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 380.0,
        autoPlay: true,
        viewportFraction: 1.0,
      ),
      items: images.map((imagePath) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}

// --- 2. LES DATES ---
class _HeroDates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: Colors.black,
      child: Column(
        children: [
          const Text("ON VOUS ATTEND NOMBREUX",
              style: TextStyle(color: tertiaryColor, letterSpacing: 4, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          const Text("DU 26 SEPTEMBRE AU 5 OCTOBRE 2026",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// --- 3. SECTION À PROPOS ---
class _AboutExpandable extends StatefulWidget {
  const _AboutExpandable();
  @override
  State<_AboutExpandable> createState() => _AboutExpandableState();
}

class _AboutExpandableState extends State<_AboutExpandable> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("À PROPOS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tertiaryColor,
                      letterSpacing: 2,
                      fontSize: 12)),
              Icon(Icons.info_outline, color: tertiaryColor, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Le rendez-vous majeur du cinéma fantastique en France.",
            style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                height: 1.4),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 15),
            _buildAboutParagraph(
                "Le Festival européen du film fantastique de Strasbourg est un rendez-vous majeur du cinéma fantastique en France..."),
            _buildAboutParagraph(
                "En sa qualité de membre affilié à la MIFF, le festival organise la compétition du Méliès d’argent..."),
          ],
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              child: Text(isExpanded ? "VOIR MOINS" : "LIRE LA SUITE",
                  style: const TextStyle(
                      color: tertiaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black54, height: 1.6, fontSize: 14),
      ),
    );
  }
}

// --- 4. CARTE PASS ---
class _PassActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [tertiaryColor, Color(0xFF9249CC)]
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: tertiaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.confirmation_number_outlined, size: 45, color: Colors.white),
            const SizedBox(height: 15),
            const Text("PRÊT POUR L'AVENTURE ?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white)),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PassPage())),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF9249CC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: const Text("ACHETER UN PASS", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// --- 5. BIENVENUE ---
class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 30, 24, 5),
      child: Text("Le festival",
          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w900)),
    );
  }
}

// --- 6. CARTE NEWS ---
class _NewsCard extends StatelessWidget {
  final NewsItem item;
  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(item.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: tertiaryColor),
                    const SizedBox(width: 6),
                    Text(DateFormat.yMMMd('fr_FR').format(item.date),
                        style: const TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(item.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2)),
                const SizedBox(height: 8),
                Text(item.description,
                    style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}