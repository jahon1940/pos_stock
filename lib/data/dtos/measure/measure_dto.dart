import 'package:freezed_annotation/freezed_annotation.dart';

part 'measure_dto.freezed.dart';

part 'measure_dto.g.dart';

@freezed
class MeasureDto with _$MeasureDto {
  factory MeasureDto({
    required int id,
    String? name,
    String? cid,
  }) = _MeasureDto;

  factory MeasureDto.fromJson(Map<String, dynamic> json) => _$MeasureDtoFromJson(json);
}
