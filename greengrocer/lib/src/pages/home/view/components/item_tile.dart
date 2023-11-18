import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/constants/page_routes.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/services/util_services.dart';

class ItemTile extends StatefulWidget {
  const ItemTile({super.key, required this.item});

  final ItemModel item;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {

  UtilServices utilsServices = UtilServices();

  final cartController = Get.find<CartController>();

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Color iconColor = CustomColors.customSwatchColor;

  Future<void> switchIcon() async {
    setState(() {
      tileIcon = Icons.check;
      iconColor = Colors.green.shade800;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

     if (context.mounted) {
      setState(() {
        tileIcon = Icons.add_shopping_cart_outlined;
        iconColor = CustomColors.customSwatchColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Conteúdo
        GestureDetector(
          onTap: () {
            Get.toNamed(PageRoutes.productRoute, arguments: widget.item);
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagem
                  Expanded(
                      child: Hero(
                    tag: widget.item.imgUrl,
                    child: Image.network(widget.item.imgUrl),
                  )),

                  // Nome
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  // Preço - Unidade
                  Row(
                    children: [
                      Text(
                        utilsServices.priceToCurrency(widget.item.price),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.customSwatchColor),
                      ),
                      Text(
                        '/${widget.item.unit}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Botão de Add ao Carrinho
        Positioned(
          top: 6,
          right: 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15), topRight: Radius.circular(20)),
            child: Material(
              child: InkWell(
                onTap: () {
                  cartController.addItemToCart(item: widget.item);

                  switchIcon();
                },
                child: Ink(
                  height: 40,
                  width: 35,
                  decoration: BoxDecoration(color: iconColor),
                  child: Icon(
                    tileIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
