import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/orders/components/order_tile.dart';
import 'package:greengrocer/src/pages/orders/controller/all_orders_controller.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {

  // Status inicial o qual será utilizado para a filtragem inicial
  String statusToFilter = 'Todos';

  // Map com todos os status contendo uma tradução para o usuário e o status que será usado para filtragem mais a frente
  final Map<String, String> allStatus = <String, String>{
    'Todos': 'all',
    'Pagamento pendente': 'pending_payment',
    'Estornado': 'refunded',
    'Pago': 'paid',
    'Preparando': 'preparing_purchase',
    'Enviado': 'shipping',
    'Entregue': 'delivered',
  };

  // Controller para chamar o método de filtragem que criaremos mais a frente
  final allOrdersController = Get.find<AllOrdersController>();

  @override
  void initState() {
    super.initState();
 
    allOrdersController.filterOrders('all');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          // Dropdown de seleção de filtro de Status
          DropdownButton<String>(
            // Aqui definimos que o texto interno será branco
            style: const TextStyle(
              color: Colors.white,
            ),

            // Aqui definimos que o background será verde como sendo o tema do nosso app
            dropdownColor: Colors.green,

            // Aqui definimos que o ícone do DropDownButton será igualmente branco como o texto
            iconEnabledColor: Colors.white,

            // Aqui informaremos o valor atualmente selecionado passando a variável que criamos no passo anterior
            value: statusToFilter,
            
            items: null,
            onChanged: null
            
            /* 
            items: allStatus.keys.map((status) {
                return DropdownMenuItem(child: Text(status));
            }).toList(),            

            onChanged: (value) {
                  setState(() => statusToFilter = status);
                  allOrdersController.filterOrders(allStatus[status]!);
                },
                value: status 
            */
            ),
        ]
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) => OrderTile(order: controller.allFilteredOrders[index]),
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemCount: controller.allFilteredOrders.length,
            ),
          );
        },
      ),
    );
  }
}
