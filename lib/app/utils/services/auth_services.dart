import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static Future<bool> isAuthenticated() async {
    final prefs = await SPHelper.getTokenSharedPreference();

    return prefs != null && prefs.isNotEmpty;
  }

  Future<dynamic> login(String username, String password) async {
    Dio _dio = Dio();
    try {
      Response response = await _dio.post(
        'https://realtor.azurewebsites.net/api/Authenticate/login',
        data: {
          'username': username,
          'password': password,
        },
        // queryParameters: {'apikey': ApiSecret.apiKey},
      );
      final res = response.data;
      if (res['status'] != 401) {
        String accessToken = res['token'];
        String token = accessToken;
        print(token);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        bool isTokenExpired = JwtDecoder.isExpired(token);

        if (isTokenExpired == true) {}

        await _saveToken(token);
      }
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  static Future<void> _saveToken(String token) async {
    await SPHelper.saveTokenSharedPreference(token);
  }

  static Future<void> logout() async {
    await SPHelper.removeTokenSharedPreference();
  }

  static Future<String?> getToken() async {
    final prefs = await SPHelper.getTokenSharedPreference();
    return prefs;
  }
}
