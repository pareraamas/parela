import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/seller_model.dart';
import '../seller_repository.dart';

class MockSellerRepository implements SellerRepository {
  @override
  Future<List<SellerModel>> getAll() async => MockContent.mockSellers;

  @override
  Future<SellerModel?> getById(String id) async =>
      MockContent.mockSellers.where((s) => s.id == id).firstOrNull;
}
