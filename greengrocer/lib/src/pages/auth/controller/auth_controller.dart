import 'package:get/get.dart';
import 'package:greengrocer/src/constants/page_routes.dart';
import 'package:greengrocer/src/constants/storage_keys.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_repository.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/services/util_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();

  final utilServices = UtilServices();

  UserModel user = UserModel();

  @override
  void onInit(){
    super.onInit();

    validadeToken();
  }

  // Cadastro de Usuário
  Future<void> signUp() async {

    isLoading.value = true;

    AuthResult result = await authRepository.signUp(user);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;

        utilServices.saveLocalData(key: StorageKeys.token, data: user.token!);

        Get.offAllNamed(PageRoutes.baseRoute);    
      },
      error: (message) {
        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );

  }

  // Login do Usuário
  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;

        utilServices.saveLocalData(key: StorageKeys.token, data: user.token!);

        Get.offAllNamed(PageRoutes.baseRoute);     
      },
      error: (message) {

        utilServices.showToast(message: message, type: AlertTypeEnum.danger);
      },
    );
  }

   // Validação do Token do Usuário
  Future<void> validadeToken() async{

    // Recuperar o token obtido na primeira autenticação
    String? token = await utilServices.getLocalData(key: StorageKeys.token);

    if(token == null){
       Get.offAllNamed(PageRoutes.signinRoute);    
       return;
    }

    AuthResult result = await authRepository.validateToken(token);

    result.when(
      success: (user) {
        this.user = user;

        Get.offAllNamed(PageRoutes.baseRoute);     
      },
      error: (message) {

        signOut();

      },
    );
  }

  // Logout do Usuário
  Future<void> signOut() async{
    // Zerar o usuário
    user = UserModel();

    // Remover o token do localstorage
    await utilServices.removeLocalData(key: StorageKeys.token);

    // Redirecionar para a tela de login
    Get.offAllNamed(PageRoutes.signinRoute);    
  }

  // Resetar Senha
  Future<void> resetPassword(String email) async{

    await authRepository.resetPassword(email);
    
  }

  // Trocar Senha
  Future<void> changePassword({
    required String password,
    required String newPassword,
  }) async {

    isLoading.value = true;

   final result = await authRepository.changePassword(
      token: user.token!,
      email: user.email!,
      password: password,
      newPassword: newPassword,
    );

    isLoading.value = false;

    if(result){
      // Mensagem
      utilServices.showToast(message: 'Senha atualizada com Sucesso.', type: AlertTypeEnum.success);

      // Logout
      signOut();
      
    } else{

      utilServices.showToast(message: 'Senha atual Incorreta', type: AlertTypeEnum.danger);

    }

  }
}
