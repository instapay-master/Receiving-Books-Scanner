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
  TextEditingController textController = TextEditingController();
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
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final state = viewModel.state;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.camera_alt_outlined,
        ),
        onPressed: () async {
          final Map<String, int>? isbn = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (_) => QrScanViewModel(),
                    child: const QrScanScreen())),
          );
          if (isbn != null) {
            viewModel.onEvent(HomeEvents.setIsbnCount(isbn));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      viewModel.onEvent(const HomeEvents.sendIsbnList());
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 35,
                      color: Colors.white,
                    )),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      viewModel.onEvent(const HomeEvents.resetScreen());
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 35,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
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
                    ListView.builder(
                      itemCount: state.isbnList.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<String> data = state.isbnList;
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
                                                            HomeEvents.changeIsbnCount(
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
                                            viewModel.onEvent(
                                                HomeEvents.deleteIsbn(index));
                                          },
                                          icon: const Icon(
                                              Icons.delete_outline_sharp)),
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
                      shrinkWrap: true,
                    ),
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
