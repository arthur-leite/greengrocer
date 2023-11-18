import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_text_field.dart';
import 'package:greengrocer/src/services/validators.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        actions: [
          IconButton(
              onPressed: () {
                authController.signOut();
              },
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
      body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          children: [
            CircleAvatar(
              radius: 60,
              child: ClipOval(
                child: Image.network(
                  'https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678130-profile-alt-4-512.png',
                ),
              ),
            ),

            // Espaçamento
            const SizedBox(height: 16),

            // Nome
            CustomTextField(
              initialValue: authController.user.name,
              icon: Icons.person,
              label: 'Nome',
              readOnly: true,
            ),

            // E-mail
            CustomTextField(
              initialValue: authController.user.email,
              icon: Icons.email,
              label: 'E-mail',
              readOnly: true,
            ),

            // Celular
            CustomTextField(
              initialValue: authController.user.phone,
              icon: Icons.phone,
              label: 'Celular',
              readOnly: true,
            ),

            // CPF
            CustomTextField(
              initialValue: authController.user.cpf,
              icon: Icons.file_copy,
              label: 'CPF',
              isSecret: true,
              readOnly: true,
            ),

            // Botão Atualizar Senha
            SizedBox(
              height: 50,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    updatePassword();
                  },
                  child: const Text('Alterar Senha')),
            )
          ]),
    );
  }

  Future<bool?> updatePassword() {

    final newPasswordController = TextEditingController();

    final currentPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'Atualização de Senha',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),

                          // Senha Atual
                          CustomTextField(
                            controller: currentPasswordController,
                            icon: Icons.lock,
                            label: 'Senha Atual',
                            isSecret: true,
                            validator: passwordValidator,
                          ),

                          // Nova Senha
                          CustomTextField(
                            controller: newPasswordController,
                            icon: Icons.lock_outline,
                            label: 'Nova Senha',
                            isSecret: true,
                            validator: passwordValidator,
                          ),

                          // Confirmação Nova Senha
                          CustomTextField(
                              icon: Icons.lock_outline,
                              label: 'Confirmar Nova Senha',
                              isSecret: true,
                              validator: (password) {
                                final result = passwordValidator(password);

                                if (result != null) {
                                  return result;
                                }

                                if (password != newPasswordController.text) {
                                  return 'Repita a mesma senha informada acima.';
                                }

                                return null;
                              }),

                          // Botão Confirmação
                          SizedBox(
                            height: 45,
                            child: Obx(() => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: authController.isLoading.value
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            authController.changePassword(
                                              password:
                                                  currentPasswordController
                                                      .text,
                                              newPassword:
                                                  newPasswordController.text,
                                            );
                                          }
                                        },
                                  child: authController.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text('Atualizar'),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ));
        });
  }
}
