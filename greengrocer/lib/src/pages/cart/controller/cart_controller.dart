import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/cart/repository/cart_repository.dart';
import 'package:greengrocer/src/pages/cart/result/cart_result.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/services/util_services.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilServices = UtilServices();

  List<CartItemModel> cartItems = [];

  bool isCheckoutLoading = false;

  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  double getCartTotalPrice() {
    double total = 0;

    for (final item in cartItems) {
      total += item.totalPrice();
    }

    return total;
  }

  int getCartTotalItems() {
    return cartItems.isEmpty
        ? 0
        : cartItems.map((e) => e.quantity).reduce((a, b) => a + b);
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    final result = await cartRepository.changeItemQuantity(
      token: authController.user.token!,
      cartItemId: item.id,
      quantity: quantity,
    );

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }

      update();
    } else {
      utilServices.showToast(
          message: 'Erro ao alterar a quantidade.', type: AlertTypeEnum.danger);
    }

    return result;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    result.when(
      success: (data) {
        cartItems = data;
        update();

        print(data);
      },
      error: (message) {
        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);

    // Já existe no Carrinho
    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];

      await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
    }
    // Não existe no carrinho
    else {
      final CartResult<String> result = await cartRepository.addItemToCart(
        userId: authController.user.id!,
        token: authController.user.token!,
        productId: item.id,
        quantity: quantity,
      );

      result.when(success: (cartItemId) {
        cartItems.add(CartItemModel(
          id: cartItemId,
          item: item,
          quantity: quantity,
        ));
      }, error: (message) {
        utilServices.showToast(
          message: message,
          type: AlertTypeEnum.danger,
        );
      });
    }

    update();
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future checkoutCart() async {
    setCheckoutLoading(true);

    CartResult<OrderModel> result = await cartRepository.checkoutCart(
      token: authController.user.token!,
      total: getCartTotalPrice(),
    );

    setCheckoutLoading(false);

    result.when(
      success: (order) {
        cartItems.clear();
        update();

        showDialog(
          context: Get.context!,
          builder: (_) {
            return PaymentDialog(
              order: order,
            );
          },
        );
      },
      error: (message) {
        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );
  }

  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }
}
