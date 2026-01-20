import 'package:flutter/material.dart';

// ---------------------------------------------------------
// 1. LE MODÈLE DE DONNÉES
// ---------------------------------------------------------
@immutable
class ProgramItem {
  final String id;
  final String title;
  final String category;
  final String? subCategory;
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
// 2. LE "STOCKAGE" GLOBAL (C'est ici la correction des Favs !)
// ---------------------------------------------------------
// On sort la liste du Widget pour qu'elle ne soit pas réinitialisée
// à chaque changement de page.
class DataRepository {
  static List<ProgramItem> allItems = [
    // FILMS
    const ProgramItem(
        id: '1', title: "Good Boy", category: "Palmarès",
        imageUrl: "assets/images/program/FANTASTIQUE-GOOD-BOY.png",
        description: "Indy, le fidèle retriever de Todd, accompagne ce dernier dans une maison isolée...",
        director: "Ben Leonberg", countryEmoji: "🇺🇸"),
    const ProgramItem(
        id: '2', title: "Bugonia", category: "Longs métrages",
        imageUrl: "assets/images/program/bugonia.png",
        description: "Deux jeunes hommes obsédés par les théories du complot...",
        director: "Yorgos Lanthimos", countryEmoji: "🇬🇧"),
    const ProgramItem(
        id: '3', title: "LESS THAN 5GR OF SAFFRON", category: "Connexions",
        imageUrl: "assets/images/program/LT5OS.png",
        description: "Golnaz, une jeune Iranienne de 23 ans qui a immigré en Allemagne...",
        director: "Négar Motevalymeidanshah", countryEmoji: "🇮🇷"),
    const ProgramItem(
        id: '4', title: "Mad Max: Fury Road", category: "Rétrospectives",
        imageUrl: "assets/images/program/movie2.jpg",
        description: "Hanté par un lourd passé, Mad Max estime que le meilleur moyen...",
        director: "George Miller", countryEmoji: "🇦🇺"),

    // JURYS
    const ProgramItem(
        id: '5', title: "Alexandre Aja", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/alexAja.png",
        description: "Fils du réalisateur Alexandre Arcady...",
        director: "Président du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '6', title: "Judith Berlanda-Beauvallet", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JudithB-B.png",
        description: "Créatrice de la chaîne Demoiselles d’Horreur...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '7', title: "Jean-Yves Roubin", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JYR.png",
        description: "Jean-Yves Roubin a fondé Frakas Productions...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '8', title: "Stéphan Castang", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/Stephan-Castang.png",
        description: "En tant que cinéaste, Stéphan Castang réalise...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '9', title: "Marine Bohin", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/bohin.png",
        description: "Journaliste cinéma depuis dix ans...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '10', title: "Stéphane Moïssakis", category: "Jurys", subCategory: "Crossovers",
        imageUrl: "assets/images/program/jurys/moissakis.png",
        description: "Journaliste culturel depuis vingt-cinq ans...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '11', title: "Marc Jousset", category: "Jurys", subCategory: "Films animés",
        imageUrl: "assets/images/program/jurys/jousset.png",
        description: "Marc Jousset fonde le studio Je Suis Bien Content...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '12', title: "Kinane Moualla", category: "Jurys", subCategory: "Courts métrages",
        imageUrl: "assets/images/program/jurys/moualla.png",
        description: "Ingénieur du son diplômé de l’ISTS...",
        director: "Membre du Jury", countryEmoji: "🇫🇷"),
  ];
}

// ---------------------------------------------------------
// 3. LA PAGE PRINCIPALE
// ---------------------------------------------------------
class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
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

  // --- ÉTAT (State) ---
  final Set<String> _selectedCategories = {"Tout"};
  String _selectedJurySubFilter = "Tous les jurys";

  // --- LOGIQUE ---

  void _toggleFavoriteStatus(String itemId) {
    setState(() {
      // On modifie directement la liste STATIQUE dans DataRepository
      final index = DataRepository.allItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        DataRepository.allItems[index] = DataRepository.allItems[index].copyWith(
            isFavorite: !DataRepository.allItems[index].isFavorite
        );
      }
    });
  }

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

  // Fonction pour lancer le téléchargement (Simulation pour l'instant)
  Future<void> _launchDownload(String url) async {
    // Pour l'instant, on affiche juste un message.
    // Pour le faire marcher réellement :
    // 1. Ajoute 'url_launcher: ^6.2.0' dans pubspec.yaml
    // 2. Décommente le code ci-dessous :
    /*
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    */
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ouverture du lien vers le PDF...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Si "Catalogue" est sélectionné, on retourne une vue spéciale
    if (_selectedCategories.contains("Catalogue") && _selectedCategories.length == 1) {
      return Column(
        children: [
          // On garde la barre de filtres pour pouvoir revenir en arrière
          _buildFilterBar(),
          Expanded(child: _buildCatalogueView()),
        ],
      );
    }

    // 2. Sinon, on fait le filtrage normal des films
    List<ProgramItem> filteredList = DataRepository.allItems.where((item) {
      if (_selectedCategories.contains("Tout")) return true;
      if (_selectedCategories.contains("Favoris") && item.isFavorite) return true;
      if (_selectedCategories.contains(item.category)) return true;
      return false;
    }).toList();

    // Filtrage secondaire Jurys
    if (_selectedCategories.contains("Jurys") && _selectedJurySubFilter != "Tous les jurys") {
      filteredList = filteredList.where((item) {
        if (item.category == "Jurys") return item.subCategory == _selectedJurySubFilter;
        return true;
      }).toList();
    }

    return Column(
      children: [
        _buildFilterBar(), // Zone 1 : Filtres

        // Zone 2 : Sous-filtres Jurys
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
                  onTap: () => setState(() => _selectedJurySubFilter = subCat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(subCat, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),

        // Zone 3 : Grille
        Expanded(
          child: filteredList.isEmpty
              ? const Center(child: Text("Aucun élément trouvé"))
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 16, mainAxisSpacing: 16,
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

  // J'ai extrait la barre de filtre dans une méthode pour que le code soit plus propre
  Widget _buildFilterBar() {
    return Container(
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
    );
  }

  // --- NOUVELLE VUE : CATALOGUE ---
  Widget _buildCatalogueView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_for_offline, size: 80, color: Color(0xFFD78FEE)),
            const SizedBox(height: 24),
            const Text(
              "Documents du Festival",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Retrouvez ici le programme complet au format PDF.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Bouton 1 : Catalogue
            _buildDownloadButton(
              title: "Télécharger le Catalogue",
              subtitle: "PDF - 12.4 Mo",
              icon: Icons.menu_book,
              color: Colors.black,
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2025/09/FEFFS-2025-A5-nocoupe-planche.pdf"),
            ),
            const SizedBox(height: 16),

            // Bouton 2 : Grille Horaire
            _buildDownloadButton(
              title: "Télécharger la Grille",
              subtitle: "PDF - 220 Ko",
              icon: Icons.calendar_month,
              color: const Color(0xFFD78FEE),
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2025/09/FEFFS-2025-Grille.pdf"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap
  }) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. LES WIDGETS (Carte et Détail) - INCHANGÉS
// ---------------------------------------------------------
// (Garde tes widgets _ProgramCard et _DetailPage tels quels ici)
// Je les remets pour que le code soit complet

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
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text(item.category), backgroundColor: const Color(0xFFD78FEE).withOpacity(0.2)),
                      if(item.subCategory != null)
                        Chip(label: Text(item.subCategory!), backgroundColor: Colors.black.withOpacity(0.1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
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