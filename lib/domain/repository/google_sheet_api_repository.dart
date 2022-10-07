import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

abstract class GoogleSheetApiRepository {
  Future<void> init(String spreadsheetId, String title);

  Future<void> insertRowIsbn(List<Map<String, dynamic>> rowList);
}
