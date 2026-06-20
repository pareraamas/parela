import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/order_model.dart';
import '../order_repository.dart';

class MockOrderRepository implements OrderRepository {
  @override
  Future<List<OrderModel>> getAll() async => MockContent.mockOrders;

  @override
  Future<OrderModel?> getById(String id) async =>
      MockContent.mockOrders.where((o) => o.id == id).firstOrNull;
}
