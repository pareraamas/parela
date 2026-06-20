import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/repositories/order_repository.dart';
import 'package:parela/app/services/api_client.dart';

class ApiOrderRepository implements OrderRepository {
  final _client = ApiClient.instance;

  @override
  Future<List<OrderModel>> getAll() async {
    final res = await _client.get('/orders');
    return ((res['data'] as List?) ?? [])
        .map((j) => OrderModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel?> getById(String id) async {
    final res = await _client.get('/orders/$id');
    final data = res['data'];
    if (data == null) return null;
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }
}
