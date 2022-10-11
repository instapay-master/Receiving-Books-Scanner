import 'package:intl/intl.dart';
import 'package:receiving_books_scanner/domain/repository/google_sheet_api_repository.dart';

class InsertIsbnUseCase {
  final GoogleSheetApiRepository repository;

  InsertIsbnUseCase(this.repository);

  Future<void> call(List<String> isbn) async {
    var format = DateFormat('yyyy.MM.dd hh:mm:ss');
    String formatString = format.format(DateTime.now());
    List<Map<String, dynamic>> rowList = [];
    for (int i = 0; i < isbn.length; i++) {
      final Map<String, dynamic> temp = {
        "ISBN": isbn[i],
        "Timestamp": formatString,
      };
      rowList.add(temp);
    }
    await repository.insertRowIsbn(rowList);
  }
}
