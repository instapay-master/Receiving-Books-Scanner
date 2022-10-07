import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:receiving_books_scanner/data/repository/google_sheet_api_repository_impl.dart';
import 'package:receiving_books_scanner/domain/use_case/get_by_isbn_use_case.dart';
import 'package:receiving_books_scanner/domain/use_case/update_book_data_use_case.dart';
import 'package:receiving_books_scanner/presentation/home/home_view_model.dart';

List<SingleChildWidget> getProviders() {
  GoogleSheetApiRepositoryImpl googleSheetApiRepositoryImpl =
      GoogleSheetApiRepositoryImpl(
    spreadsheetId: '1eFy6gX2TUNCTJdmCSCUZUBep34wgihGT9eYOA0Dxbvc',
    title: 'request',
  );

  return [
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        updateBookData: UpdateBookDataUseCase(googleSheetApiRepositoryImpl),
        getByIsbn: GetByIsbnUseCase(googleSheetApiRepositoryImpl),
      ),
    ),
  ];
}
