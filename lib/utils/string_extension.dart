extension StringValidator on String {
  /// Check if email is empty or invalid
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return isNotEmpty && emailRegex.hasMatch(trim());
  }

  /// Check if password is not empty
  bool get isValidPassword {
    return trim().isNotEmpty;
  }

  /// Check if string is empty
  bool get isEmptyString => trim().isEmpty;
}
