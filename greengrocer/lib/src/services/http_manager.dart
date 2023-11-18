import 'package:dio/dio.dart';
import 'package:greengrocer/src/enums/http_method_enum.dart';

class HttpManager {

    Future<Map> restRequest({
      required String url,
      required HttpMethodEnum method,
      Map? headers,
      Map? body,
    }
    ) async {

    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({

        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': 'wK7GcEjr2V4br5q5mlR1kybQ5dvxMFDX0qtE1d6Y',
        'X-Parse-REST-API-Key': '2kahi62fkWePLWAwC7k8aMrtQkobogcgkruMxbeB',

      });

    Dio dio = Dio();

    try {

      Response response = await dio.request(url,
          options: Options(
            method: method.name,
            headers: defaultHeaders,
          ),
          data: body);

      // Retorno do Resultado do Server
      return response.data;

    } on DioException catch (ex) {

      // Retorno de Exceções do Dio Request
      return ex.response?.data ?? { };

    } catch (error){

      // Retorno vazio para demais erros
      return {};

    }
  }
}
