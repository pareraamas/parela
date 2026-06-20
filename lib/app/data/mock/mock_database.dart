import 'package:parela/app/data/mock/mock_content.dart';
import 'package:parela/app/data/models/banner_model.dart';
import 'package:parela/app/data/models/cart_item_model.dart';
import 'package:parela/app/data/models/category_model.dart';
import 'package:parela/app/data/models/notification_model.dart';
import 'package:parela/app/data/models/order_model.dart';
import 'package:parela/app/data/models/product_model.dart';
import 'package:parela/app/data/models/review_model.dart';
import 'package:parela/app/data/models/seller_model.dart';
import 'package:parela/app/data/models/user_model.dart';
import 'package:parela/app/data/models/address_model.dart';
import 'package:parela/app/data/models/payment_method_model.dart';

// In-memory store shared across all mock repositories.
// Simulates a server database — mutations persist for the session lifetime.
class MockDatabase {
  MockDatabase._();
  static final MockDatabase instance = MockDatabase._();

  final List<ProductModel> products = [...MockContent.mockProducts];
  final List<CategoryModel> categories = [...MockContent.mockCategories];
  final List<BannerModel> banners = [...MockContent.mockBanners];
  final List<Map<String, dynamic>> stories = [...MockContent.mockStories];
  final List<OrderModel> orders = [...MockContent.mockOrders];
  final List<NotificationModel> notifications = [...MockContent.mockNotifications];
  final List<SellerModel> sellers = [...MockContent.mockSellers];
  final List<ReviewModel> reviews = [...MockContent.mockReviews];
  final List<CartItemModel> cartItems = [...MockContent.mockCartItems];
  UserModel user = MockContent.mockUser;
  final List<AddressModel> addresses = [...MockContent.mockAddresses];
  final List<PaymentMethodModel> paymentMethods = [...MockContent.mockPaymentMethods];

  // Simulate server pagination: returns a slice + whether more pages exist.
  ({List<T> data, bool hasMore}) paginate<T>(
    List<T> source, {
    required int page,
    required int limit,
  }) {
    final start = (page - 1) * limit;
    if (start >= source.length) return (data: [], hasMore: false);
    final data = source.skip(start).take(limit).toList();
    return (data: data, hasMore: start + data.length < source.length);
  }
}
