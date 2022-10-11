import 'package:flutter/cupertino.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_event.dart';
import 'package:receiving_books_scanner/presentation/qr_scan/qr_scan_state.dart';

class QrScanViewModel with ChangeNotifier {
  QrScanState _state = QrScanState();

  QrScanState get state => _state;

  void onEvent(QrScanEvent event) {
    event.when(
      addIsbn: addIsbn,
      deleteIsbn: deleteIsbn,
    );
  }

  void addIsbn(String isbn) {
    Set<String> temp = Set.from(state.isbnListSet);
    temp.add(isbn);
    _state = state.copyWith(
      isbnListSet: temp,
    );
    notifyListeners();
  }

  void deleteIsbn(int index) {
    Set<String> temp = Set.from(state.isbnListSet);
    List<String> isbnList = temp.toList();
    isbnList.removeAt(index);
    _state = state.copyWith(
      isbnListSet: isbnList.toSet(),
    );
    notifyListeners();
  }
}
