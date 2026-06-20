import 'package:parela/app/data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getAll();
  Future<OrderModel?> getById(String id);
}
