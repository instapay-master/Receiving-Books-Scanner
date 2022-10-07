import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_event.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_view_model.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QrScanViewModel>();
    final state = viewModel.state;

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            '바코드 Scan',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context,state.isbnListSet);
              },
              child: Text('ISBN 전달'),
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    this.controller = controller;
                    controller.scannedDataStream.listen((scanData) async {
                      await controller.pauseCamera();
                      result = scanData;
                      if (result!.code != null) {
                        //Navigator.pop(context, result!.code);
                        viewModel.onEvent(QrScanEvent.addIsbn(result!.code!));
                      }
                      await Future.delayed(const Duration(milliseconds: 500));
                      await controller.resumeCamera();
                    });
                  },
                  overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderLength: scanArea / 2,
                      cutOutSize: scanArea),
                  onPermissionSet: (ctrl, p) =>
                      _onPermissionSet(context, ctrl, p),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: scanArea - 70, left: scanArea - 70),
                    child: IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                      },
                      icon: const Icon(Icons.flash_on),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 350),
                  child: Center(
                    child: Text(
                      '책 바코드를 스캔해주세요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: state.isbnListSet.length,
              itemBuilder: (BuildContext context, int index) {
                List<String> data = state.isbnListSet.toList();
                return data.isEmpty
                    ? const Text('')
                    : Column(
                        children: [
                          Text(
                            data[index],
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.black45,
                          ),
                        ],
                      );
              },
            ),
          )),
        ],
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
