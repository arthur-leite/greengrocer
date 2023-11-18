import 'package:get/get.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/pages/home/result/home_result.dart';
import 'package:greengrocer/src/services/util_services.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final homeRepository = HomeRepository();
  final utilServices = UtilServices();

  bool isCategoryLoading = false;

  bool isProductLoading = true;

  List<CategoryModel> allCategories = [];

  CategoryModel? currentCategory;

  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  // Campo de Pesquisa de Produtos
  RxString searchTitle = ''.obs;

  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;

    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();

    // Fica observando a variável e executa uma ação callback quando há uma alteração
    debounce(
      searchTitle,
      (callback) {
        filterByTitle();
      },
      // Tempo de espera para o usuário digitar (se não faria diversas requisições)
      time: const Duration(milliseconds: 600),
    );

    getAllCategories();
  }

  // Obtém todas categorias
  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);

        if (allCategories.isEmpty) return;

        selectCategory(allCategories.first);
      },
      error: (message) {
        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );
  }

  // Obtém os produtos
  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage
    };

    if(searchTitle.value.isNotEmpty){
      
      body['title'] = searchTitle.value;

      // Remove do filtro da API a categoria específica, para retornar todos
      if(currentCategory!.id == 'todos'){
        body.remove('categoryId');
      }
    }

    HomeResult<ItemModel> result = await homeRepository.getProducts(body);

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );
  }

  // Carrega mais produtos ao rolar a tela
  void loadMoreProducts() {
    currentCategory!.pagination++;

    getAllProducts(canLoad: false);
  }

  void filterByTitle() {
    // Apagar todos os produtos das categorias
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    // Caso tenha uma pesquisa por título cria a Categoria 'Todos' e 
    // exibe produtos independentemente da categoria
    if(searchTitle.value.isNotEmpty){

      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == 'todos');

      if(c == null){
        // Criar uma nova categoria com Todos
        final alProductsCategory = CategoryModel(
          title: 'Todos',
          id: 'todos',
          items: [],
          pagination: 0,
        );

        allCategories.insert(0, alProductsCategory);
      
      } else {
        c.items.clear();
        c.pagination = 0;
      }

    }
    // Remove a categoria 'Todos' caso não tenha Pesquisa por Título
    else { 
      allCategories.removeAt(0);
    }

    currentCategory = allCategories.first;

    update();

    getAllProducts();
  }

  // Gerencia o estado da variável isLoading
  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }

    update();
  }

  // Seta a categoria selecionada
  void selectCategory(CategoryModel category) {
    currentCategory = category;

    update();

    if (currentCategory!.items.isNotEmpty) return;

    getAllProducts();
  }
}
