import 'package:parela/app/data/models/flash_sale_model.dart';
import 'package:parela/app/data/repositories/promotion_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiPromotionRepository implements PromotionRepository {
  final _client = ApiClient.instance;

  @override
  Future<FlashSaleModel> getFlashSale({int page = 1, int limit = 20}) async {
    final res = await _client.get(
      '/promotions/flash-sale',
      query: {'page': page, 'limit': limit},
      auth: false,
    );
    return FlashSaleModel.fromJson(res['data'] as Map<String, dynamic>);
  }
}
