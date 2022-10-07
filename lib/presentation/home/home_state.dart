import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receiving_books_scanner/domain/model/receiving_status_data/receiving_status_data.dart';

part 'home_state.freezed.dart';

part 'home_state.g.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool isLoading,
    @Default('') String isbn,
    @Default([]) List<ReceivingStatusData> bookStatusList,
    @Default({}) Set<ReceivingStatusData> receivingDoneSet,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
