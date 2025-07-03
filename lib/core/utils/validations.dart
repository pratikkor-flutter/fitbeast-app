// validate the email entered by the user
import 'package:flutter/services.dart';

Future<bool> isValidEmail(String email) async {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // regex not matched
  if (!emailRegex.hasMatch(email)) return false;

  // Load and parse the .conf file
  final fileContent =
      await rootBundle.loadString('assets/disposable_email_blocklist.conf');
  final List<String> blocklistedDomains = fileContent
      .split('\n')
      .map((line) => line.trim().toLowerCase())
      .where((line) =>
          line.isNotEmpty &&
          !line.startsWith('#')) // ignore empty and commented lines
      .toList();

  final domain = email.split('@').last.toLowerCase();
  // Check if the domain is in the blocklist
  bool isDisposable = blocklistedDomains.contains(domain);

  return !isDisposable;
}

bool isValidPassword(String password) {
  // Password must be at least 8 characters long.
  if (password.length < 8) {
    return false;
  }

  // Password must contain at least one uppercase letter.
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  }

  // Password must contain at least one lowercase letter.
  if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  }

  // Password must contain at least one digit.
  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  // Password must contain at least one special character (e.g., !@#$%^&*()-_+=).
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return false;
  }

  // If all checks pass, the password is valid.
  return true;
}

// is valid username
// check for firebase username 