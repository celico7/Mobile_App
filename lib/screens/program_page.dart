import 'package:flutter/material.dart';

// 1. LE MODÈLE DE DONNÉES (Simulé ici, pas de BDD)
class ProgramItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  bool isFavorite;

  ProgramItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });
}

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  // 2. LES DONNÉES EN DUR (Hardcoded)
  // Ajoute tes vrais films ici plus tard
  final List<ProgramItem> _allItems = [
    ProgramItem(
        id: '1',
        title: "The Substance",
        category: "Longs métrages",
        imageUrl: "assets/images/program/FANTASTIQUE-GOOD-BOY.png",
        description: "Un film choc sur la beauté éternelle..."),
    ProgramItem(
        id: '2',
        title: "Mad Max: Fury Road",
        category: "Rétrospectives",
        imageUrl: "assets/images/movie2.jpg",
        description: "Le chef d'oeuvre de George Miller en noir et blanc."),
    ProgramItem(
        id: '3',
        title: "Compétition Courts 1",
        category: "Courts métrages",
        imageUrl: "assets/images/shorts.jpg",
        description: "Sélection des meilleurs courts européens."),
    ProgramItem(
        id: '4',
        title: "Rencontre avec Carpenter",
        category: "Invités",
        imageUrl: "assets/images/guest.jpg",
        description: "Masterclass exceptionnelle."),
    ProgramItem(
        id: '5',
        title: "Conan le Barbare",
        category: "Rétrospectives",
        imageUrl: "assets/images/conan.jpg",
        description: "Le classique de la fantasy."),
  ];

  // Liste des catégories exactes demandées
  final List<String> _categories = [
    "Tout",
    "Favoris",
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

  @override
  Widget build(BuildContext context) {
    // 3. LOGIQUE DE FILTRE
    final filteredList = _selectedCategory == "Tout"
        ? _allItems
        : _allItems.where((item) => item.category == _selectedCategory).toList();

    return Column(
      children: [
        // --- ZONE DES FILTRES (Haut) ---
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
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                // Style personnalisé pour coller à ton thème
                selectedColor: Colors.redAccent,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            },
          ),
        ),

        // --- GRILLE DES FILMS (Bas) ---
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cartes par ligne
              childAspectRatio: 0.65, // Ratio Hauteur/Largeur (format affiche)
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return _ProgramCard(item: filteredList[index]);
            },
          ),
        ),
      ],
    );
  }
}

// 4. LE COMPOSANT CARTE (Similaire à ton style HomePage)
class _ProgramCard extends StatefulWidget {
  final ProgramItem item;
  const _ProgramCard({required this.item});

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers la page détail
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _DetailPage(item: widget.item)),
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
                    widget.item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, color: Colors.white54, size: 50),
                    ),
                  ),
                  // PETIT TAG CATÉGORIE SUR L'IMAGE
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
                        widget.item.category.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // TITRE ET COEUR
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.item.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.item.isFavorite = !widget.item.isFavorite;
                      });
                      // TODO: Ajouter ici la logique pour sauvegarder dans la BDD plus tard
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(), // Pour réduire la taille du bouton
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

// 5. PAGE DÉTAIL SIMPLIFIÉE
class _DetailPage extends StatelessWidget {
  final ProgramItem item;
  const _DetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              item.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (c,o,s) => Container(height: 300, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Chip(label: Text(item.category)),
                  const SizedBox(height: 16),
                  Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}