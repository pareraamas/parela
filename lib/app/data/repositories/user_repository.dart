import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
  Future<List<AddressModel>> getAddresses();
  Future<List<PaymentMethodModel>> getPaymentMethods();
}
