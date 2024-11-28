// validators.dart

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }
  if (value.trim().length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  // Regular expression for Coventry University email validation
  final RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@coventryuniversity\.com$");
  if (!emailRegExp.hasMatch(value)) {
    return 'Enter a valid Coventry University email';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  // Simple phone number regex (adjust as needed)
  final RegExp phoneRegExp = RegExp(r'^\+?\d{10,15}$');
  if (!phoneRegExp.hasMatch(value)) {
    return 'Enter a valid phone number';
  }
  return null;
}
