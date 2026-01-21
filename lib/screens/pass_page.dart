import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'main_wrapper.dart'; // adapte l'import si nécessaire

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

  final String _passInfo =
      'Pass festival 15€\n'
      'Tarif réduit 7€ par séance\n'
      'Valable dans tous les cinémas du festival';

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
        const SnackBar(content: Text('Pass supprimé')),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Supprimer le pass',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Voulez-vous vraiment supprimer votre pass festival ?',
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhotoCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && mounted) {
      final dir = await getApplicationDocumentsDirectory();
      final photoFile = File(
        '${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(image.path).copy(photoFile.path);
      setState(() => _photo = photoFile);
    }
  }

  Future<void> _pickPhotoGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      final dir = await getApplicationDocumentsDirectory();
      final photoFile = File(
        '${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(image.path).copy(photoFile.path);
      setState(() => _photo = photoFile);
    }
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une photo'),
        content: const Text(
          'Prendre une nouvelle photo ou sélectionner depuis la galerie.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoCamera();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text('Appareil photo'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickPhotoGallery();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text('Galerie'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPass() async {
    if (_prenomCtrl.text.isEmpty ||
        _nomCtrl.text.isEmpty ||
        _photo == null ||
        _box == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')),
        );
      }
      return;
    }

    if (mounted) setState(() => _purchasePending = true);
    await Future.delayed(const Duration(seconds: 1));

    final dir = await getApplicationDocumentsDirectory();
    final photoPath =
        '${dir.path}/pass_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _photo!.copy(photoPath);

    final passKey = 'userPass_$_userId';
    final qrContent =
        'Pass2026\n${_prenomCtrl.text}\n${_nomCtrl.text}\n${DateTime.now().toIso8601String().split('T')[0]}';

    await _box!.put(passKey, {
      'prenom': _prenomCtrl.text,
      'nom': _nomCtrl.text,
      'photoPath': photoPath,
      'qrContent': qrContent,
    });

    if (mounted) {
      setState(() {
        _hasPass = true;
        _passData = {
          'prenom': _prenomCtrl.text,
          'nom': _nomCtrl.text,
          'qrContent': qrContent,
          'photoPath': photoPath,
        };
        _purchasePending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pass créé')),
      );
    }
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initComplete) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Mon pass festival'),
        backgroundColor: Colors.white,
        foregroundColor: tertiaryColor,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hasPass
          ? _buildPassCard()
          : _buildCreateForm(),
    );
  }

  Widget _buildPassCard() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: _passData!['photoPath'] != null
                      ? Image.file(
                    File(_passData!['photoPath']),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_passData?['prenom'] ?? ''} ${_passData?['nom'] ?? ''}'
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: QrImageView(
                      data: _passData?['qrContent'] ?? '',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _showDeleteDialog,
                    icon: const Icon(Icons.delete),
                    label: const Text('Supprimer ce pass'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 60,
                  color: tertiaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pass festival',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _passInfo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _prenomCtrl,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _nomCtrl,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showPhotoPickerDialog,
                              icon: const Icon(Icons.add_a_photo, color: Colors.white),
                              label: Text(
                                _photo == null
                                    ? 'Ajouter une photo'
                                    : 'Photo ajoutée',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                tertiaryColor.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed:
                              _purchasePending ? null : _createPass,
                              icon: _purchasePending
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(Icons.event_available),
                              label: Text(
                                _purchasePending
                                    ? 'Création en cours'
                                    : 'Acheter un pass 15€',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[300],
                                foregroundColor: Colors.deepPurple,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
