import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/news_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

    // IMPORTANT : On retourne directement la ListView, pas de Scaffold ici !
    return ListView.builder(
      itemCount: newsList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const _HeaderImage();
        return _NewsCard(item: newsList[index - 1]);
      },
    );
  }
}

// --- LES SOUS-COMPOSANTS (Header et Card) RESTENT ICI OU VONT DANS /widgets/ ---

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
          Image.asset('assets/images/home_header.png', fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(color: Colors.grey)),
          Container(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)]))),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem item;
  const _NewsCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(item.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (c, o, s) => const Icon(Icons.image_not_supported)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd('fr_FR').format(item.date), style: theme.textTheme.labelMedium),
                Text(item.title, style: theme.textTheme.titleLarge),
                Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}