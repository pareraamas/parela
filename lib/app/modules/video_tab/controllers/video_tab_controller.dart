import 'package:get/get.dart';

class VideoTabController extends GetxController {
  final feedType = 0.obs;
  final likedStates = List.filled(5, false).obs;

  void toggleLike(int index) {
    likedStates[index] = !likedStates[index];
  }

  void setFeedType(int type) => feedType.value = type;
}
