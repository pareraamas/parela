import 'package:get/get.dart';
import '../controllers/transaction_tab_controller.dart';

class TransactionTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionTabController>(() => TransactionTabController());
  }
}
