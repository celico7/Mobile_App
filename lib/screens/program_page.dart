import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'footer.dart'; // Assure-toi que ce fichier existe bien dans ton projet

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
// 2. LE "STOCKAGE" GLOBAL
// ---------------------------------------------------------
class DataRepository {
  static List<ProgramItem> allItems = [

    // --- GROSSES THÉMATIQUES (RÉTROSPECTIVES) ---

    // 1. FASCI-FICTION
    const ProgramItem(
        id: 'retro_fascifiction',
        title: "FasciFiction",
        category: "Rétrospectives",
        subCategory: "Politique",
        imageUrl: "assets/images/program/fasci_fiction.png",
        description: "FasciFiction présente 11 films éminemment politiques qui imaginent la vie sous des régimes tyranniques. De Alphaville à 1984, ces films dissèquent les outils totalitaires.",
        director: "Thématique", countryEmoji: "🌍"),

    // 2. CARTE BLANCHE AJA (Déplacé dans Rétrospectives comme demandé)
    const ProgramItem(
        id: 'carte_blanche_aja',
        title: "Carte blanche Aja",
        category: "Rétrospectives",
        subCategory: "Invité",
        imageUrl: "assets/images/program/jurys/alexAja.png",
        description: "Alexandre Aja nous propose ses coups de cœur : de Onibaba à The Thing.",
        director: "Alexandre Aja", countryEmoji: "🇫🇷"),

    // 3. DOUBLE PROGRAMME SIRI (Nouveau)
    const ProgramItem(
        id: 'retro_siri',
        title: "Double programme Siri",
        category: "Rétrospectives",
        subCategory: "Hommage",
        imageUrl: "assets/images/program/siri.png", // Mets une image de Florent-Emilio Siri ou d'un de ses films
        description: "Focus sur le réalisateur Florent-Emilio Siri avec deux films d'action intenses.",
        director: "F-E. Siri", countryEmoji: "🇫🇷"),

    // 4. GUILTY PLEASURES (Nouveau)
    const ProgramItem(
        id: 'retro_guilty',
        title: "Guilty Pleasures",
        category: "Rétrospectives",
        subCategory: "Culte",
        imageUrl: "assets/images/program/jaws.png", // Image des dents de la mer
        description: "Des films cultes, effrayants ou étranges qu'on adore revoir.",
        director: "Sélection", countryEmoji: "🍿"),

    // --- ÉVÉNEMENTS ---
    const ProgramItem(
        id: 'nuit_excentrique',
        title: "La Nuit excentrique",
        category: "Événements",
        subCategory: "Nuit Nanar",
        imageUrl: "assets/images/program/nuit_excentrique.png",
        description: "Trois longs métrages truffés de faux raccords et d'effets spéciaux douteux. Petit déjeuner offert !",
        director: "Cinémathèque", countryEmoji: "🌙"),


    // --- FILMS INDIVIDUELS (Classiques & Nouveautés) ---
    const ProgramItem(
        id: '1', title: "Good Boy", category: "Palmarès", subCategory: "Longs métrages",
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
        id: '13', title: "Double or Nothing", category: "Palmarès", subCategory: "Courts métrages",
        imageUrl: "assets/images/program/Double-or-Nothing.png",
        description: "Un Américain débarque dans le Tokyo des années 1980...",
        director: "Tokay Sirin", countryEmoji: "🇨🇭"),
    const ProgramItem(
        id: '14', title: "The Curse", category: "Longs métrages", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/theCurse.png",
        description: "Alertée par les messages inquiétants de son amie postés depuis Taïwan...",
        director: "Kenichi Ugana", countryEmoji: "🇯🇵"),

    // --- JURYS (Complet) ---
    // Films Fantastiques
    const ProgramItem(
        id: '5', title: "Alexandre Aja", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/alexAja.png",
        description: "Président du Jury. Réalisateur de Haute Tension et Crawl.",
        director: "Président", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '6', title: "Judith Berlanda-Beauvallet", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JudithB-B.png",
        description: "Créatrice de la chaîne Demoiselles d’Horreur.",
        director: "Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '7', title: "Jean-Yves Roubin", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JYR.png",
        description: "Producteur de Grave et Titane.",
        director: "Jury", countryEmoji: "🇧🇪"),

    // Méliès
    const ProgramItem(
        id: '8', title: "Stéphan Castang", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/Stephan-Castang.png",
        description: "Réalisateur de Vincent doit mourir.",
        director: "Jury", countryEmoji: "🇫🇷"),
    const ProgramItem(
        id: '9', title: "Marine Bohin", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/bohin.png",
        description: "Journaliste cinéma pour Sofilm.",
        director: "Jury", countryEmoji: "🇫🇷"),

    // Crossovers
    const ProgramItem(
        id: '10', title: "Stéphane Moïssakis", category: "Jurys", subCategory: "Crossovers",
        imageUrl: "assets/images/program/jurys/moissakis.png",
        description: "Journaliste et co-fondateur de Capture Mag.",
        director: "Jury", countryEmoji: "🇫🇷"),

    // Animés
    const ProgramItem(
        id: '11', title: "Marc Jousset", category: "Jurys", subCategory: "Films animés",
        imageUrl: "assets/images/program/jurys/jousset.png",
        description: "Producteur de Persepolis.",
        director: "Jury", countryEmoji: "🇫🇷"),

    // Courts
    const ProgramItem(
        id: '12', title: "Kinane Moualla", category: "Jurys", subCategory: "Courts métrages",
        imageUrl: "assets/images/program/jurys/moualla.png",
        description: "Ingénieur du son.",
        director: "Jury", countryEmoji: "🇫🇷"),

    const ProgramItem(
        id: '13', title: "Gynoid", category: "Courts métrages",
        imageUrl: "assets/images/program/gynoid.png",
        description: "Dans un futur proche, deux femmes participent à une expérience orchestrée par une entreprise de robotique pour déterminer laquelle d’entre elles est une androïde. Persuadées toutes les deux d’être humaines, elles s’engagent dans un face-à-face troublant, entre doute, manipulation et instinct de survie.",
        director: "Celia Galán", countryEmoji: "🇪🇸"),

    const ProgramItem(
        id: '14', title: "Sardinia", category: "Courts métrages",
        imageUrl: "assets/images/program/sardinia.png",
        description: "Dans une société dystopique, l’apparition d’un oiseau exotique déclenche une épidémie de rires incontrôlables qui se répand à grande vitesse. Un homme, étrangement immunisé, tente de protéger son père malade et son épouse, alors que le monde sombre peu à peu dans l’absurde et le chaos.",
        director: "Paul Kowalski", countryEmoji: "🇺🇸 🇵🇱"),
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
  // Liste des filtres EXACTE par rapport aux catégories des données
  final List<String> _categories = const [
    "Tout", "Favoris", "Palmarès", "Longs métrages", "Rétrospectives",
    "Courts métrages", "Connexions", "Événements", "Jurys"

  ];

  final List<String> _jurySubCategories = const [
    "Tous les jurys",
    "Films fantastiques",
    "Méliès d’argent",
    "Crossovers",
    "Films animés",
    "Courts métrages"
  ];

  final Set<String> _selectedCategories = {"Tout"};
  String _selectedJurySubFilter = "Tous les jurys";

  void _toggleFavoriteStatus(String itemId) {
    setState(() {
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

  Future<void> _launchDownload(String url) async {
    final Uri uri = Uri.parse(url);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ouverture du PDF..."),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFD78FEE),
      ),
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : Impossible d'ouvrir le lien ($e)")),
      );
    }
  }

  void _showCatalogueModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const Text("Documents Officiels", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildDownloadButton(
              title: "Catalogue 2024",
              subtitle: "PDF Complet • 12 Mo",
              icon: Icons.menu_book,
              color: Colors.black,
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2024/09/FEFFS_2024_CATALOGUE_WEB.pdf"),
            ),
            const SizedBox(height: 12),
            _buildDownloadButton(
              title: "Grille Horaire 2024",
              subtitle: "Planning express • 2 Mo",
              icon: Icons.calendar_month,
              color: const Color(0xFFD78FEE),
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2024/09/FEFFS_2024_GRILLE_WEB.pdf"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LOGIQUE DE FILTRAGE CORRIGÉE
    List<ProgramItem> filteredList = DataRepository.allItems.where((item) {
      // 1. Si "Tout" est sélectionné
      if (_selectedCategories.contains("Tout")) return true;
      // 2. Si "Favoris" est sélectionné
      if (_selectedCategories.contains("Favoris") && item.isFavorite) return true;
      // 3. Correspondance exacte de catégorie
      if (_selectedCategories.contains(item.category)) return true;

      return false;
    }).toList();

    // Sous-filtre Jurys
    if (_selectedCategories.contains("Jurys") && _selectedJurySubFilter != "Tous les jurys") {
      filteredList = filteredList.where((item) {
        if (item.category == "Jurys") return item.subCategory == _selectedJurySubFilter;
        return true;
      }).toList();
    }

    // UTILISATION D'UNE LISTVIEW GLOBALE POUR POUVOIR METTRE LE FOOTER EN BAS
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero, // On gère le padding manuellement
        children: [
          // 1. HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 10), // Padding top augmenté pour la barre d'état
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Programmation",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                OutlinedButton.icon(
                  onPressed: _showCatalogueModal,
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text("PDF"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD78FEE),
                    side: const BorderSide(color: Color(0xFFD78FEE)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                )
              ],
            ),
          ),

          // 2. FILTRES
          _buildFilterBar(),

          // 3. SOUS-FILTRES JURYS
          if (_selectedCategories.contains("Jurys"))
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _jurySubCategories.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final subCat = _jurySubCategories[index];
                  final isSelected = subCat == _selectedJurySubFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedJurySubFilter = subCat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400),
                      ),
                      child: Text(subCat, style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                      )),
                    ),
                  );
                },
              ),
            ),

          // 4. GRILLE DES RÉSULTATS
          // On utilise physics: NeverScrollableScrollPhysics car c'est déjà dans une ListView
          filteredList.isEmpty
              ? SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_filter_outlined, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("Aucun résultat", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                ],
              ),
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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

          const FestivalFooter(),
          const SizedBox(height: 20), // Un peu d'espace en bas
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategories.contains(cat);

          if (cat == "Favoris") {
            return FilterChip(
              avatar: Icon(Icons.favorite, size: 16, color: isSelected ? Colors.white : Colors.red),
              label: Text(cat),
              selected: isSelected,
              onSelected: (bool selected) => _onCategorySelected(cat, selected),
              selectedColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.red, fontWeight: FontWeight.bold),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }

          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (bool selected) => _onCategorySelected(cat, selected),
            selectedColor: const Color(0xFFD78FEE),
            backgroundColor: Colors.grey[100],
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

  Widget _buildDownloadButton({
    required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
            ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.download, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. LES WIDGETS (Carte)
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
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(color: Colors.grey[800], child: const Center(child: Icon(Icons.movie, color: Colors.white24, size: 40))),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (item.category == "Jurys") ? Colors.white : Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    // Affiche le sous-type si dispo (ex: "Films Fantastiques")
                    (item.subCategory != null) ? item.subCategory!.toUpperCase() : item.category.toUpperCase(),
                    style: TextStyle(
                        color: (item.category == "Jurys") ? Colors.black : Colors.white,
                        fontSize: 8, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8, left: 8, right: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onFavoriteChanged,
                      child: Icon(
                        item.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: item.isFavorite ? Colors.red : Colors.white70,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 5. PAGE DE DÉTAIL
// ---------------------------------------------------------
class _DetailPage extends StatelessWidget {
  final ProgramItem item;
  const _DetailPage({required this.item});

  @override
  Widget build(BuildContext context) {

    // CONTENU SPÉCIFIQUE (Listes des films pour les rétrospectives)
    List<String> contentList = [];

    if (item.title == "FasciFiction") {
      contentList = [
        "The Testament of Dr. Mabuse", "Animal Farm", "Alphaville",
        "Fahrenheit 451", "The Year of the Cannibals", "THX 1138",
        "The Dead Zone", "Nineteen Eighty-Four", "The Handmaid’s Tale",
        "Starship Troopers", "Jin-Rô"
      ];
    } else if (item.title.contains("Aja")) {
      contentList = [
        "High Tension", "The Hills Have Eyes", "Piranha 3D",
        "Horns", "Crawl", "Never Let Go"
      ];
    } else if (item.title.contains("Siri")) {
      contentList = ["Nid de Guêpes", "Otage"];
    } else if (item.title == "Guilty Pleasures") {
      contentList = ["Jacob’s Ladder", "The Changeling", "Jaws"];
    } else if (item.title == "La Nuit excentrique") {
      contentList = [
        "Super Riders Against The Devil",
        "Godzilla vs. Mechagodzilla",
        "Hänsel und Gretel verliefen sich im Wald"
      ];
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (c,o,s) => Container(color: Colors.grey[900])),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.transparent, Colors.black],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD78FEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(item.category.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                      Text(item.countryEmoji, style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.1)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(item.director, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                      if (item.subCategory != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(item.subCategory!, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                      ]
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text("À PROPOS",
                      style: TextStyle(color: Color(0xFFD78FEE), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  Text(item.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),

                  // LISTE DES FILMS (RÉTROSPECTIVES)
                  if (contentList.isNotEmpty) ...[
                    const SizedBox(height: 40),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.movie_filter, color: Color(0xFFD78FEE)),
                        const SizedBox(width: 10),
                        Text("FILMS AU PROGRAMME (${contentList.length})",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contentList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: ListTile(
                            leading: Text("${index + 1}", style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                            title: Text(contentList[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            trailing: const Icon(Icons.play_circle_outline, color: Colors.white30),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}