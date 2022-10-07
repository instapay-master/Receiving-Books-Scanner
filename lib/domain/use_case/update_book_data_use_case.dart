import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';
import 'package:receiving_books_scanner/domain/repository/google_sheet_api_repository.dart';

class UpdateBookDataUseCase {
  final GoogleSheetApiRepository repository;

  UpdateBookDataUseCase(this.repository);

  Future<bool> call(
      ReceivingStatusData receivingStatusData, bool isReceiving) async {
    String receivingCheck = isReceiving ? 't' : '';

    return await repository
        .updateBookData(receivingStatusData.row, {"입고": receivingCheck});
  }
}
