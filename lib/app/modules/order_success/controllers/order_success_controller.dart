import 'package:get/get.dart';

class OrderSuccessController extends GetxController {
  late final String orderNumber;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    final seq = (now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0');
    orderNumber =
        '#PRLA-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$seq';
  }
}
