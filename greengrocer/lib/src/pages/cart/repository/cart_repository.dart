import 'package:greengrocer/src/constants/endpoints.dart';
import 'package:greengrocer/src/enums/http_method_enum.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/cart/result/cart_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token,
    required String userId,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getCartItems,
        method: HttpMethodEnum.post,
        headers: {'X-Parse-Session-Token': token},
        body: {'user': userId});

    if (result['result'] != null) {
      List<CartItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();

      return CartResult<List<CartItemModel>>.success(data);
    } else {
      // Retornar mensagem
      return CartResult.error('Erro ao recuperar os itens do carrinho.');
    }
  }

  Future<CartResult<String>> addItemToCart({
    required String userId,
    required String token,
    required String productId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.addItemToCart,
        method: HttpMethodEnum.post,
        body: {
          'user': userId,
          'quantity': quantity,
          'productId': productId,
        },
        headers: {
          'X-Parse-Session-Token': token
        });

    if (result['result'] != null) {
      // Adicionar
      return CartResult.success(result['result']['id']);
    } else {
      return CartResult.error('Erro ao adicionar produto ao Carrinho.');
    }
  }

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changeItemQuantity,
        method: HttpMethodEnum.post,
        body: {
          'cartItemId': cartItemId,
          'quantity': quantity
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

    return result.isEmpty;
  }

  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.checkout,
      method: HttpMethodEnum.post,
      body: {
        'total': total,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if(result['result'] != null){

      final order = OrderModel.fromJson(result['result']);

      return CartResult<OrderModel>.success(order);

    } else {

      return CartResult.error('Não foi possível realizar o Pedido.');

    }
  }
}
