import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/repositories/user_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiUserRepository implements UserRepository {
  final _client = ApiClient.instance;

  @override
  Future<UserModel> getUser() async {
    final res = await _client.get('/users/me');
    return UserModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final res = await _client.get('/users/me/addresses');
    return ((res['data'] as List?) ?? [])
        .map((j) => AddressModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final res = await _client.get('/users/me/payment-methods');
    return ((res['data'] as List?) ?? [])
        .map((j) => PaymentMethodModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
