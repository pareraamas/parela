import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/order_model.dart';
import '../order_repository.dart';

class MockOrderRepository implements OrderRepository {
  @override
  List<OrderModel> getAll() => MockContent.mockOrders;

  @override
  OrderModel? getById(String id) =>
      MockContent.mockOrders.where((o) => o.id == id).firstOrNull;
}
