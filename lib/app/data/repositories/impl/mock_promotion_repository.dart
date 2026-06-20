import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/repositories/promotion_repository.dart';

class MockPromotionRepository implements PromotionRepository {
  @override
  Future<FlashSaleModel> getFlashSale({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockContent.mockFlashSale;
  }
}
