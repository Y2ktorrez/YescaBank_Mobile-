import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Guardar el token
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token); // Guardamos el token bajo la clave 'authToken'
      print("Token guardado exitosamente.");
    } catch (e) {
      print("Error al guardar el token: $e");
    }
  }

  // Obtener el token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken'); // Recuperamos el token
      if (token != null) {
        print("Token recuperado: $token");
      } else {
        print("No se encontró ningún token.");
      }
      return token;
    } catch (e) {
      print("Error al obtener el token: $e");
      return null;
    }
  }

  // Eliminar el token (Logout)
  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken'); // Eliminamos el token
      print("Token eliminado exitosamente.");
    } catch (e) {
      print("Error al eliminar el token: $e");
    }
  }
}