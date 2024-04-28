class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  static String LOGIN_SUCCESS = 'Login successful.';
  static String LOGIN_FAILURE = 'Login failed.';
  static String LOGIN_INCORRECT = 'Invalid email or password.';
  static String USER_DISABLE = 'Account has been disabled.';
  static String SIGN_UP_FAILURE = 'Sign up failed.';
  static String CONFIRM_SIGN_UP_FAILURE = 'Confirm sign up failed.';
  static String EMAIL_EXISTED = 'An account already exists with the given email.';
  static String CREATE_OTP_FAILURE = 'Failed to send OTP.';
  static String FORGOT_PASSWORD_FAILUARE = 'Failed to reset password.';
  static String EMAIL_NOT_EXIST = 'The email does not exist or has not been authenticated.';

  static String CHANGE_PASSWORD_FAILURE = 'Failed to change password.';
  static String WRONG_PASSWORD = 'Wrong password.';
  static String SAME_PASSWORD = 'The new password must not be the same as the old password.';
  static String CHANGE_PROFILE_FAILURE = 'Failed to change profile information.';

  static String LOGOUT_FAILURE = 'Logout failed.';

  static String GET_INFO_FAILURE = 'Failed to get information.';

  static String GET_FAIL = "Failed to get data.";

  static String TOO_MANY_REQUESTS = 'Too many requests. Please try again later.';
}