import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'footer.dart';
import '../services/notification_service.dart';

// modèle de donnéé

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

  final DateTime startTime;
  final int durationMinutes;
  final String location;

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
    required this.startTime,
    required this.durationMinutes,
    required this.location,
  });

  // Calcul heure de fin
  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

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
    DateTime? startTime,
    int? durationMinutes,
    String? location,
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
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
    );
  }
}

// données

class DataRepository {

  static DateTime _makeDate(int day, int hour, int minute) {
    return DateTime(2026, 9, day, hour, minute);
  }

  static List<ProgramItem> allItems = [

    // rétro / evenmenets
    ProgramItem(
        id: 'retro_fascifiction',
        title: "FasciFiction",
        category: "Rétrospectives", subCategory: "Politique",
        imageUrl: "assets/images/program/fasci_fiction.png",
        description: "FasciFiction présente 11 films éminemment politiques qui imaginent la vie sous des régimes tyranniques. De Alphaville à 1984, ces films dissèquent les outils totalitaires.",
        director: "Thématique", countryEmoji: "🌍",
        startTime: _makeDate(26, 14, 00), durationMinutes: 120, location: "Cinéma Vox - Salle 1"),

    ProgramItem(
        id: 'carte_blanche_aja',
        title: "Carte blanche Aja",
        category: "Rétrospectives", subCategory: "Invité",
        imageUrl: "assets/images/program/jurys/alexAja.png",
        description: "Alexandre Aja nous propose ses coups de cœur : de Onibaba à The Thing.",
        director: "Alexandre Aja", countryEmoji: "🇫🇷",
        startTime: _makeDate(27, 20, 00), durationMinutes: 180, location: "UGC Ciné Cité - Salle 12"),

    ProgramItem(
        id: 'retro_siri',
        title: "Double programme Siri",
        category: "Rétrospectives", subCategory: "Hommage",
        imageUrl: "assets/images/program/siri.png",
        description: "Focus sur le réalisateur Florent-Emilio Siri avec deux films d'action intenses.",
        director: "F-E. Siri", countryEmoji: "🇫🇷",
        startTime: _makeDate(28, 16, 30), durationMinutes: 210, location: "Star St-Exupéry"),

    ProgramItem(
        id: 'retro_guilty',
        title: "Guilty Pleasures",
        category: "Rétrospectives", subCategory: "Culte",
        imageUrl: "assets/images/program/jaws.png",
        description: "Des films cultes, effrayants ou étranges qu'on adore revoir.",
        director: "Sélection", countryEmoji: "🍿",
        startTime: _makeDate(29, 22, 00), durationMinutes: 100, location: "Cinéma Vox - Salle 3"),

    ProgramItem(
        id: 'nuit_excentrique',
        title: "La Nuit excentrique",
        category: "Événements", subCategory: "Nuit Nanar",
        imageUrl: "assets/images/program/nuit_excentrique.png",
        description: "Trois longs métrages truffés de faux raccords...",
        director: "Cinémathèque", countryEmoji: "🌙",
        startTime: _makeDate(27, 23, 59), durationMinutes: 360, location: "Star St-Exupéry - Grande Salle"),

    ProgramItem(
        id: '16', title: "Les Étranges Couleurs De VRANCKX", category: "Événements",
        imageUrl: "assets/images/program/VRANCKX.png",
        description: "Découvrez l’univers envoûtant de l’artiste belge Gilles Vranckx...",
        director: "Exposition", countryEmoji: "🇧🇪",
        startTime: _makeDate(26, 10, 00), durationMinutes: 600, location: "Village du Festival"),

    ProgramItem(
        id: '17', title: "SoFilm de Genre : lecture", category: "Événements",
        imageUrl: "assets/images/program/SoFilm-de-Genre.png",
        description: "Le magazine Sofilm organise des résidences de création...",
        director: "Atelier", countryEmoji: "🇫🇷",
        startTime: _makeDate(29, 14, 30), durationMinutes: 225, location: "Cinéma Vox"),

    // films
    ProgramItem(
        id: '1', title: "Good Boy", category: "Palmarès", subCategory: "Longs métrages",
        imageUrl: "assets/images/program/FANTASTIQUE-GOOD-BOY.png",
        description: "Indy, le fidèle retriever de Todd, accompagne ce dernier...",
        director: "Ben Leonberg", countryEmoji: "🇺🇸",
        startTime: _makeDate(26, 18, 00), durationMinutes: 90, location: "UGC Ciné Cité - Salle 4"),

    ProgramItem(
        id: '2', title: "Bugonia", category: "Longs métrages",
        imageUrl: "assets/images/program/bugonia.png",
        description: "Deux jeunes hommes obsédés par les théories du complot...",
        director: "Yorgos Lanthimos", countryEmoji: "🇬🇧",
        startTime: _makeDate(26, 20, 30), durationMinutes: 110, location: "Star St-Exupéry"),

    ProgramItem(
        id: '3', title: "LESS THAN 5GR OF SAFFRON", category: "Connexions",
        imageUrl: "assets/images/program/LT5OS.png",
        description: "Dans un désert postapocalyptique...",
        director: "Négar M.", countryEmoji: "🇮🇷",
        startTime: _makeDate(28, 14, 00), durationMinutes: 95, location: "Cinéma Vox"),

    ProgramItem(
        id: '4', title: "MAD MAX: FURY ROAD", category: "Connexions",
        imageUrl: "assets/images/program/madmax.png",
        description: "Golnaz, une jeune Iranienne de 23 ans...",
        director: "George Miller", countryEmoji: "🇦🇺",
        startTime: _makeDate(30, 20, 00), durationMinutes: 120, location: "UGC Ciné Cité - Salle 1"),

    ProgramItem(
        id: '13', title: "Double or Nothing", category: "Palmarès", subCategory: "Courts métrages",
        imageUrl: "assets/images/program/Double-or-Nothing.png",
        description: "Un Américain débarque dans le Tokyo des années 1980...",
        director: "Tokay Sirin", countryEmoji: "🇨🇭",
        startTime: _makeDate(27, 11, 00), durationMinutes: 20, location: "Star St-Exupéry"),

    ProgramItem(
        id: '14', title: "The Curse", category: "Longs métrages", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/theCurse.png",
        description: "Alertée par les messages inquiétants...",
        director: "Kenichi Ugana", countryEmoji: "🇯🇵",
        startTime: _makeDate(27, 22, 15), durationMinutes: 105, location: "Cinéma Vox"),

    ProgramItem(
        id: '15', title: "Gynoid", category: "Courts métrages",
        imageUrl: "assets/images/program/gynoid.png",
        description: "Dans un futur proche, deux femmes participent...",
        director: "Celia Galán", countryEmoji: "🇪🇸",
        startTime: _makeDate(27, 11, 25), durationMinutes: 15, location: "Star St-Exupéry"),

    ProgramItem(
        id: '18', title: "Sardinia", category: "Courts métrages",
        imageUrl: "assets/images/program/sardinia.png",
        description: "Dans une société dystopique, l’apparition d’un oiseau...",
        director: "Paul Kowalski", countryEmoji: "🇺🇸 🇵🇱",
        startTime: _makeDate(27, 11, 45), durationMinutes: 25, location: "Star St-Exupéry"),

    // jurys
    ProgramItem(
        id: '5', title: "Alexandre Aja", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/alexAja.png",
        description: "Président du Jury.",
        director: "Président", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),

    ProgramItem(
        id: '6', title: "Judith Berlanda-Beauvallet", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JudithB-B.png",
        description: "Créatrice de la chaîne Demoiselles d’Horreur.",
        director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),

    ProgramItem(
        id: '7', title: "Jean-Yves Roubin", category: "Jurys", subCategory: "Films fantastiques",
        imageUrl: "assets/images/program/jurys/JYR.png", description: "Producteur.", director: "Jury", countryEmoji: "🇧🇪",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
    ProgramItem(
        id: '8', title: "Stéphan Castang", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/Stephan-Castang.png", description: "Réalisateur.", director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
    ProgramItem(
        id: '9', title: "Marine Bohin", category: "Jurys", subCategory: "Méliès d’argent",
        imageUrl: "assets/images/program/jurys/bohin.png", description: "Journaliste.", director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
    ProgramItem(
        id: '10', title: "Stéphane Moïssakis", category: "Jurys", subCategory: "Crossovers",
        imageUrl: "assets/images/program/jurys/moissakis.png", description: "Capture Mag.", director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
    ProgramItem(
        id: '11', title: "Marc Jousset", category: "Jurys", subCategory: "Films animés",
        imageUrl: "assets/images/program/jurys/jousset.png", description: "Producteur.", director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
    ProgramItem(
        id: '12', title: "Kinane Moualla", category: "Jurys", subCategory: "Courts métrages",
        imageUrl: "assets/images/program/jurys/moualla.png", description: "Ingénieur son.", director: "Jury", countryEmoji: "🇫🇷",
        startTime: _makeDate(26, 19, 00), durationMinutes: 60, location: "Village Fantastique"),
  ];
}

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
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
        final itemToToggle = DataRepository.allItems[index];
        bool isAdding = !itemToToggle.isFavorite;

        void applyChange() {
          setState(() {
            DataRepository.allItems[index] = itemToToggle.copyWith(isFavorite: isAdding);
          });
          if (isAdding) {
            NotificationService.showNotification(
              id: itemToToggle.id.hashCode,
              title: "Ajouté au programme !",
              body: "${itemToToggle.title} à ${DateFormat('HH:mm').format(itemToToggle.startTime)}",
            );
          }
        }

        if (isAdding) {
          final currentFavorites = DataRepository.allItems.where((i) => i.isFavorite).toList();

          for (var fav in currentFavorites) {
            if (itemToToggle.startTime.isBefore(fav.endTime) &&
                itemToToggle.endTime.isAfter(fav.startTime)) {

              _showConflictWarning(fav.title, itemToToggle.title, applyChange);
            }
          }
        }
        applyChange();
      }
    });
  }

