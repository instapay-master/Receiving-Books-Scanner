import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

part 'home_events.freezed.dart';

@freezed
class HomeEvents with _$HomeEvents {
  const factory HomeEvents.onUpdateReceivingStatus(ReceivingStatusData statusData,bool isReceiving) = OnUpdateReceivingStatus;
  const factory HomeEvents.searchIsbn(String isbn) = SearchIsbn;
  const factory HomeEvents.resetScreen() = ResetScreen;
}
