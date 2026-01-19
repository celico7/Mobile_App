import 'package:flutter/material.dart';

// 1. LE MODÈLE (Rien à changer, c'est parfait)
@immutable
class ProgramItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final bool isFavorite;

  const ProgramItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  ProgramItem copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return ProgramItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  // 2. LES DONNÉES
  // Note: J'ai retiré le 'const' devant la liste [...] pour qu'elle soit modifiable,
  // même si les items à l'intérieur sont const au départ.
  final List<ProgramItem> _allItems = [
    const ProgramItem(
        id: '1',
        title: "The Substance",
        category: "Longs métrages",
        // Vérifie bien que ce chemin est exact (majuscules/minuscules)
        imageUrl: "assets/images/program/FANTASTIQUE-GOOD-BOY.png",
        description: "Un film choc sur la beauté éternelle..."),
    const ProgramItem(
        id: '2',
        title: "Mad Max: Fury Road",
        category: "Rétrospectives",
        imageUrl: "assets/images/movie2.jpg",
        description: "Le chef d'oeuvre de George Miller en noir et blanc."),
    const ProgramItem(
        id: '3',
        title: "Compétition Courts 1",
        category: "Courts métrages",
        imageUrl: "assets/images/shorts.jpg",
        description: "Sélection des meilleurs courts européens."),
    const ProgramItem(
        id: '4',
        title: "Rencontre avec Carpenter",
        category: "Invités",
        imageUrl: "assets/images/guest.jpg",
        description: "Masterclass exceptionnelle."),
  ];

  final List<String> _categories = const [
    "Tout",
    "Favoris", // Ce bouton va maintenant marcher
    "Palmarès",
    "Longs métrages",
    "Rétrospectives",
    "Courts métrages",
    "Connexions",
    "Événements",
    "Invités",
    "Jurys",
    "Catalogue"
  ];

  String _selectedCategory = "Tout";

  void _toggleFavoriteStatus(String itemId) {
    setState(() {
      final index = _allItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        // On remplace l'item par sa copie modifiée
        _allItems[index] = _allItems[index].copyWith(
            isFavorite: !_allItems[index].isFavorite
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. FILTRAGE
    List<ProgramItem> filteredList;
    if (_selectedCategory == "Tout") {
      filteredList = _allItems;
    } else if (_selectedCategory == "Favoris") {
      filteredList = _allItems.where((item) => item.isFavorite).toList();
    } else {
      filteredList = _allItems.where((item) => item.category == _selectedCategory).toList();
    }

    return Column(
      children: [
        // --- ZONE FILTRES ---
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (bool selected) {
                  // On empêche de désélectionner un filtre (pour éviter d'avoir 0 filtre actif)
                  if (selected) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  }
                },
                // Ta couleur Violette demandée
                selectedColor: const Color(0xFFD78FEE),
                backgroundColor: Colors.grey[200],
                // On met le texte en blanc si sélectionné, sinon noir
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                // On enlève la bordure grise moche par défaut
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            },
          ),
        ),

        // --- ZONE GRILLE ---
        Expanded(
          child: filteredList.isEmpty
              ? Center(child: Text("Aucun élément trouvé")) // Petit message si liste vide
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];
              return _ProgramCard(
                item: item,
                onFavoriteChanged: () => _toggleFavoriteStatus(item.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final ProgramItem item;
  final VoidCallback onFavoriteChanged;

  const _ProgramCard({
    required this.item,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _DetailPage(item: item)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey[800],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image, color: Colors.white54),
                          const SizedBox(height: 4),
                          // Affiche un texte d'erreur pour t'aider à débugger
                          const Text("Image introuvable", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // INFO & COEUR
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13, // Légèrement plus petit pour éviter les débordements
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      item.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: item.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoriteChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ta classe _DetailPage reste inchangée
class _DetailPage extends StatelessWidget {
  final ProgramItem item;
  const _DetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Center(child: Text("Détails de ${item.title}")), // Placeholder rapide
    );
  }
}