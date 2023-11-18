import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/services/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),

                // Formulário
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          icon: Icons.email,
                          label: 'E-mail',
                          onSaved: (value) {
                            authController.user.email = value;
                          },
                          textInputType: TextInputType.emailAddress,
                          validator: emailValidator,
                        ),
                        CustomTextField(
                          icon: Icons.lock,
                          label: 'Senha',
                          onSaved: (value) {
                            authController.user.password = value;
                          },
                          isSecret: true,
                          validator: passwordValidator,
                        ),
                        CustomTextField(
                          icon: Icons.person,
                          label: 'Nome',
                          onSaved: (value) {
                            authController.user.name = value;
                          },
                          validator: nameValidator,
                        ),
                        CustomTextField(
                          icon: Icons.phone,
                          label: 'Celular',
                          onSaved: (value) {
                            authController.user.phone = value;
                          },
                          textInputType: TextInputType.phone,
                          inputFormatters: [phoneFormatter],
                          validator: phoneValidator,
                        ),
                        CustomTextField(
                          icon: Icons.file_copy,
                          label: 'CPF',
                          onSaved: (value) {
                            authController.user.cpf = value;
                          },
                          textInputType: TextInputType.number,
                          inputFormatters: [cpfFormatter],
                          validator: cpfValidator,
                        ),
                        SizedBox(
                          height: 50,
                          child: Obx(
                            () {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: authController.isLoading.value
                                ? null
                                : () {      

                                  FocusScope.of(context).unfocus();

                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    authController.signUp();
                                  }
                                },
                                child: authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Cadastrar',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Já possuo uma Conta',
                              style: TextStyle(
                                color: CustomColors.customContrastColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
              Positioned(
                left: 10,
                top: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
