import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:receiving_books_scanner/domain/use_case/insert_isbn_use_case.dart';
import 'package:receiving_books_scanner/presentation/home/home_events.dart';
import 'package:receiving_books_scanner/presentation/home/home_state.dart';
import 'package:receiving_books_scanner/presentation/home/home_ui_event.dart';

class HomeViewModel with ChangeNotifier {
  final InsertIsbnUseCase insertIsbn;

  HomeViewModel({
    required this.insertIsbn,
  });

  HomeState _state = HomeState();

  HomeState get state => _state;

  final _eventController = StreamController<HomeUiEvent>.broadcast();

  Stream<HomeUiEvent> get eventStream => _eventController.stream;

  void onEvent(HomeEvents event) {
    event.when(
      resetScreen: _dataReset,
      sendIsbnList: _sendIsbnList,
      deleteIsbn: _deleteIsbn,
      setIsbnCount: _setIsbnCount,
      changeIsbnCount: _changeIsbnCount,
    );
  }

  void _changeIsbnCount(String isbn, String count) {
    Map<String, int> tempCount = Map.from(_state.count);

    tempCount[isbn] = int.parse(count);

    _state = state.copyWith(
      count: tempCount,
    );
    notifyListeners();
  }

  void _setIsbnCount(Map<String, int> count) {
    _state = state.copyWith(
      count: count,
    );

    Set<String> temp = {};
    temp.addAll(count.keys);

    setIsbnList(temp);

    notifyListeners();
  }

  Future<void> _sendIsbnList() async {
    if (state.isbnList.isNotEmpty) {
      _state = state.copyWith(
        isLoading: true,
      );
      notifyListeners();

      await insertIsbn(state.count);

      _state = state.copyWith(
        isbnList: [],
        count: {},
        isLoading: false,
      );

      _eventController
          .add(const HomeUiEvent.showSnackBar('구글 시트로 ISBN을 전달했습니다.'));
      notifyListeners();
    }
  }

  void setIsbnList(Set<String> isbn) {
    List<String> temp = List.from(state.isbnList);
    temp.addAll(isbn.toList());
    temp = temp.toSet().toList();

    _state = state.copyWith(
      isbnList: temp,
    );
  }

  void _dataReset() {
    _state = state.copyWith(
      isbn: '',
      bookStatusList: [],
      isbnList: [],
    );
    notifyListeners();
  }

  void _deleteIsbn(int index) {
    List<String> isbnList = List.from(state.isbnList);
    isbnList.removeAt(index);
    _state = state.copyWith(
      isbnList: isbnList,
    );
    notifyListeners();
  }
}
