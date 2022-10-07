import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';
import 'package:receiving_books_scanner/domain/repository/google_sheet_api_repository.dart';

class GetByIsbnUseCase {
  final GoogleSheetApiRepository repository;

  GetByIsbnUseCase(this.repository);

  Future<List<ReceivingStatusData>> call(String isbn) async {
    return await repository.getByIsbn(isbn);
  }
}
