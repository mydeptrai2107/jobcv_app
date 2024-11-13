import 'package:intl/intl.dart';

class Format {
  static String formatDateTimeToYYYYmm(DateTime dateTime) {
    return DateFormat('MM/yyyy').format(dateTime).toString();
  }

  static String formatDateTimeToYYYYmmdd(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime).toString();
  }

  static String formatDateTimeToYYYYmmHHmm(DateTime dateTime) {
    return DateFormat.yMd().add_jm().format(dateTime).toString();
  }

  static String getFirstNameByName(String name) {
    String firstName = '';
    for (int i = 0; i < name.length; i++) {
      if (name[i] != ' ') {
        firstName += name[i];
      } else {
        return firstName;
      }
    }
    return firstName;
  }

  static String getLastNameByName(String name) {
    String lastName = '';
    int index = 0;
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ') {
        index = i;
        break;
      }
    }

    for (int i = index; i < name.length; i++) {
      lastName += name[i];
    }
    return lastName.trim();
  }

  static String formatMoneyToString(String money) {
    String value = '';
    for (int i = 0; i < money.length; i++) {
      if (money[i] != ' ') {
        value += money[i];
      }
    }
    return value;
  }

  static String formatStringToMoney(String value) {
    String moneyFake = '';
    String money = '';
    int index = 0;
    for (int i = value.length - 1; i >= 0; i--) {
      if (index == 2) {
        moneyFake += value[i];
        moneyFake += ' ';
        index = 0;
      } else {
        moneyFake += value[i];
        index++;
      }
    }

    for (int i = moneyFake.length - 1; i >= 0; i--) {
      money += moneyFake[i];
    }
    return money;
  }
}
