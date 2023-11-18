import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class UtilServices {

  final storage = const FlutterSecureStorage();

  // Salvar dados localmente de forma segura
  Future<void> saveLocalData({required String key, required String data}) async 
  {
    await storage.write(key: key, value: data);
  }

  Uint8List decodeBase64Image (String value){

    String base64String = value.split(',').last;

    return base64.decode(base64String);
  }

  // Consultar dados gravados localmente
  Future<String?> getLocalData({required String key}) async
  {
    return await storage.read(key: key);
  }

  // Excluir algum dado gravado localmente
  Future<void> removeLocalData({required String key}) async 
  {
    await storage.delete(key: key);
  }


  String priceToCurrency(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return numberFormat.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();

    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();

    return dateFormat.format(dateTime.toLocal());
  }

  void showToast({required String message, required AlertTypeEnum type}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: getToastColor(type: type),
        textColor: type == AlertTypeEnum.light ? Colors.black : Colors.white,
        fontSize: 15);
  }

  Color getToastColor({required AlertTypeEnum type}) {
    switch (type) {
      case AlertTypeEnum.primary:
        return const Color(0xff3B71CA);
      case AlertTypeEnum.secondary:
        return const Color(0xff9FA6B2);
      case AlertTypeEnum.success:
        return const Color(0xff14A44D);
      case AlertTypeEnum.danger:
        return const Color(0xffDC4C64);
      case AlertTypeEnum.warning:
        return const Color(0xffE4A11B);
      case AlertTypeEnum.info:
        return const Color(0xff54B4D3);
      case AlertTypeEnum.light:
        return const Color(0xffFBFBFB);
      case AlertTypeEnum.dark:
        return const Color(0xff332D2D);
      default:
        return const Color(0xff14A44D);
    }
  }
}
