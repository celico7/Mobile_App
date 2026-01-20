import 'package:flutter/material.dart';

@immutable
class DailyEvent {
  final String id;
  final String title;
  final String category;
  final String time;
  final String location;
  final String imageUrl;
  final String description;

  const DailyEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.description,
  });
}

class QuotidiennePage extends StatefulWidget {
  const QuotidiennePage({super.key});

  @override
  State<QuotidiennePage> createState() => _QuotidiennePageState();
}

class _QuotidiennePageState extends State<QuotidiennePage> {
  final List<DailyEvent> _events = const [
    DailyEvent(
      id: "1",
      title: "Atelier maquillage effets spéciaux",
      category: "Ateliers",
      time: "10:00 – 12:00",
      location: "Village Fantastique",
      imageUrl: "assets/images/daily/maquillage.jpg",
      description:
      "Découverte des techniques de maquillage FX utilisées dans le cinéma fantastique.",
    ),
    DailyEvent(
      id: "2",
      title: "Conférence Connexions : VR & jeux vidéo",
      category: "Conférences",
      time: "11:00",
      location: "Le Shadok",
      imageUrl: "assets/images/daily/vr_games.jpg",
      description:
      "Présentation des œuvres immersives et expériences interactives du festival.",
    ),
    DailyEvent(
      id: "3",
      title: "Zombie Walk",
      category: "Animations",
      time: "14:00",
      location: "Centre-ville de Strasbourg",
      imageUrl: "assets/images/daily/zombie_walk.jpg",
      description:
      "Déambulation costumée ouverte à tous dans les rues de Strasbourg.",
    ),
    DailyEvent(
      id: "4",
      title: "Rencontre avec un réalisateur invité",
      category: "Rencontres",
      time: "16:00",
      location: "Salle Europe",
      imageUrl: "assets/images/daily/meeting.jpg",
      description:
      "Échange et questions-réponses autour de la création d’un film fantastique.",
    ),
    DailyEvent(
      id: "5",
      title: "Défilé cosplay fantastique",
      category: "Animations",
      time: "18:30",
      location: "Village Fantastique",
      imageUrl: "assets/images/daily/cosplay.jpg",
      description:
      "Présentation de costumes inspirés du cinéma, de la BD et du jeu vidéo.",
    ),
    DailyEvent(
      id: "6",
      title: "Atelier cinéma jeune public",
      category: "Enfants",
      time: "15:30",
      location: "Espace Jeunesse",
      imageUrl: "assets/images/daily/kids.jpg",
      description:
      "Atelier ludique pour découvrir le cinéma fantastique dès le plus jeune âge.",
    ),
  ];

  final List<String> _categories = const [
    "Tout",
    "Ateliers",
    "Enfants",
    "Rencontres",
    "Animations",
    "Conférences",
  ];

  String _selectedCategory = "Tout";

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedCategory == "Tout"
        ? _events
        : _events
        .where((e) => e.category == _selectedCategory)
        .toList();

    return Column(
      children: [
        // FILTRES
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat == _selectedCategory;

              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xFFD78FEE),
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),

        // LISTE
        Expanded(
          child: filteredEvents.isEmpty
              ? const Center(child: Text("Aucune activité aujourd’hui"))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              return _DailyEventCard(event: filteredEvents[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _DailyEventCard extends StatelessWidget {
  final DailyEvent event;

  const _DailyEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // INFOS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${event.time} • ${event.location}",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 3,
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
