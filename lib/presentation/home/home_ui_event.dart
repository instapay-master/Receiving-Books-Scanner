import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_event.freezed.dart';

@freezed
class HomeUiEvent with _$HomeUiEvent {
  const factory HomeUiEvent.showSnackBar(String message) = ShowSnackBar;
}
