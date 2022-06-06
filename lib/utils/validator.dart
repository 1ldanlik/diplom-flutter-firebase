class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Поле Email не может быть пустым';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Введите корректный Email';
    }

    return null;
  }

  static String? validateNumber({required String? number}) {
    if (number == null) {
      return null;
    }
    RegExp numberRegExp = RegExp("r'[0-9]");

    if (!numberRegExp.hasMatch(number)) {
      return 'Можно вводить только цифры';
    }

    return null;
  }

  static String? validateSummary({required String? summary}) {
    if (summary == null) {
      return null;
    }

    if (summary.isEmpty) {
      return 'Название задачи не может быть пустым';
    }

    return null;
  }

  static String? validateSubdivision({required String? subDivis}) {
    if (subDivis == null) {
      return null;
    }
    if (subDivis.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Пароль не должен отсутствовать';
    } else if (password.length < 6) {
      return 'Пароль должен содержать хотя бы 6 символов';
    }

    return null;
  }

  static String? validateJiraPassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Пароль не должен отсутствовать';
    } else if (password.length < 24) {
      return 'API Token должен иметь 24 символа и более';
    }

    return null;
  }












  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return 'Строка не может быть пустой';
    }

    return null;
  }

  static String? validateUserID({required String uid}) {
    if (uid.isEmpty) {
      return 'User ID can\'t be empty';
    } else if (uid.length <= 3) {
      return 'User ID should be greater than 3 characters';
    }

    return null;
  }






}