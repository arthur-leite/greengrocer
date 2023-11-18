import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/pages/orders/components/order_status_widget.dart';
import 'package:greengrocer/src/services/util_services.dart';

import '../controller/order_controller.dart';

class OrderTile extends StatelessWidget {
  OrderTile({
    super.key,
    required this.order,
  });

  final OrderModel order;

  final UtilServices utilServices = UtilServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: GetBuilder<OrderController>(
            init: OrderController(order),
            global: false,
            builder: (controller) {
              return ExpansionTile(
                onExpansionChanged: (value) {
                  if (value && order.items.isEmpty) {
                    controller.getOrderItems();
                  }
                },
                // initiallyExpanded: order.status == 'pending_payment',
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido ${order.id}',
                    ),
                    Text(
                      utilServices.formatDateTime(order.createdDateTime!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: controller.isLoading
                    ? [
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: const CircularProgressIndicator(),
                        )
                      ]
                    : [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              // Lista de produtos
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 150,
                                  child: ListView(
                                    children: controller.order.items.map((orderItem) {
                                      return _OrderItemWidget(
                                        utilServices: utilServices,
                                        orderItem: orderItem,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                              // Divisão
                              VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 2,
                                width: 8,
                              ),

                              // Status do Pedido
                              Expanded(
                                  flex: 2,
                                  child: OrderStatusWidget(
                                    status: order.status,
                                    isOverdue: order.overdueDateTime
                                        .isBefore(DateTime.now()),
                                  )),
                            ],
                          ),
                        ),

                        // Total
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text.rich(
                            TextSpan(
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Total ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: utilServices
                                        .priceToCurrency(order.total),
                                  ),
                                ]),
                          ),
                        ),

                        // Botão de Pagamento Pix
                        Visibility(
                          visible: order.status == 'pending_payment' && !order.isOverDue,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return PaymentDialog(order: order);
                                },
                              );
                            },
                            icon: const Icon(Icons.pix),
                            label: const Text('Ver QR Code Pix'),
                          ),

                          //replacement: possível usar outro widget caso não seja pendente de pagamento
                        ),
                      ],
              );
            },
          )),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({required this.utilServices, required this.orderItem});

  final UtilServices utilServices;
  final CartItemModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [

          // Imagem
          Image.network(
            orderItem.item.imgUrl,
            height: 30,
            width: 30,
          ),

          // Quantidade
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          // Nome
          Expanded(
            child: Text(
              orderItem.item.itemName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Total
          Text(
            utilServices.priceToCurrency(orderItem.totalPrice()),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
