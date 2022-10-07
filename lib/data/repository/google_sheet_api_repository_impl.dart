
import 'package:receiving_books_scanner/data/data_source/google_sheeet_api.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';
import 'package:receiving_books_scanner/domain/repository/google_sheet_api_repository.dart';

class GoogleSheetApiRepositoryImpl implements GoogleSheetApiRepository {
  final dataSource = GoogleSheetApi();

  GoogleSheetApiRepositoryImpl({
    required String spreadsheetId,
    required String title,
  }) {
    init(spreadsheetId, title);
  }

  @override
  Future<void> init(String spreadsheetId, String title) async {
    await dataSource.init(spreadsheetId, title);
  }

  @override
  Future<List<ReceivingStatusData>> getByIsbn(String isbn) async {
    return await dataSource.getByIsbn(isbn);
  }

  @override
  Future<bool> updateBookData(
      int row, Map<String, dynamic> receivingStatusData) async {
    return await dataSource.updateBookData(row, receivingStatusData);
  }
}
