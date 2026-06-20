import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import '../user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<UserModel> getUser() async => MockContent.mockUser;

  @override
  Future<List<AddressModel>> getAddresses() async => MockContent.mockAddresses;

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => MockContent.mockPaymentMethods;
}
