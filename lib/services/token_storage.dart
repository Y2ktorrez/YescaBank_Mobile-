import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Guardar el token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token); // Guardamos el token bajo la clave 'authToken'
  }

  // Obtener el token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken'); // Recuperamos el token
  }

  // Eliminar el token (Logout)
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Eliminamos el token
  }
}