import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/repositories/seller_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiSellerRepository implements SellerRepository {
  final _client = ApiClient.instance;

  @override
  Future<List<SellerModel>> getAll() async {
    final res = await _client.get('/sellers/following', auth: false);
    return ((res['data'] as List?) ?? [])
        .map((j) => SellerModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SellerModel?> getById(String id) async {
    final res = await _client.get('/sellers/$id', auth: false);
    final data = res['data'];
    if (data == null) return null;
    return SellerModel.fromJson(data as Map<String, dynamic>);
  }
}
