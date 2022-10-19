import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'qr_scan_state.freezed.dart';
part 'qr_scan_state.g.dart';

@freezed
class QrScanState with _$QrScanState {
  factory QrScanState({
    @Default({}) Set<String> isbnListSet,
    @Default({}) Map<String,int> count,
  }) = _QrScanState;
  factory QrScanState.fromJson(Map<String, dynamic> json) => _$QrScanStateFromJson(json);
}