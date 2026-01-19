import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/news_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // --- DONNÉES MOCKÉES ---
  // On définit la liste ici. Pas de 'const' car DateTime n'est pas une constante compile-time.
  final List<NewsItem> _news = const [
    // Note: Pour garder la liste 'const' si tu le souhaites vraiment,
    // il faudrait passer par des Strings, mais restons simple et propre :
  ];

  // Je crée une méthode qui génère mes données pour éviter les erreurs de syntaxe 'const'
  List<NewsItem> get _festivalNews => [
    NewsItem(
      title: "Ouverture de la billetterie",
      description: "Prenez vos places dès maintenant pour profiter des tarifs Early Bird !",
      imageUrl: "assets/images/crowd.jpg",
      date: DateTime(2024, 05, 20),
    ),
    NewsItem(
      title: "Nouvelle tête d'affiche !",
      description: "Nous sommes fiers d'annoncer la venue exceptionnelle de cet artiste.",
      imageUrl: "assets/images/artist.jpg",
      date: DateTime(2024, 06, 01),
    ),
    NewsItem(
      title: "Plan du village disponible",
      description: "Retrouvez tous les stands et foodtrucks sur notre map interactive.",
      imageUrl: "assets/images/map.jpg",
      date: DateTime(2024, 06, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final newsList = _festivalNews;

    return Scaffold(
      // 1. BARRE D'APPLICATION
      appBar: AppBar(
        title: const Text("FEFFS"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo_festival.png',
              height: 32,
              width: 32,
              errorBuilder: (c, o, s) => const Icon(Icons.music_note),
            ),
          ),
        ],
      ),

      // 2. MENU LATÉRAL
      drawer: const _FestivalDrawer(),

      // 3. CORPS DE PAGE (Scrollable)
      body: ListView.builder(
        itemCount: newsList.length + 1, // +1 pour inclure l'image d'en-tête
        itemBuilder: (context, index) {
          if (index == 0) {
            // L'élément tout en haut : la grande image
            return const _HeaderImage();
          }

          // Les articles (index - 1 car le header prend la place 0)
          final item = newsList[index - 1];
          return _NewsCard(item: item);
        },
      ),
    );
  }
}

// --- COMPOSANT : IMAGE D'EN-TÊTE ---
class _HeaderImage extends StatelessWidget {
  const _HeaderImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home_header.jpg',
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.festival, size: 50),
            ),
          ),
          // Dégradé pour l'esthétique
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- COMPOSANT : CARTE ACTUALITÉ ---
class _NewsCard extends StatelessWidget {
  final NewsItem item;
  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            item.imageUrl,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => Container(
              height: 160,
              color: theme.colorScheme.surfaceVariant,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd('fr_FR').format(item.date),
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 4),
                Text(item.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- COMPOSANT : MENU LATÉRAL ---
class _FestivalDrawer extends StatelessWidget {
  const _FestivalDrawer();

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) => Navigator.pop(context),
      selectedIndex: 0,
      children: [
        const DrawerHeader(
          child: Center(
            child: Text("FEFFS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Accueil'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month),
          label: Text('Programme'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.newspaper_outlined),
          selectedIcon: Icon(Icons.newspaper),
          label: Text('Actualités'),
        ),
        const Divider(indent: 20, endIndent: 20),
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          label: Text('Infos pratiques'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.contact_support_outlined),
          label: Text('Contact'),
        ),
      ],
    );
  }
}