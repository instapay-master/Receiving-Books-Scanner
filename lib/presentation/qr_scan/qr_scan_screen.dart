import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
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
  TextEditingController textController = TextEditingController();
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
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                Navigator.pop(context, state.count);
              },
              child: const Text('ISBN 전달'),
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
                  onQRViewCreated: (controller) async {
                    this.controller = controller;
                    if (Platform.isAndroid) {
                      await controller.pauseCamera();
                      await controller.resumeCamera();
                    }
                    controller.scannedDataStream.listen((scanData) async {
                      FlutterBeep.beep();
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
                if (data.isEmpty) {
                  return const Text('');
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              data[index],
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      textController.text =
                                          state.count[data[index]].toString();
                                      return AlertDialog(
                                        title: const Text('수량 변경'),
                                        content: TextField(
                                          controller: textController,
                                          keyboardType: TextInputType.number,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('취소')),
                                          TextButton(
                                              onPressed: () {
                                                viewModel.onEvent(
                                                    QrScanEvent.changeIsbnCount(
                                                        data[index],
                                                        textController.text));
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('확인')),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    '수량 : ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      textBaseline: TextBaseline.ideographic,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    state.count[data[index]].toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      textBaseline: TextBaseline.ideographic,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    viewModel
                                        .onEvent(QrScanEvent.deleteIsbn(index));
                                  },
                                  icon: const Icon(Icons.delete_outline_sharp)),
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Colors.black45,
                      ),
                    ],
                  );
                }
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
