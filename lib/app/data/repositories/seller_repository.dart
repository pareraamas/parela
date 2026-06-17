import 'package:parela/app/data/models/seller_model.dart';

abstract class SellerRepository {
  List<SellerModel> getAll();
  SellerModel? getById(String id);
}
