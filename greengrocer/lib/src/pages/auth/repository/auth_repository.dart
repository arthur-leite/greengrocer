import 'package:greengrocer/src/constants/endpoints.dart';
import 'package:greengrocer/src/enums/http_method_enum.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/result/auth_errors.dart' as auth_errors;
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(auth_errors.authErrorsString(result['error']));
    }
  }

  Future<AuthResult> signUp(UserModel user) async {

      final result = await _httpManager.restRequest(
        url: Endpoints.signup,
        method: HttpMethodEnum.post,
        body: user.toJson(),
      );

      return handleUserOrError(result);
  }

  // SignIn
  Future<AuthResult> signIn(
      {required String email, required String password}) async {

      final result = await _httpManager.restRequest(
        url: Endpoints.signin,
        method: HttpMethodEnum.post,
        body: {"email": email, "password": password},
      );

      return handleUserOrError(result);
  }

  // Validar Token
  Future<AuthResult> validateToken(String token) async {
   
    final result = await _httpManager.restRequest(
          url: Endpoints.validateToken,
          method: HttpMethodEnum.post,
          headers: {
            'X-Parse-Session-Token': token,
          });

    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {

    await _httpManager.restRequest(
        url: Endpoints.resetPassword,
        method: HttpMethodEnum.post,
        body: {'email': email});    
        
  }

  Future<bool> changePassword({
    required String token,
    required String email,
    required String password,
    required String newPassword,
  }) async {

    final result = await _httpManager.restRequest(
        url: Endpoints.changePassword,
        method: HttpMethodEnum.post,
        body: {
          'email': email,
          'currentPassword': password,
          'newPassword': newPassword,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

     return result['error'] == null;   
  }
}
