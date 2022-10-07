import 'package:receiving_books_scanner/domain/repository/google_sheet_api_repository.dart';

class InsertIsbnUseCase {
  final GoogleSheetApiRepository repository;

  InsertIsbnUseCase(this.repository);

  Future<void> call(List<String> isbn) async {
    List<Map<String, dynamic>> rowList = [];
    for (int i = 0; i < isbn.length; i++) {
      final Map<String, dynamic> temp = {
        "isbn": isbn[i],
      };
      rowList.add(temp);
    }
    await repository.insertRowIsbn(rowList);
  }
}
