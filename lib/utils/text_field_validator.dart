class TextFieldValidator {
  static String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  static String? validateEmailField(String? value) {
    var isEmpty = validateEmptyField(value);

    if (isEmpty != null) return isEmpty;

    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegExp.hasMatch(value ?? '');

    if (!isEmailValid) return 'Por favor, introduce un email válido';

    return null;
  }

  static String? validatePasswordField(String? value) {
    var isEmpty = validateEmptyField(value);

    if (isEmpty != null) return isEmpty;

    if (value!.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }
}
