import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class StoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final List<Map<String, dynamic>> stories;
  late AnimationController progressController;

  final currentIndex = 0.obs;
  final isPaused = false.obs;
  final isVideoLoading = true.obs;

  VideoPlayerController? _video;
  VideoPlayerController? get videoController => _video;

  static const _fallbackDuration = Duration(seconds: 5);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    stories = List<Map<String, dynamic>>.from(args['stories'] as List);
    currentIndex.value = args['initialIndex'] as int;

    progressController = AnimationController(
      vsync: this,
      duration: _fallbackDuration,
    )..addStatusListener(_onStatus);

    _initStory();
  }

  @override
  void onClose() {
    _video?.dispose();
    progressController.dispose();
    super.onClose();
  }

  Future<void> _initStory() async {
    isVideoLoading.value = true;
    progressController
      ..stop()
      ..reset();

    await _video?.dispose();
    _video = null;

    final videoUrl = currentStory['videoUrl'] as String?;

    if (videoUrl != null) {
      final vc = VideoPlayerController.asset(videoUrl);
      _video = vc;
      await vc.initialize();
      final dur = vc.value.duration;
      progressController.duration =
          dur > Duration.zero ? dur : _fallbackDuration;
      isVideoLoading.value = false;
      await vc.play();
    } else {
      progressController.duration = _fallbackDuration;
      isVideoLoading.value = false;
    }

    progressController.forward(from: 0);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) goNext();
  }

  void goNext() {
    if (currentIndex.value < stories.length - 1) {
      currentIndex.value++;
      _initStory();
    } else {
      Get.back();
    }
  }

  void goPrev() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      _initStory();
    } else {
      _initStory();
    }
  }

  void pause() {
    isPaused.value = true;
    progressController.stop();
    _video?.pause();
  }

  void resume() {
    isPaused.value = false;
    progressController.forward();
    _video?.play();
  }

  Map<String, dynamic> get currentStory => stories[currentIndex.value];
}
