import 'package:freezed_annotation/freezed_annotation.dart';

import 'diff.dart';

part 'generated/improve_writing_result.freezed.dart';

part 'generated/improve_writing_result.g.dart';

@freezed
class ImproveWritingResult with _$ImproveWritingResult {
  const factory ImproveWritingResult({
    @Default(Diff()) @JsonKey(name: "diff") Diff diff,
    @Default("") @JsonKey(name: "originalText") String original,
    @Default("") @JsonKey(name: "feedbackText") String feedback,
    @Default(0) @JsonKey(name: "percentageDiff") int percentage,
  }) = _ImproveWritingResult;

  factory ImproveWritingResult.fromJson(Map<String, dynamic> json) => _$ImproveWritingResultFromJson(json);
}