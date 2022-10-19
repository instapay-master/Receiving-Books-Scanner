import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_events.freezed.dart';

@freezed
class HomeEvents with _$HomeEvents {
  const factory HomeEvents.resetScreen() = ResetScreen;
  const factory HomeEvents.sendIsbnList() = SendIsbnList;
  const factory HomeEvents.deleteIsbn(int index) = DeleteIsbn;
  const factory HomeEvents.setIsbnCount(Map<String,int> count) = SetIsbnCount;
  const factory HomeEvents.changeIsbnCount(String isbn, String count) = ChangeIsbnCount;
}
