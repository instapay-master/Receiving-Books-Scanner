import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'receiving_status_data.freezed.dart';

part 'receiving_status_data.g.dart';

@freezed
class ReceivingStatusData with _$ReceivingStatusData {
  factory ReceivingStatusData({
    @Default(0) int row,
    @JsonKey(name: '수취인명') @Default('') String userName,
    @JsonKey(name: '연락처') @Default('') String phone,
    @JsonKey(name: '우편번호') @Default('') String postCode,
    @JsonKey(name: '주소') @Default('') String address,
    @JsonKey(name: '수량') @Default('0') String count,
    @JsonKey(name: '품목명') @Default('') String title,
    @JsonKey(name: '운임Type') @Default('') String type,
    @JsonKey(name: '지불조건') @Default('') String condition,
    @JsonKey(name: '출고번호') @Default('') String releaseNumber,
    @JsonKey(name: '특기사항') @Default('') String issue,
    @JsonKey(name: '출판사') @Default('') String publisher,
    @JsonKey(name: '주문번호') @Default('') String orderNumber,
    @JsonKey(name: 'ISBN') @Default('') String isbn,
    @JsonKey(name: '주문일자') @Default('') String date,
    @JsonKey(name: '합포장') @Default('0') String sumPacking,
    @JsonKey(name: '재고') @Default('0') String stock,
    @JsonKey(name: '입고') @Default('') String receiving,
  }) = _ReceivingStatusData;

  factory ReceivingStatusData.fromJson(Map<String, dynamic> json) =>
      _$ReceivingStatusDataFromJson(json);
}
