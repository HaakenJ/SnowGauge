class RegistrationService {
  Future<bool> register(String name, String email, String password) async {

    // we might need to call an API or use a library like Firebase for user registration
    // this example i have used hardcoded registration
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      return true; // Successful registration
    } else {
      return false; // Invalid registration data
    }
  }
}
