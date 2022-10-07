import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

abstract class GoogleSheetApiRepository {
  Future<void> init(String spreadsheetId, String title);

  Future<List<ReceivingStatusData>> getByIsbn(String isbn);

  Future<bool> updateBookData(int row, Map<String, dynamic> receivingStatusData);
}
