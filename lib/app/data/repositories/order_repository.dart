import 'package:parela/app/data/models/order_model.dart';

abstract class OrderRepository {
  List<OrderModel> getAll();
  OrderModel? getById(String id);
}
