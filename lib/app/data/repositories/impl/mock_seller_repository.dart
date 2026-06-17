import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/seller_model.dart';
import '../seller_repository.dart';

class MockSellerRepository implements SellerRepository {
  @override
  List<SellerModel> getAll() => MockContent.mockSellers;

  @override
  SellerModel? getById(String id) =>
      MockContent.mockSellers.where((s) => s.id == id).firstOrNull;
}
