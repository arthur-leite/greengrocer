import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/enums/navigation_tab_enum.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/base/controller/navigation_controller.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/util_services.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({
    super.key,
  });

  final ItemModel item = Get.arguments;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilServices utilsServices = UtilServices();

  int cartItemQuantity = 1;

  final cartController = Get.find<CartController>();

  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          // Conteúdo
          Column(children: [
            Expanded(
              child: Hero(
                tag: widget.item.imgUrl,
                child: Image.network(widget.item.imgUrl),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600, offset: const Offset(0, 2))
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nome e Qtde
                    Row(
                      children: [
                        // Nome do Produto
                        Expanded(
                          child: Text(
                            widget.item.itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Quantidade
                        QuantityWidget(
                            suffixText: widget.item.unit,
                            value: cartItemQuantity,
                            result: (quantity) {
                              setState(() {
                                cartItemQuantity = quantity;
                              });
                            })
                      ],
                    ),

                    // Preço
                    Text(
                      utilsServices.priceToCurrency(widget.item.price),
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor),
                    ),

                    // Descrição
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.item.description,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                    ),

                    // Botão
                    SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.customSwatchColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          // Adiciona o produto
                          cartController.addItemToCart(
                            item: widget.item,
                            quantity: cartItemQuantity,
                          );

                          // Fechar a Tela
                          Get.back();

                          // Abrir o carrinho
                          navigationController
                              .navigatePageView(NavigationTabEnum.cart.index);
                        },
                        label: const Text(
                          'Adicionar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
            )),
          ]),

          Positioned(
            left: 30,
            top: 10,
            child: SafeArea(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))),
          )
        ],
      ),
    );
  }
}
