import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/repositories/auth_repository.dart';
import 'package:parela/app/services/storage_service.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    await StorageService.instance.saveTokens(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
    );
    return MockContent.mockUser;
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    await StorageService.instance.saveTokens(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
    );
    return UserModel(
      id: 'u_new',
      name: name,
      email: email,
      phone: '',
      address: '',
      verified: false,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await StorageService.instance.clearTokens();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
