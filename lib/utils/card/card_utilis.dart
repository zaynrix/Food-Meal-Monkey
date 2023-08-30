import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/utils/card/card_strings.dart';
import 'package:food_delivery_app/utils/card/card_type.dart';


class CardUtils {
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.fieldReq;
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.fieldReq;
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(/)'))) {
      var split = value.split(RegExp(r'(/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static Widget? getCardIcon(CardType? cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case CardType.Master:
        img = ImageAssets.mastercardIcon;
        break;
      case CardType.Visa:
        img = ImageAssets.visaIcon;
        break;
      case CardType.Verve:
        img = ImageAssets.verveIcon;
        break;
      case CardType.AmericanExpress:
        img = ImageAssets.americanExpress;
        break;
      case CardType.Discover:
        img = ImageAssets.discoverIcon;
        break;
      case CardType.DinersClub:
        img = ImageAssets.dinnersClubIcon;
        break;
      case CardType.Jcb:
        img = ImageAssets.jcdIcon;
        break;
      case CardType.Others:
        icon = const Icon(
          Icons.credit_card,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
      default:
        icon = const Icon(
          Icons.warning,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
    }
    Widget? widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        img,
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  /// With the card number with Luhn Algorithm
  /// https://en.wikipedia.org/wiki/Luhn_algorithm



  static String? validateCardNum(String? input) {
    if (input == null || input.isEmpty) {
      return Strings.fieldReq;
    }

    input = getCleanedNumber(input);
    isValidCardNumber(input);
    if (!isValidCardNumber(input)) {
      return 'Invalid card number';
    }
    return null;
    // if (input.length < 8) {
    //   return Strings.numberIsInvalid;
    // }
    //
    // int sum = 0;
    // int length = input.length;
    // for (var i = 0; i < length; i++) {
    //   // get digits in reverse order
    //   int digit = int.parse(input[length - i - 1]);
    //
    //   // every 2nd number multiply with 2
    //   if (i % 2 == 1) {
    //     digit *= 2;
    //   }
    //   sum += digit > 9 ? (digit - 9) : digit;
    // }
    //
    // if (sum % 10 == 0) {
    //   return null;
    // }

    // return Strings.numberIsInvalid;
  }


  static bool isValidCardNumber(String cardNumber) {
    // Remove any spaces or dashes from the input
    String sanitizedCardNumber = cardNumber.replaceAll(RegExp(r'\s+|-'), '');

    // Check if the card number contains only digits and has a valid length
    if (!RegExp(r'^[0-9]+$').hasMatch(sanitizedCardNumber) ||
        sanitizedCardNumber.length < 13 ||
        sanitizedCardNumber.length > 19) {
      return false;
    }

    // Perform Luhn's algorithm to check the validity of the card number
    int sum = 0;
    bool isAlternate = false;
    for (int i = sanitizedCardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(sanitizedCardNumber[i]);
      if (isAlternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      isAlternate = !isAlternate;
    }
    return sum % 10 == 0;
  }


  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.Master;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = CardType.Visa;
    } else if (input.startsWith(RegExp(r'((506([01]))|(507([89]))|(6500))'))) {
      cardType = CardType.Verve;
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardType.AmericanExpress;
    } else if (input.startsWith(RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.Discover;
    } else if (input.startsWith(RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.DinersClub;
    } else if (input.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardType.Jcb;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }
}
