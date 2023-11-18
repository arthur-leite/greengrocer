import 'package:greengrocer/src/constants/endpoints.dart';
import 'package:greengrocer/src/enums/http_method_enum.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/home/result/home_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  // Listar Categorias para a Home
  Future<HomeResult<CategoryModel>> getAllCategories() async {

    final result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethodEnum.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult<CategoryModel>.success(data);
    } 
    else 
    {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao recuperar as categorias.');
    }

  }

  // Listar os Produtos para a Home
  Future<HomeResult<ItemModel>> getProducts(Map<String, dynamic> body) async {

    final result = await _httpManager.restRequest(
        url: Endpoints.getProducts, 
        method: HttpMethodEnum.post, 
        body: body
    );

    if(result['result'] != null) {

      List<ItemModel> data = (List<Map<String, dynamic>>.from(result['result']))
              .map(ItemModel.fromJson)
              .toList();

      return HomeResult<ItemModel>.success(data);
    }
    else
    {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao recuperar os produtos.');
    }
  }
}
