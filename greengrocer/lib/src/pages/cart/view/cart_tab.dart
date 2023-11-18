import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/pages/cart/components/cart_tile.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/services/util_services.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilServices utilsServices = UtilServices();

  final cartController = Get.find<CartController>();

  double cartTotalPrice() {
/*     double total = 0;

    for (var item in app_data.cartItems) {
      total += item.totalPrice();
    }

    return total; */
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          // Lista de Itens do Carrinho
          Expanded(child: GetBuilder<CartController>(
            builder: (controller) {
              if (controller.cartItems.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 40,
                      color: CustomColors.customSwatchColor,
                    ),
                    const Text('Não há itens no Carrinho.')
                  ],
                );
              }

              return ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (_, index) {
                    return CartTile(
                      cartItem: controller.cartItems[index],
                    );
                  });
            },
          )),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 2,
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(fontSize: 12),
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return Text(
                      utilsServices
                          .priceToCurrency(controller.getCartTotalPrice()),
                      style: TextStyle(
                          fontSize: 23,
                          color: CustomColors.customSwatchColor,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
                SizedBox(
                  height: 40,
                  child: GetBuilder<CartController>(
                    builder: (controller) {
                      return ElevatedButton(
                        onPressed: (controller.isCheckoutLoading || controller.cartItems.isEmpty)
                            ? null
                            : () async {
                                bool? result = await showOrderConfirmation();

                                if (result ?? false) {
                                  cartController.checkoutCart();
                                } else
                                {
                                  utilsServices.showToast(message: 'Pedido não confirmado.', type: AlertTypeEnum.warning);
                                } 
                                
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: controller.isCheckoutLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Concluir Pedido',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Confirmação'),
          content: const Text('Deseja realmente concluir o pedido?'),
          actions: [
            // Botão "Não"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),

            // Botão "Sim"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            )
          ],
        );
      },
    );
  }
}
