import 'package:flutter/material.dart';
import 'package:homey_park/screens/home_screen.dart';
import 'package:homey_park/screens/login_screen.dart';
import 'package:homey_park/utils/text_field_validator.dart';

final _registerFormKey = GlobalKey<FormState>();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  bool repeatPasswordVisible = false;

  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final repeatPasswordFieldController = TextEditingController();

  String? validateRepeatPassword(String? repeatPassword) {
    var isEmpty = TextFieldValidator.validateEmptyField(repeatPassword);

    if (isEmpty != null) return isEmpty;

    if (repeatPassword != passwordFieldController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  void handleSubmit() {
    if (_registerFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Procesando datos'),
        duration: Duration(seconds: 3),
      ));

      Future.delayed(const Duration(seconds: 3), () {
        navigateToApp();
      });
    }
  }

  void navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void navigateToApp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Crear cuenta",
                        style: TextStyle(
                          fontSize: theme.textTheme.headlineMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: TextFormField(
                          controller: emailFieldController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: TextFieldValidator.validateEmailField,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: TextFormField(
                          controller: passwordFieldController,
                          obscureText: !passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscuringCharacter: "*",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: TextFieldValidator.validatePasswordField,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: TextFormField(
                          controller: repeatPasswordFieldController,
                          obscureText: !repeatPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscuringCharacter: "*",
                          validator: validateRepeatPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Repetir contraseña',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    repeatPasswordVisible =
                                        !repeatPasswordVisible;
                                  });
                                },
                                icon: Icon(repeatPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Tienes una cuenta?",
                              style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize:
                                      theme.textTheme.labelMedium!.fontSize,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: navigateToLogin,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(left: 4),
                              ),
                              child: Text(
                                "Inicia sesión",
                                style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize:
                                        theme.textTheme.labelMedium!.fontSize,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: handleSubmit,
                          child: const Text('Registrarse'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  String? validateEmptyField(String value) {
    if (value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }
}
