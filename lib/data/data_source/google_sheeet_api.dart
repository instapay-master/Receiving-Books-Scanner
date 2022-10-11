import 'package:gsheets/gsheets.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

class GoogleSheetApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "receiving-books",
  "private_key_id": "aeceb91cdce739e27ccc9db6f4a77515ab0c4728",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCmX1AZJKfSrMaK\nW2Q4Ry695FDAJGOx2gnPNZQwadcQ7bE5sh+aqtSoFdKtpuv7zAB6hwA5GdnnSiBG\n9TEgFiWeHDRmK3Ja46jMqEBnuLY3OmEDSJ+u7rilfDbf3SS1sk0BcMdmlI+dETzL\ndqw+kw181rbnv5WgpFrvUz+svnFPAPqJ/LUF9lUY2nIoHPBuVnRBwHV9auwk5tAu\nL3hStXA6er2KD/qfknzpIs+ViDvK2yLqJLVvgSrVnTU5HKWPQZV29I94OtoLFKFs\nNKXD2naRowOyR5YhDqwx6hFSZeg8ZZ++IhNh+l30RQ9fRRUidkIgyS2yLBTd1L6w\ntSDjkbg7AgMBAAECggEAF8GYYF65j/2Xw/3Uy6xuYjMNzMHlcmnd6LaP2HHkgchO\n/BwRIzatcura0Gz7WVMB5n0MbRrh4ILXJQqx3xEKgg8o9EXT6GKFoeOMfsMDUdOG\nMr/V/VadCxQ3ibO8IC27jS8baexgrV7evXbOlYjN7juClojmxq9xRKcwemwfJdaU\n9X+UBIwIsB2mLmmKo7PUN/qKzm273axyV/EVx42G/ZrIDoSEGqyxqbYRLZMcywyA\n/W/wdCTiwfmKVaySYq9/mhCCrq7W458SUQNoHfC8Kyn7JdoVakt6gSYx7RjCJd7g\nKBo8SbVmFCB1fx6QUihn1ZfcjvEwcu6C3hnrBnOBMQKBgQDWHfeKzIaF7QY5Y+ll\nmi6LYbbB8YaAvpndPA32qITAnHlHF0BThdi7p99kUXAls4XTgAj51NrUJ9arApX8\nYRJXbHvByyV7h+YJb/fVoFH6LDfD0qbCzHogtZecUhbIcMbuuP5C5YrQ6f69aTbU\nfkdQR9ZyniZI7Uais+6My2W0fQKBgQDG6oA6CGmzz5MNDKX44FgPEdw2uHfcnbdB\nSJejda9iqRBakHMd51BCh5OMbn0FWD3WZFaNQqKl7woZ9t7bGTuZej8dsBsSLQLF\nSPO9qfBFy7ow8Qw/DI3ZGwYoiE5E+5MlefDBxRpCiN1kTSgJlK4Ky+FT+lCM9lQQ\nlycrh1VVFwKBgB34Ic7Oo8GZFHbx8hgjhYJC0gbBXJcmlnit0DKHEdW30Q3PRlSq\ndlSFwbHT6EOOphudXyRA08RAMz7KZN3nZF7SM1xDp+Jreho2DtVa1D6U89U35dl8\nL1fmsurRXpj9mAqP4B7S7CQjrGEsmd0SM78b3vs6AZfRhkJ9ttUEHx8tAoGAJMC9\nUnutdCC9TeLxY6un+ZjWNHIfC29EpdZQ1k3vSu5r7B/WdUcBCFnehEsB5JPqUQuX\nBmCyhrBFEIkRoi/mWDRDJywbxF72rRcOmhOlJnA/Bb30Ak5Cg0O//os40vwcswb1\n2geeE38QUPEEnciP48TJ7GdKrNDytWIIRb2qoZ8CgYBIHm79kC2BSvkuVN+/1g1Y\nrlQnbORyBnluyNQYkOxNe+7GjRgQkpwLbgq5dscdaFIHgbem9jGJA9RIu4ODMfT6\nGTf5m1bPLDoKJHyEoY1ZsKG107tooUD9bOTjmse3Mmg6VKrzBPtFP3GGX6qcaDCl\ndWJMvN37jTj/L65jJVLD6w==\n-----END PRIVATE KEY-----\n",
  "client_email": "receivingbooks@receiving-books.iam.gserviceaccount.com",
  "client_id": "116796128582114002943",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/receivingbooks%40receiving-books.iam.gserviceaccount.com"
}
''';

  final _gsheet = GSheets(_credentials);
  Worksheet? _bookSheet;

  Future<void> init(String spreadsheetId, String title) async {
    try {
      final spreadsheet = await _gsheet.spreadsheet(spreadsheetId);
      _bookSheet = await _getWorkSheet(spreadsheet, title: title);

      _bookSheet!.values.insertRow(1, ['ISBN','Timestamp']);

    } catch (e) {
      print('init error $e');
    }
  }

  Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  Future<void> insert(List<Map<String, dynamic>> rowList) async {
    if (_bookSheet == null) return;

    await _bookSheet!.values.map.appendRows(rowList);
  }

  // Future<List<ReceivingStatusData>> getBookData() async {
  //   if (_userSheet == null) return <ReceivingStatusData>[];
  //   final book = await _userSheet!.values.map.allRows();
  //   final List<ReceivingStatusData> data = (book == null)
  //       ? <ReceivingStatusData>[]
  //       : book.map(ReceivingStatusData.fromJson).toList();
  //   print(data);
  //   var format = DateFormat.yMd();
  //
  //   for (var element in data) {
  //     var epoch = DateTime(1899, 12, 30);
  //     epoch = epoch.add(Duration(days: int.parse(element.date)));
  //     element = element.copyWith(
  //       date: format.format(epoch),
  //     );
  //   }
  //   return data;
  // }

  Future<List<ReceivingStatusData>> getByIsbn(String isbn) async {
    if (_bookSheet == null) return [];

    List<ReceivingStatusData> resultList = [];

    final List<Cell> foundValues = await _bookSheet!.cells.findByValue(isbn);
    for (var element in foundValues) {
      final res = await _bookSheet!.values.map.row(element.row);
      var data = ReceivingStatusData.fromJson(res);

      // var format = DateFormat.yMd();
      // var epoch = DateTime(1899, 12, 30);
      // epoch = epoch.add(Duration(days: int.parse(data.date)));
      data = data.copyWith(
        row: element.row,
        //date: format.format(epoch),
      );

      resultList.add(data);
    }
    return resultList;
  }

  Future<bool> updateBookData(
      int row, Map<String, dynamic> receivingStatusData) async {
    if (_bookSheet == null) return false;

    return _bookSheet!.values.map.insertRow(row, receivingStatusData);
  }
}
