import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';
import 'package:receiving_books_scanner/domain/use_case/get_by_isbn_use_case.dart';
import 'package:receiving_books_scanner/domain/use_case/update_book_data_use_case.dart';
import 'package:receiving_books_scanner/presentation/home/home_events.dart';
import 'package:receiving_books_scanner/presentation/home/home_state.dart';
import 'package:receiving_books_scanner/presentation/home/home_ui_event.dart';

class HomeViewModel with ChangeNotifier {
  final GetByIsbnUseCase getByIsbn;
  final UpdateBookDataUseCase updateBookData;

  HomeViewModel({
    required this.getByIsbn,
    required this.updateBookData,
  });

  HomeState _state = HomeState();

  HomeState get state => _state;

  final _eventController = StreamController<HomeUiEvent>.broadcast();

  Stream<HomeUiEvent> get eventStream => _eventController.stream;

  void onEvent(HomeEvents event) {
    event.when(
      onUpdateReceivingStatus: updateReceivingStatus,
      searchIsbn: searchIsbn,
      resetScreen: dataReset,
    );
  }

  Future<void> searchIsbn(String isbn) async {
    _state = state.copyWith(
      isLoading: true,
      isbn: isbn,
    );
    notifyListeners();

    final result = await getByIsbn(isbn);
    Set<ReceivingStatusData> tempSet = {};
    for (int i = 0; i < result.length; i++) {
      if (result[i].receiving == 't') {
        tempSet.add(result[i]);
      }
    }

    _state = state.copyWith(
      bookStatusList: result,
      isLoading: false,
      receivingDoneSet: tempSet,
    );
    notifyListeners();
  }

  Future<void> updateReceivingStatus(
      ReceivingStatusData statusData, bool isReceiving) async {
    final result = await updateBookData(statusData, isReceiving);
    Set<ReceivingStatusData> temp = Set.from(state.receivingDoneSet);

    if (result) {
      if (isReceiving) {
        temp.add(statusData);
        _state = state.copyWith(
          receivingDoneSet: temp,
        );
        _eventController.add(const HomeUiEvent.showSnackBar('입고 처리 완료'));
      } else {
        temp.remove(statusData);
        _state = state.copyWith(
          receivingDoneSet: temp,
        );
        _eventController.add(const HomeUiEvent.showSnackBar('입고 처리 해제 완료'));
      }
    } else {
      if (isReceiving) {
        _eventController.add(const HomeUiEvent.showSnackBar('입고 처리가 실패 했습니다.'));
      } else {
        _eventController
            .add(const HomeUiEvent.showSnackBar('입고 처리 해제가 실패 했습니다.'));
      }
    }

    notifyListeners();
  }

  void dataReset() {
    _state = state.copyWith(
      isbn: '',
      bookStatusList: [],
    );
    notifyListeners();
  }
}
