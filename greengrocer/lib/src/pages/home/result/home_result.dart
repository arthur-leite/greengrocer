import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_result.freezed.dart';

// Contém os resultados possíveis para as chamadas
@freezed
class HomeResult<T> with _$HomeResult<T> {

  factory HomeResult.success(List<T> data) = Success;

  factory HomeResult.error(String message) = Error;

}
