import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:qr_code_dart_decoder/qr_code_dart_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String? _qrCode;
  bool _isScanning = false;
  final MobileScannerController _controller = MobileScannerController();

  /// Ouvre le lien du QR code
  Future<void> _openLink(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Une fois ouvert, on affiche le message "page ouverte"
      setState(() {
        _qrCode = "Page ouverte dans le navigateur. Vous pouvez scanner un autre QR.";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lien invalide")),
      );
    }
  }

  /// Ouvre la vraie galerie photo
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

        if (result != null && result.text.isNotEmpty) {
          setState(() {
            _qrCode = result.text;
          });
          _openLink(result.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Aucun QR trouvé dans l'image")),
          );
        }
      }
    }
  }

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

  Future<void> _requestAndStartCameraScan() async {
    final wantsPermission = await _askForCameraPermissionDialog();
    if (!wantsPermission) return;

    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        _isScanning = true;
        _qrCode = null; // reset à chaque ouverture
      });
      _controller.start();
    } else if (status.isPermanentlyDenied) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
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
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isScanning
                    ? MobileScanner(
                  controller: _controller,
                  onDetect: (capture) async {
                    if (capture.barcodes.isNotEmpty) {
                      final barcode = capture.barcodes.first;
                      final code = barcode.rawValue ?? "QR vide";

                      // affiche le QR scanné
                      setState(() {
                        _qrCode = code;
                      });

                      // ouvre le lien, mais scanner reste actif
                      await _openLink(code);
                    }
                  },
                )
                    : const Center(
                  child: Icon(Icons.qr_code_2,
                      size: 200, color: Colors.grey),
                ),
              ),
            ),
            if (_qrCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _qrCode!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scanner un QR Code"),
                  onPressed: _requestAndStartCameraScan,
                ),
                const SizedBox(height: 10),
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
