import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_event.freezed.dart';

@freezed
class QrScanEvent with _$QrScanEvent {
  const factory QrScanEvent.addIsbn(String isbn) = AddIsbn;
}
