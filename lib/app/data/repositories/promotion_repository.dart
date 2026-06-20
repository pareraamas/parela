import 'package:parela/app/data/models/flash_sale_model.dart';

abstract class PromotionRepository {
  Future<FlashSaleModel> getFlashSale({int page = 1, int limit = 20});
}
