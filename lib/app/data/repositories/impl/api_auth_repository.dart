import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/services/api_client.dart';
import 'package:parela/app/services/storage_service.dart';

class ApiAuthRepository implements AuthRepository {
  final _client = ApiClient.instance;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final res = await _client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );
    final data = res['data'] as Map<String, dynamic>;
    await StorageService.instance.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    final res = await _client.post(
      '/auth/register',
      body: {'name': name, 'email': email, 'password': password, 'password_confirmation': password},
      auth: false,
    );
    final data = res['data'] as Map<String, dynamic>;
    await StorageService.instance.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _client.post('/auth/logout');
    await StorageService.instance.clearTokens();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _client.post('/auth/forgot-password', body: {'email': email}, auth: false);
  }
}
