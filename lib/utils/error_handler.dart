class ErrorHandler {
  static String getMessage(dynamic error) {
    final message = error.toString();

    // Firebase Auth errors
    if (message.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (message.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (message.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (message.contains('weak-password')) {
      return 'Password is too weak. Use at least 6 characters.';
    } else if (message.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (message.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (message.contains('network-request-failed')) {
      return 'No internet connection. Please check your network.';
    } else if (message.contains('permission-denied')) {
      return 'You don\'t have permission to do this.';
    } else if (message.contains('unavailable')) {
      return 'Service unavailable. Please try again later.';
    } else if (message.contains('cancelled')) {
      return 'Operation cancelled.';
    }

    // Generic
    return 'Something went wrong. Please try again.';
  }
}