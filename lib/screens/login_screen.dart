import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/screens/home_screen.dart';
import 'package:homey_park/screens/register_screen.dart';
import 'package:homey_park/services/user_service.dart';
import 'package:homey_park/utils/text_field_validator.dart';

final _loginFormKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  String error = "";

  void navigateToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  void navigateToHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void handleSubmit() async {
    if (_loginFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Procesando datos'),
        duration: Duration(seconds: 3),
      ));

      try {
        final user = await UserService.login(
            emailFieldController.text, passwordFieldController.text);

        preferences.saveUserId(user.id);
        navigateToHome();
      } catch (e) {
        print(e);
        setState(() {
          error = e.toString();
        });
      }
    }
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
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Inicio de sesión",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "¿Olvido su contraseña?",
                              style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize:
                                      theme.textTheme.labelMedium!.fontSize,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: handleSubmit,
                          child: const Text('Iniciar sesión'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: navigateToRegister,
                          child: const Text('Crear cuenta'),
                        ),
                      ),
                      error.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: Text(
                                error,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontSize:
                                      theme.textTheme.labelMedium!.fontSize,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )));
  }
}
