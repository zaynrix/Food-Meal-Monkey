import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/helper.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    print("This is error code >>>>> ${e.code}");
    String errorMessage = "";
    switch (e.code) {
      case "email-already-in-use":
        errorMessage = "The email address is already used";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "user-not-found":
        errorMessage = "User with this email doesn't exist.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "user_disabled":
        errorMessage = "User with this email has been disabled.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "too_many_requests":
        errorMessage = "Too many requests. Try again later.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      case "operation_not_allowed":
        errorMessage = "Signing in with Email and Password is not enabled.";
        showErrorSnackBarAbdDebug(errorMessage);
        break;
      default:
        errorMessage = "An undefined Error happened.";
        showErrorSnackBarAbdDebug(errorMessage);
    }
    // return status;
  }

  static showErrorSnackBarAbdDebug(String message) {
    debugPrint(message);
    Helpers.showSnackBar(message: message, isSuccess: false);
  }

}
