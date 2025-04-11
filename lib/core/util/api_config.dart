class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'https://fluxx-api.onrender.com';  

  // Authentication endpoints
  static const String signUp = '/api/auth/signup';
  static const String login = '/api/auth/login';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String resendVerification = '/api/auth/resend-verification';
} 