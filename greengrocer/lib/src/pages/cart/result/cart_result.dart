import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_result.freezed.dart';

// Contém os resultados possíveis para as chamadas
@freezed
class CartResult<T> with _$CartResult<T> {

  factory CartResult.success(T data) = Success;
  
  factory CartResult.error(String message) = Error;
}