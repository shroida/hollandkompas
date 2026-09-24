String friendlyAuthErrorMessage(String message) {
  final normalizedMessage = message.trim().toLowerCase();

  if (normalizedMessage == 'invalid login credentials') {
    return 'Incorrect email or password.';
  }

  if (normalizedMessage == 'email not confirmed') {
    return 'Please verify your email before logging in.';
  }

  if (normalizedMessage == 'user not found') {
    return 'No account exists with this email.';
  }

  if (normalizedMessage == 'too many requests') {
    return 'Too many login attempts. Please try again later.';
  }

  return message;
}
