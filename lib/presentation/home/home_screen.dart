import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receiving_books_scanner/presentation/home/home_events.dart';
import 'package:receiving_books_scanner/presentation/home/home_view_model.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_screen.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    final viewModel = context.read<HomeViewModel>();

    _streamSubscription = viewModel.eventStream.listen((event) {
      event.when(
        showSnackBar: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
          );
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final state = viewModel.state;
    const textStyle = TextStyle(
      fontSize: 18,
      height: 1.4,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          final isbn = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (_) => QrScanViewModel(),
                    child: const QrScanScreen())),
          );
          if (isbn != null) {
            viewModel.onEvent(HomeEvents.setIsbnList(isbn));
          }
        },
      ),
      appBar: AppBar(
        title: const Text('주문 정보'),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                viewModel.onEvent(const HomeEvents.sendIsbnList());
                              },
                              child: const Text('구글 시트로 보내기'),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                viewModel.onEvent(const HomeEvents.resetScreen());
                              },
                              child: const Text('화면 초기화'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...state.isbnList
                        .map((e) => Column(
                              children: [
                                Text(e, style: textStyle),
                                const Divider(
                                  color: Colors.black45,
                                )
                              ],
                            ))
                        .toList(),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
