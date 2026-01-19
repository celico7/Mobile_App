import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:qr_code_dart_decoder/qr_code_dart_decoder.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String? _qrCode;
  bool _isScanning = false;
  final MobileScannerController _controller = MobileScannerController();

  /// Ouvre la vraie galerie photo (WeChat style)
  Future<void> _openWeChatGallery() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: 1,
      ),
    );

    if (assets != null && assets.isNotEmpty) {
      final AssetEntity asset = assets.first;
      final file = await asset.file;
      if (file != null) {
        final Uint8List bytes = await file.readAsBytes();
        final decoder = QrCodeDartDecoder();
        final result = await decoder.decodeFile(bytes);

        setState(() {
          if (result != null && result.text.isNotEmpty) {
            _qrCode = result.text;
            _isScanning = false;
            _controller.stop();
          } else {
            _qrCode = "Aucun QR trouvé dans l'image sélectionnée";
            _isScanning = false;
            _controller.stop();
          }
        });
      }
    }
  }

  /// Montre une boîte de dialogue personnalisée pour demander la permission caméra
  Future<bool> _askForCameraPermissionDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Accès à la caméra"),
        content: const Text(
            "Pour scanner un QR Code, l'application a besoin de l'accès à la caméra."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Oui"),
          ),
        ],
      ),
    ) ??
        false;
  }

  /// Vérifie la permission, demande si nécessaire, puis active la caméra
  Future<void> _requestAndStartCameraScan() async {
    // Popup perso avant popup système
    final wantsPermission = await _askForCameraPermissionDialog();
    if (!wantsPermission) {
      return; // l'utilisateur n'a pas voulu
    }

    // Demande la permission au système
    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        _qrCode = null;
        _isScanning = true;
      });
      _controller.start(); // relance la caméra
    } else if (status.isPermanentlyDenied) {
      // L'utilisateur a refusé définitivement : propose d'ouvrir les réglages
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Permission caméra"),
          content: const Text(
              "La permission caméra a été refusée définitivement. Veux‑tu ouvrir les paramètres ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(ctx);
              },
              child: const Text("Ouvrir paramètres"),
            ),
          ],
        ),
      );
    } else {
      // Permission refusée sans être permanente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission caméra refusée")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        elevation: 8,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  "Lecteur de QR Code",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isScanning
                    ? MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (capture.barcodes.isNotEmpty) {
                      final barcode = capture.barcodes.first;
                      setState(() {
                        _qrCode = barcode.rawValue ?? "QR vide";
                        _isScanning = false;
                      });
                      _controller.stop();
                    }
                  },
                )
                    : const Center(
                  child: Icon(Icons.qr_code_2,
                      size: 200, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_qrCode != null)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "QR Code détecté: $_qrCode",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Nouveau bouton scanner qui gère la permission
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scanner un QR Code"),
                  onPressed: _requestAndStartCameraScan,
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Galerie photo"),
                  onPressed: _openWeChatGallery,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
