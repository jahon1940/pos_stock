import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/constants/network.dart';

part 'category_dto.freezed.dart';

part 'category_dto.g.dart';

@freezed
class CategoryDto with _$CategoryDto {
  factory CategoryDto({
    required int id,
    @Default('') String name,
    @Default('') String image,
    String? cid,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  const CategoryDto._();

  String get imageLink => NetworkConstants.baseUrl + image;
}
