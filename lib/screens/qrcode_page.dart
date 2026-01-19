import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_dart_decoder/qr_code_dart_decoder.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String? _qrCode;
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  Future<void> _scanFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      // Decoder QR depuis image
      final decoder = QrCodeDartDecoder();
      final result = await decoder.decodeFile(imageBytes);

      setState(() {
        if (result != null && result.text.isNotEmpty) {
          _qrCode = result.text;
          _isScanning = false;
        } else {
          _qrCode = "Aucun QR trouvé dans l'image";
          _isScanning = false;
        }
      });
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
                        _qrCode =
                            barcode.rawValue ?? "QR vide";
                        _isScanning = false;
                      });
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scanner un QR Code"),
                  onPressed: () {
                    setState(() {
                      _isScanning = true;
                      _qrCode = null;
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Accéder à la galerie"),
                  onPressed: _scanFromGallery,
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
