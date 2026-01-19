import 'package:flutter/material.dart';

// ---------------------------------------------------------
// 1. LE MODÈLE DE DONNÉES (Immuable)
// ---------------------------------------------------------
@immutable
class ProgramItem {
  final String id;
  final String title;
  final String category;
  final String? subCategory; // Nouveau : Pour le type de Jury
  final String imageUrl;
  final String description;
  final bool isFavorite;
  final String director;
  final String countryEmoji;

  const ProgramItem({
    required this.id,
    required this.title,
    required this.category,
    this.subCategory,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
    required this.director,
    required this.countryEmoji,
  });

  ProgramItem copyWith({
    String? id,
    String? title,
    String? category,
    String? subCategory,
    String? imageUrl,
    String? description,
    bool? isFavorite,
    String? director,
    String? countryEmoji,
  }) {
    return ProgramItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      director: director ?? this.director,
      countryEmoji: countryEmoji ?? this.countryEmoji,
    );
  }
}

// ---------------------------------------------------------
// 2. LA PAGE PRINCIPALE
// ---------------------------------------------------------
class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  // --- A. LES DONNÉES (Base de données simulée) ---
  final List<ProgramItem> _allItems = [
    // FILMS
    const ProgramItem(
        id: '1', title: "Good Boy", category: "Palmarès",
        imageUrl: "assets/images/program/FANTASTIQUE-GOOD-BOY.png",
        description: "Indy, le fidèle retriever de Todd, accompagne ce dernier dans une maison isolée...",
        director: "Ben Leonberg", countryEmoji: "🇺🇸"),
    const ProgramItem(
        id: '5', title: "Bugonia", category: "Longs métrages",
        imageUrl: "assets/images/program/bugonia.png",
        description: "Deux jeunes hommes obsédés par les théories du complot kidnappent la PDG...",
        director: "Yorgos Lanthimos", countryEmoji: "🇬🇧"),
    const ProgramItem(
        id: '6', title: "LESS THAN 5GR OF SAFFRON", category: "Connexions",
        imageUrl: "assets/images/program/LT5OS.png",
        description: "Golnaz, une jeune Iranienne de 23 ans qui a immigré en Allemagne...",
        director: "Négar Motevalymeidanshah", countryEmoji: "🇮🇷"), // J'ai mis le drapeau Iranien/Allemand supposé
    const ProgramItem(
        id: '2', title: "Mad Max: Fury Road", category: "Rétrospectives",
        imageUrl: "assets/images/program/movie2.jpg", // Vérifie tes chemins d'images !
        description: "Hanté par un lourd passé, Mad Max estime que le meilleur moyen de survivre est de rester seul.",
        director: "George Miller", countryEmoji: "🇦🇺"),

    // JURYS (Avec sous-catégories)
    // 1. Films fantastiques
    const ProgramItem(
        id: '10', title: "Alexandre Aja", category: "Invités", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/alexAja.png",
        description: "Fils du réalisateur Alexandre Arcady... Réalisateur de Haute Tension et Crawl.",
        director: "Président du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '11', title: "Judith Berlanda-Beauvallet", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/JudithB-B.png",
        description: "Créatrice de la chaîne Demoiselles d’Horreur...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),

    // 2. Méliès d’argent
    const ProgramItem(
        id: '12', title: "Stéphan Castang", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/stephan.png", // Image placeholder si besoin
        description: "Réalisateur de Vincent doit mourir.",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),

    // 3. Crossovers
    const ProgramItem(
        id: '13', title: "Stéphane Moïssakis", category: "Jurys", subCategory: "Crossovers",
        imageUrl: "assets/images/program/moissakis.png",
        description: "Journaliste et co-fondateur de Capture Mag.",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),

    // 4. Films animés
    const ProgramItem(
        id: '14', title: "Marc Jousset", category: "Jurys", subCategory: "Films animés",
        imageUrl: "assets/images/program/jousset.png",
        description: "Producteur et réalisateur d'animation.",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
  ];

  // Listes des filtres
  final List<String> _categories = const [
    "Tout", "Favoris", "Palmarès", "Longs métrages", "Rétrospectives",
    "Courts métrages", "Connexions", "Événements", "Invités", "Jurys", "Catalogue"
  ];

  final List<String> _jurySubCategories = const [
    "Tous les jurys",
    "Films fantastiques",
    "Méliès d’argent",
    "Crossovers",
    "Films animés",
    "Courts métrages"
  ];

  // --- B. ÉTAT (State) ---
  final Set<String> _selectedCategories = {"Tout"}; // Multi-sélection
  String _selectedJurySubFilter = "Tous les jurys"; // Filtre secondaire unique

  // --- C. LOGIQUE ---

  // Gère les favoris
  void _toggleFavoriteStatus(String itemId) {
    setState(() {
      final index = _allItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _allItems[index] = _allItems[index].copyWith(
            isFavorite: !_allItems[index].isFavorite
        );
      }
    });
  }

  // Gère la sélection des filtres principaux (Multi-select)
  void _onCategorySelected(String cat, bool selected) {
    setState(() {
      if (cat == "Tout") {
        _selectedCategories.clear();
        _selectedCategories.add("Tout");
      } else {
        _selectedCategories.remove("Tout");
        if (selected) {
          _selectedCategories.add(cat);
        } else {
          _selectedCategories.remove(cat);
        }
      }
      if (_selectedCategories.isEmpty) {
        _selectedCategories.add("Tout");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // FILTRAGE
    List<ProgramItem> filteredList = _allItems.where((item) {
      // 1. Si "Tout" est coché, on prend tout
      if (_selectedCategories.contains("Tout")) return true;

      // 2. Si "Favoris" est coché et que l'item est favori, on garde
      if (_selectedCategories.contains("Favoris") && item.isFavorite) return true;

      // 3. Si la catégorie de l'item est dans la liste des catégories cochées
      if (_selectedCategories.contains(item.category)) return true;

      return false;
    }).toList();

    // FILTRAGE SECONDAIRE (JURYS)
    // On affine la liste si on est en mode Jurys avec un sous-filtre actif
    if (_selectedCategories.contains("Jurys") && _selectedJurySubFilter != "Tous les jurys") {
      filteredList = filteredList.where((item) {
        // On ne touche qu'aux items de type Jurys
        if (item.category == "Jurys") {
          return item.subCategory == _selectedJurySubFilter;
        }
        // Les autres catégories (ex: Longs métrages sélectionnés en même temps) restent affichées
        return true;
      }).toList();
    }

    return Column(
      children: [
        // --- ZONE 1 : FILTRES PRINCIPAUX ---
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
              final isSelected = _selectedCategories.contains(cat);

              return FilterChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (bool selected) => _onCategorySelected(cat, selected),
                selectedColor: const Color(0xFFD78FEE),
                backgroundColor: Colors.grey[200],
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            },
          ),
        ),

        // --- ZONE 2 : SOUS-FILTRES JURYS (Conditionnel) ---
        if (_selectedCategories.contains("Jurys"))
          Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _jurySubCategories.length,
              separatorBuilder: (ctx, i) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final subCat = _jurySubCategories[index];
                final isSelected = subCat == _selectedJurySubFilter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedJurySubFilter = subCat;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      subCat,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        // --- ZONE 3 : GRILLE DES RÉSULTATS ---
        Expanded(
          child: filteredList.isEmpty
              ? const Center(child: Text("Aucun élément trouvé"))
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

// ---------------------------------------------------------
// 3. LES WIDGETS (Carte et Détail)
// ---------------------------------------------------------

class _ProgramCard extends StatelessWidget {
  final ProgramItem item;
  final VoidCallback onFavoriteChanged;

  const _ProgramCard({required this.item, required this.onFavoriteChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => _DetailPage(item: item)));
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
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.white54))
                    ),
                  ),
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        // Affiche le sous-type si c'est un Jury, sinon la catégorie
                        (item.category == "Jurys" && item.subCategory != null)
                            ? item.subCategory!.toUpperCase()
                            : item.category.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // INFOS
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))
                  ),
                  IconButton(
                    icon: Icon(item.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: item.isFavorite ? Colors.red : Colors.grey, size: 20),
                    onPressed: onFavoriteChanged,
                    padding: EdgeInsets.zero, constraints: const BoxConstraints(),
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

class _DetailPage extends StatelessWidget {
  final ProgramItem item;
  const _DetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(item.title, style: const TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(item.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (c,o,s)=>Container(height:300, color:Colors.grey[300])),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges de catégorie
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text(item.category), backgroundColor: const Color(0xFFD78FEE).withOpacity(0.2)),
                      if(item.subCategory != null)
                        Chip(label: Text(item.subCategory!), backgroundColor: Colors.black.withOpacity(0.1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Titre
                  Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Infos Réalisateur / Pays
                  Row(children: [
                    const Icon(Icons.person, color: Colors.grey),
                    const SizedBox(width: 8),
                    Flexible(child: Text(item.director, style: const TextStyle(fontSize: 16))),

                    Container(height: 15, width: 1, color: Colors.grey, margin: const EdgeInsets.symmetric(horizontal: 15)),

                    Text(item.countryEmoji, style: const TextStyle(fontSize: 24)),
                  ]),

                  const SizedBox(height: 24),
                  const Text("Synopsis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}