import 'package:get/get.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/repositories/user_repository.dart';

class SelectAddressController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final selectedId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) selectedId.value = args;
    _load();
  }

  Future<void> _load() async {
    final list = await Get.find<UserRepository>().getAddresses();
    addresses.assignAll(list);
    if (selectedId.isEmpty && list.isNotEmpty) {
      final def = list.firstWhere(
        (a) => a.isDefault,
        orElse: () => list.first,
      );
      selectedId.value = def.id;
    }
  }

  void select(String id) {
    selectedId.value = id;
    Get.back(result: id);
  }
}
