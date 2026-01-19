import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String? _qrCode;
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

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
                    }
                  },
                )
                    : Center(
                  child: Icon(Icons.qr_code_2,
                      size: 200, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_qrCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "QR Code détecté: $_qrCode",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Scanner à nouveau"),
              onPressed: () {
                setState(() {
                  _isScanning = true;
                  _qrCode = null;
                });
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
