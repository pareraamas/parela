import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import '../user_repository.dart';

class MockUserRepository implements UserRepository {
  @override
  UserModel getUser() => MockContent.mockUser;

  @override
  List<AddressModel> getAddresses() => MockContent.mockAddresses;

  @override
  List<PaymentMethodModel> getPaymentMethods() => MockContent.mockPaymentMethods;
}
