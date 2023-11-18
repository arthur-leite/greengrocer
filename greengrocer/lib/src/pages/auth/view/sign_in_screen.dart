import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/constants/page_routes.dart';
import 'package:greengrocer/src/enums/alert_type_enum.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/auth/view/components/forgot_password_dialog.dart';
import 'package:greengrocer/src/pages/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/services/util_services.dart';
import 'package:greengrocer/src/services/validators.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Controlador de campos
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final utilServices = UtilServices();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nome do App
                  const AppNameWidget(
                    mainTitleColor: Colors.white,
                    titleFontSize: 35,
                  ),

                  // Categorias
                  SizedBox(
                    height: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 232, 230, 230)),
                      child: AnimatedTextKit(
                          repeatForever: true,
                          pause: Duration.zero,
                          animatedTexts: [
                            FadeAnimatedText('Bebidas'),
                            FadeAnimatedText('Higiene e Limpeza'),
                            FadeAnimatedText('Laticínios'),
                            FadeAnimatedText('Frios e Congelados'),
                            FadeAnimatedText('Mercearia'),
                            FadeAnimatedText('Adega')
                          ]),
                    ),
                  ),
                ],
              ),
            ),

            // Formulário
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(45))),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // E-mail
                    CustomTextField(
                      controller: emailController,
                      icon: Icons.email,
                      label: 'E-mail',
                      validator: emailValidator,
                    ),

                    // Senha
                    CustomTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      label: 'Senha',
                      isSecret: true,
                      validator: passwordValidator,
                    ),

                    // Botão Entrar
                    SizedBox(
                      height: 50,
                      child: GetX<AuthController>(
                        builder: (authController) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            onPressed: authController.isLoading.value
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      String email = emailController.text;
                                      String password = passwordController.text;

                                      authController.signIn(
                                          email: email, password: password);
                                    }
                                  },
                            child: authController.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    // Esqueceu a Senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final bool? result = await showDialog(
                            context: context,
                            builder: (_) {
                              return ForgotPasswordDialog(
                                email: emailController.text,
                              );
                            },
                          );

                          if (result ?? false) {
                            utilServices.showToast(
                              message: 'Link enviado para seu E-mail!',
                              type: AlertTypeEnum.success,
                            );
                          }
                        },
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                              color: CustomColors.customContrastColor),
                        ),
                      ),
                    ),

                    // Divisor
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.withAlpha(90),
                              thickness: 2,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('ou'),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.withAlpha(90),
                              thickness: 2,
                            ),
                          )
                        ],
                      ),
                    ),

                    // Botão Nova Conta
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            side:
                                const BorderSide(width: 2, color: Colors.green),
                          ),
                          onPressed: () {
                            Get.toNamed(PageRoutes.signupRoute);
                          },
                          child: const Text('Criar Conta',
                              style: TextStyle(fontSize: 18))),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