  void _showConflictWarning(String existingMovie, String newMovie, VoidCallback onForceAdd) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Conflit d'horaire"),
        content: Text("Attention, '$newMovie' a lieu en même temps que '$existingMovie' qui est déjà dans votre programme !"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("J'ai compris", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onForceAdd();
            },
            child: const Text("Ajouter quand même", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
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
              title: "Catalogue 2025",
              subtitle: "PDF Complet • 12.4 Mo",
              icon: Icons.menu_book,
              color: Colors.black,
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2025/09/FEFFS-2025-A5-nocoupe-planche.pdf"),
            ),
            const SizedBox(height: 12),
            _buildDownloadButton(
              title: "Grille Horaire 2025",
              subtitle: "Planning express • 220 Ko",
              icon: Icons.calendar_month,
              color: const Color(0xFFD78FEE),
              onTap: () => _launchDownload("https://strasbourgfestival.com/wp-content/uploads/2025/09/FEFFS-2025-Grille.pdf"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ProgramItem> filteredList = DataRepository.allItems.where((item) {
      if (_selectedCategories.contains("Tout")) return true;
      if (_selectedCategories.contains("Favoris") && item.isFavorite) return true;
      if (_selectedCategories.contains(item.category)) return true;
      return false;
    }).toList();

    if (_selectedCategories.contains("Jurys") && _selectedJurySubFilter != "Tous les jurys") {
      filteredList = filteredList.where((item) {
        if (item.category == "Jurys") return item.subCategory == _selectedJurySubFilter;
        return true;
      }).toList();
    }

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
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

          _buildFilterBar(),

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
          const SizedBox(height: 20),
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
              tooltip: 'Ajouter aux favoris',
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

class _ProgramCard extends StatelessWidget {
  final ProgramItem item;
  final VoidCallback onFavoriteChanged;

  const _ProgramCard({required this.item, required this.onFavoriteChanged});

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('EEE HH:mm', 'fr_FR').format(item.startTime);

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
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
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
                    (item.subCategory != null) ? item.subCategory!.toUpperCase() : item.category.toUpperCase(),
                    style: TextStyle(
                        color: (item.category == "Jurys") ? Colors.black : Colors.white,
                        fontSize: 8, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD78FEE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    dateString,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 8, left: 8, right: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
                          ),
                          Text(
                            item.location,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
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

class _DetailPage extends StatelessWidget {
  final ProgramItem item;
  const _DetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE d MMMM', 'fr_FR');
    final timeFormat = DateFormat('HH:mm');
    final endDateTime = item.startTime.add(Duration(minutes: item.durationMinutes));

    List<String> contentList = [];
    if (item.title == "FasciFiction") {
      contentList = ["The Testament of Dr. Mabuse", "Animal Farm", "Alphaville", "Fahrenheit 451", "The Year of the Cannibals", "THX 1138", "The Dead Zone", "Nineteen Eighty-Four", "The Handmaid’s Tale", "Starship Troopers", "Jin-Rô"];
    } else if (item.title.contains("Aja")) {
      contentList = ["High Tension", "The Hills Have Eyes", "Piranha 3D", "Horns", "Crawl", "Never Let Go"];
    } else if (item.title.contains("Siri")) {
      contentList = ["Nid de Guêpes", "Otage"];
    } else if (item.title == "Guilty Pleasures") {
      contentList = ["Jacob’s Ladder", "The Changeling", "Jaws"];
    } else if (item.title == "La Nuit excentrique") {
      contentList = ["Super Riders Against The Devil", "Godzilla vs. Mechagodzilla", "Hänsel und Gretel verliefen sich im Wald"];
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

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCol(Icons.calendar_today, "DATE", dateFormat.format(item.startTime)),
                        Container(width: 1, height: 40, color: Colors.white24),
                        _buildInfoCol(Icons.access_time, "HORAIRE", "${timeFormat.format(item.startTime)} - ${timeFormat.format(endDateTime)}"),
                        Container(width: 1, height: 40, color: Colors.white24),
                        _buildInfoCol(Icons.location_on, "LIEU", item.location),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text("À PROPOS",
                      style: TextStyle(color: Color(0xFFD78FEE), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  Text(item.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),

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

  Widget _buildInfoCol(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFD78FEE), size: 20),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}