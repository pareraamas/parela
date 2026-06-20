import 'package:parela/app/data/models/seller_model.dart';

abstract class SellerRepository {
  Future<List<SellerModel>> getAll();
  Future<SellerModel?> getById(String id);
}
