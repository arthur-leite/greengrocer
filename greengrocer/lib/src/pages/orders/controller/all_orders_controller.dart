import 'package:get/get.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/pages/orders/result/orders_result.dart';
import 'package:greengrocer/src/services/util_services.dart';

class AllOrdersController extends GetxController {

  List<OrderModel> allOrders = [];

  final ordersRepository = OrdersRepository();

  final authController = Get.find<AuthController>();

  final utilServices = UtilServices();

    // Pedidos filtrados
  List<OrderModel> allFilteredOrders = [];

  @override
  void onInit() {
    super.onInit();

    getAllOrders();
  }

  Future<void> getAllOrders() async {
    
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(success: (orders) {

      allOrders = orders..sort(((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!)));
      
      update();

    }, error: (message) {

      utilServices.showToast(message: message, type: AlertTypeEnum.danger);

    });
  }

  void filterOrders(String status) {
 
    // Aqui removemos todos os itens da listagem de itens filtrados
    allFilteredOrders.clear();
 
    // Aqui adicionamos todos os pedidos sem filtragem 
    allFilteredOrders.addAll(allOrders);
 
    // Abaixo iremos adicionar a filtragem
    
    // Caso o status seja igual a 'all' (Que não existe no backend, mas sim apenas que apresentemos todos os pedidos) retornamos a listagem de itens filtrados, mas sem nenhuma filtragem
    if (status == 'all') {
      allFilteredOrders;
    } else {
 
      // Caso contrário iremos remover os pedidos cuja o status seja diferente do que informarmos pelo parâmetro
      allFilteredOrders.removeWhere((order) => order.status != status);
    }
 
    // Em seguida atualizamos o controller
    update();
  }
}
