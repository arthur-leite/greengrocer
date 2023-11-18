import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/services/util_services.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;
  final UtilServices utilServices = UtilServices();

  PaymentDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                // QR Code
                Image.memory(
                  utilServices.decodeBase64Image(order.qrCodeImage),
                  height: 200,
                  width: 200,
                ),

                // Vencimento
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Vencimento: ${utilServices.formatDateTime(order.overdueDateTime)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                // Total
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Total: ${utilServices.priceToCurrency(order.total)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Botão Copia e Cola
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      FlutterClipboard.copy(order.copyAndPaste);
                      utilServices.showToast(message: 'Código Copiado!', type: AlertTypeEnum.success);
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 15,
                    ),
                    label: const Text(
                      'Copiar Código Pix',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ))
              ],
            ),
          ),

          // Botão de Fechar o Dialog
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
