import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

class PassPage extends StatefulWidget {
  const PassPage({super.key});

  @override
  State<PassPage> createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _prenomCtrl = TextEditingController();
  final TextEditingController _nomCtrl = TextEditingController();
  File? _photo;
  bool _loading = true;
  bool _purchasePending = false;
  bool _hasPass = false;
  Map<String, dynamic>? _passData;
  Box? _box;
  String? _userId;
  bool _initComplete = false;

  // Texte raccourci - juste le prix
  final String _passInfo = 'Pass Festival 15€\nTarif réduit 7€/séance\nValable tous cinémas du festival';

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
      _box = await Hive.openBox('passBox');
      _userId = 'festival_user_${dir.path.hashCode}';
      await _loadPass();
    } catch (e) {
      debugPrint('Init error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _initComplete = true;
        });
      }
    }
  }

  Future<void> _loadPass() async {
    if (_userId == null || _box == null) return;
    final passKey = 'userPass_$_userId';
    final pass = _box!.get(passKey);
    if (pass != null && mounted) {
      setState(() {
        _hasPass = true;
        _passData = Map<String, dynamic>.from(pass as Map);
        _prenomCtrl.text = _passData?['prenom'] ?? '';
        _nomCtrl.text = _passData?['nom'] ?? '';
      });
    }
  }

  Future<void> _deletePass() async {
    final passKey = 'userPass_$_userId';
    await _box?.delete(passKey);
    if (mounted) {
      setState(() {
        _hasPass = false;
        _passData = null;
        _prenomCtrl.clear();
        _nomCtrl.clear();
        _photo = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Pass supprimé !'))
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le pass ?', style: TextStyle(color: Colors.red)),
        content: const Text('Vous êtes sûr de vouloir supprimer votre pass festival ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePass();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhotoCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && mounted) {
      final dir = await getApplicationDocumentsDirectory();
      final photoFile = File('${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await File(image.path).copy(photoFile.path);
      setState(() => _photo = photoFile);
    }
  }

  Future<void> _pickPhotoGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      final dir = await getApplicationDocumentsDirectory();
      final photoFile = File('${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await File(image.path).copy(photoFile.path);
      setState(() => _photo = photoFile);
    }
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une photo'),
        content: const Text('Prendre une nouvelle photo ou sélectionner depuis la galerie ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoCamera();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.camera_alt), SizedBox(width: 8), Text('Appareil photo')],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoGallery();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.photo_library), SizedBox(width: 8), Text('Galerie')],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPass() async {
    if (_prenomCtrl.text.isEmpty || _nomCtrl.text.isEmpty || _photo == null || _box == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tout remplir !'))
      );
      return;
    }

    if (mounted) setState(() => _purchasePending = true);
    await Future.delayed(const Duration(seconds: 1));

    final dir = await getApplicationDocumentsDirectory();
    final photoPath = '${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _photo!.copy(photoPath);

    final passKey = 'userPass_$_userId';
    final qrContent = 'Pass2026\n${_prenomCtrl.text}\n${_nomCtrl.text}\n${DateTime.now().toIso8601String().split('T')[0]}';
    await _box!.put(passKey, {
      'prenom': _prenomCtrl.text,
      'nom': _nomCtrl.text,
      'photoPath': photoPath,
      'qrContent': qrContent,
    });

    if (mounted) {
      setState(() {
        _hasPass = true;
        _passData = {'prenom': _prenomCtrl.text, 'nom': _nomCtrl.text, 'qrContent': qrContent, 'photoPath': photoPath};
        _purchasePending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pass créé !'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initComplete) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Pass Festival'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hasPass
          ? _buildPassCard()
          : _buildCreateForm(),
    );
  }

  Widget _buildPassCard() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: _passData!['photoPath'] != null
                    ? Image.file(
                  File(_passData!['photoPath']),
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                )
                    : Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                '${_passData?['prenom'] ?? ''} ${_passData?['nom'] ?? ''}'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: QrImageView(
                    data: _passData?['qrContent'] ?? '',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showDeleteDialog,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Supprimer ce pass', style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple, Colors.deepPurpleAccent],
        ),
      ),
      child: Center(
        child: SingleChildScrollView( // Ajouté pour éviter overflow
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_available, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Créer Pass Festival',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // INFO PRIX RACCOURCIE
                Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    _passInfo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
                // FORMULAIRE
                Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _prenomCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.person, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _nomCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showPhotoPickerDialog,
                          icon: Icon(_photo == null ? Icons.add_a_photo : Icons.photo, color: Colors.white),
                          label: Text(_photo == null ? 'Ajouter photo' : 'Photo ✓',
                              style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _purchasePending ? null : _createPass,
                          icon: _purchasePending
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                              : const Icon(Icons.event_available, color: Colors.deepPurple),
                          label: Text(_purchasePending ? 'Création...' : 'Créer Pass 15€',
                              style: const TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[300],
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
