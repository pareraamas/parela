import 'package:get/get.dart';
import 'package:parela/app/data/repositories/product_repository.dart';
import 'package:parela/app/modules/main/controllers/main_controller.dart';

class VideoTabController extends GetxController {
  late final ProductRepository _productRepo;

  static const _videoTabIndex = 2;

  final feedType = 0.obs;
  final currentPage = 0.obs;
  final isTabActive = false.obs;
  final videos = <Map<String, dynamic>>[].obs;
  final likedStates = <bool>[].obs;
  final followedStates = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    _productRepo = Get.find<ProductRepository>();
    final main = Get.find<MainController>();
    isTabActive.value = main.tabIndex.value == _videoTabIndex;
    ever(main.tabIndex, (index) {
      isTabActive.value = index == _videoTabIndex;
    });
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final data = await _productRepo.getVideoFeed();
    videos.assignAll(data);
    likedStates.assignAll(List.filled(data.length, false));
    followedStates.assignAll(List.filled(data.length, false));
  }

  void onPageChanged(int index) => currentPage.value = index;

  void toggleLike(int index) {
    if (index < likedStates.length) {
      likedStates[index] = !likedStates[index];
    }
  }

  void toggleFollow(int index) {
    if (index < followedStates.length) {
      followedStates[index] = !followedStates[index];
    }
  }

  void setFeedType(int type) => feedType.value = type;
}
