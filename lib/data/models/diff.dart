import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/diff.freezed.dart';

part 'generated/diff.g.dart';

@freezed
class Diff with _$Diff {
  const factory Diff({
    @Default("") @JsonKey(name: "newText1") String newText1,
    @Default("") @JsonKey(name: "newText2") String newText2,
    @Default("") @JsonKey(name: "stepByStepAdvice") String stepByStepAdvice,
  }) = _Diff;

  factory Diff.fromJson(Map<String, dynamic> json) => _$DiffFromJson(json);
}