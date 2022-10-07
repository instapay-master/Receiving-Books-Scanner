import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receiving_books_scanner/presentation/home/home_events.dart';
import 'package:receiving_books_scanner/presentation/home/home_view_model.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_screen.dart';

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
    const boldTextStyle = TextStyle(
      fontSize: 18,
      height: 1.4,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          final isbn = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrScanScreen()),
          );
          viewModel.onEvent(HomeEvents.searchIsbn(isbn));
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
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ISBN: ',
                            textAlign: TextAlign.end,
                            style: boldTextStyle,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              state.isbn,
                              style: textStyle,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '책 제목: ',
                            textAlign: TextAlign.end,
                            style: boldTextStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.bookStatusList.isEmpty
                                ? ''
                                : state.bookStatusList[0].title,
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '출판사명: ',
                            textAlign: TextAlign.end,
                            style: boldTextStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.bookStatusList.isEmpty
                                ? ''
                                : state.bookStatusList[0].publisher,
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            viewModel.onEvent(const HomeEvents.resetScreen());
                          },
                          child: const Text('화면 초기화')),
                    ),
                    const Divider(
                      height: 2,
                      thickness: 1.5,
                      color: Colors.black87,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              '입고',
                              textAlign: TextAlign.center,
                              style: boldTextStyle,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '수취인명',
                            textAlign: TextAlign.center,
                            style: boldTextStyle,
                          )),
                          Expanded(
                              child: Text(
                            '주문일',
                            textAlign: TextAlign.center,
                            style: boldTextStyle,
                          )),
                        ],
                      ),
                    ),
                    ...state.bookStatusList.map((e) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Checkbox(
                                  value: state.receivingDoneSet.contains(e),
                                  onChanged: (bool? value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text('입고 처리 변경'),
                                              content: !state.receivingDoneSet.contains(e)
                                                  ? const Text('입고 처리 하시겠습니까?')
                                                  : const Text('입고 해제 처리 하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      viewModel.onEvent(
                                                          OnUpdateReceivingStatus(
                                                              e,
                                                              !state.receivingDoneSet.contains(e)));
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('OK')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Cancel')),
                                              ],
                                            ));
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.userName,
                                  textAlign: TextAlign.center,
                                  style: textStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.date,
                                  textAlign: TextAlign.center,
                                  style: textStyle,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black45,
                          )
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
    );
  }
}
