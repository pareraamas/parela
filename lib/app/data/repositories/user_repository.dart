import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';
import 'package:parela/app/data/models/user_model.dart';

abstract class UserRepository {
  UserModel getUser();
  List<AddressModel> getAddresses();
  List<PaymentMethodModel> getPaymentMethods();
}
