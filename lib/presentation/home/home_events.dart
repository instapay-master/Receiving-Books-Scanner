import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

part 'home_events.freezed.dart';

@freezed
class HomeEvents with _$HomeEvents {
  const factory HomeEvents.resetScreen() = ResetScreen;
  const factory HomeEvents.setIsbnList(Set<String> isbn) = SetIsbnList;
  const factory HomeEvents.sendIsbnList() = SendIsbnList;
  const factory HomeEvents.deleteIsbn(int index) = DeleteIsbn;
}
