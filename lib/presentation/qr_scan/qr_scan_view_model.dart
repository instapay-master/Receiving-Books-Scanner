import 'package:flutter/cupertino.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_event.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_state.dart';

class QrScanViewModel with ChangeNotifier {
  QrScanState _state = QrScanState();

  QrScanState get state => _state;

  void onEvent(QrScanEvent event) {
    event.when(
      addIsbn: _addIsbn,
      deleteIsbn: _deleteIsbn,
      changeIsbnCount: _changeIsbnCount,
    );
  }

  void _addIsbn(String isbn) {
    Set<String> temp = Set.from(state.isbnListSet);
    temp.add(isbn);

    Map<String, int> tempCount = Map.from(_state.count);

    if (tempCount.containsKey(isbn)) {
      tempCount[isbn] = tempCount[isbn]! + 1;
    } else {
      tempCount[isbn] = 1;
    }

    _state = state.copyWith(
      isbnListSet: temp,
      count: tempCount,
    );
    notifyListeners();
  }

  void _deleteIsbn(int index) {
    Set<String> temp = Set.from(state.isbnListSet);
    List<String> isbnList = temp.toList();
    isbnList.removeAt(index);
    _state = state.copyWith(
      isbnListSet: isbnList.toSet(),
    );
    notifyListeners();
  }

  void _changeIsbnCount(String isbn, String count) {
    Map<String, int> tempCount = Map.from(_state.count);

    tempCount[isbn] = int.parse(count);

    _state = state.copyWith(
      count: tempCount,
    );
    notifyListeners();
  }
}
