import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/util_services.dart';

class CartTile extends StatefulWidget {
  const CartTile({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;
  //final Function(int) updatedQuantity;

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {

  final UtilServices utilsServices = UtilServices();

  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.cartItem.item.imgUrl,
          height: 60,
          width: 60,
        ),

        // Título
        title: Text(
          widget.cartItem.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        // Total
        subtitle: Text(
          utilsServices.priceToCurrency(widget.cartItem.totalPrice()),
          style: TextStyle(
              color: CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),

        // Quantidade
        trailing: QuantityWidget(
          suffixText: widget.cartItem.item.unit,
          value: widget.cartItem.quantity,
          result: (quantity){ 
            controller.changeItemQuantity(item: widget.cartItem, quantity: quantity);
          },
          isRemovable: widget.cartItem.quantity <= 1,
        ),
      ),
    );
  }
}
