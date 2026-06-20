# Parela — Flutter Marketplace App

## Project Overview
Parela adalah aplikasi marketplace beauty/kosmetik berbasis Flutter. Saat ini seluruh data menggunakan mock/placeholder. Backend belum terhubung — semua data diakses melalui **Repository pattern** sehingga nanti cukup mengganti implementasi `Mock*Repository` dengan `Api*Repository` tanpa mengubah controller atau view.

## Tech Stack
- **Flutter** SDK ^3.10.9
- **GetX** `^4.7.3` — state management, DI, navigation
- **shared_preferences** `^2.3.3` — persistensi cart & wishlist lokal
- **Platform**: Android, iOS, Web, macOS, Windows, Linux

## Architecture

### Pattern: GetX + Repository
```
View → Controller → Repository (abstract) → Mock/API Implementation
```

- **Controllers** hanya boleh memanggil `Get.find<XRepository>()` — tidak boleh akses `MockContent` langsung
- **Repositories** terdaftar sebagai permanent singleton di `AppBinding`
- **AppBinding** (`lib/app/bindings/app_binding.dart`) dijalankan saat app start via `initialBinding: AppBinding()`

### Folder Structure
```
lib/
├── main.dart
└── app/
    ├── bindings/
    │   └── app_binding.dart          ← Register semua repository
    ├── data/
    │   ├── mock/
    │   │   └── mock_content.dart     ← SATU-SATUNYA sumber mock data
    │   ├── models/                   ← Data models (typed)
    │   └── repositories/
    │       ├── *.dart                ← Abstract interfaces
    │       └── impl/
    │           └── mock_*.dart       ← Mock implementations
    ├── modules/
    │   └── <module>/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    ├── routes/
    │   ├── app_pages.dart
    │   └── app_routes.dart
    ├── services/
    │   └── storage_service.dart      ← SharedPreferences wrapper
    └── theme/
        └── app_colors.dart
```

## Color Theme
```dart
const kBackground  = Color(0xFFFCEDF3);  // pink sangat muda (scaffold bg)
const kPrimary     = Color(0xFFD4548A);  // pink utama
const kPrimaryLight = Color(0xFFF8D7E5); // pink muda (chip, highlight)
const kBadge       = Color(0xFF3B82F6);  // biru (badge angka)
const kText        = Color(0xFF1A1A2E);  // hitam kebiruan
const kSubtext     = Color(0xFF8C8C8C);  // abu-abu
```
Selalu import dari `package:parela/app/theme/app_colors.dart`.

## Repositories (6 buah)

| Abstract | Mock Impl | Isi |
|---|---|---|
| `ProductRepository` | `MockProductRepository` | products, categories, banners, stories, reviews |
| `UserRepository` | `MockUserRepository` | user, addresses, paymentMethods |
| `OrderRepository` | `MockOrderRepository` | orders |
| `NotificationRepository` | `MockNotificationRepository` | notifications |
| `SellerRepository` | `MockSellerRepository` | sellers |
| `CartRepository` | `MockCartRepository` | cart (MockContent + StorageService) |

Untuk koneksi ke API nanti: buat `ApiXRepository implements XRepository`, daftarkan di `AppBinding` menggantikan `MockXRepository`.

## Routes

```dart
Routes.SPLASH          → /splash
Routes.ONBOARDING      → /onboarding
Routes.LOGIN           → /login
Routes.REGISTER        → /register
Routes.FORGOT_PASSWORD → /forgot-password
Routes.MAIN            → /main       ← shell dengan 5 tab
Routes.PRODUCT_DETAIL  → /product-detail
Routes.CATEGORY_PRODUCTS → /category-products
Routes.ALL_PRODUCTS    → /all-products
Routes.CHECKOUT        → /checkout
Routes.ORDER_SUCCESS   → /order-success
Routes.MY_ORDERS       → /my-orders
Routes.ORDER_DETAIL    → /order-detail
Routes.NOTIFICATIONS   → /notifications
Routes.EDIT_PROFILE    → /edit-profile
Routes.SELLER_STORE    → /seller-store
Routes.CART            → /cart
Routes.MESSAGES        → /messages
Routes.CHAT            → /chat
```

## Main Shell (5 Tab)
`MainView` (`/main`) menggunakan `IndexedStack`:
```
Index 0 → HomeTab
Index 1 → ExploreTab
Index 2 → VideoTab      ← full-screen TikTok style, dark background
Index 3 → TransactionTab ← orders list
Index 4 → ProfileTab
```
Bottom nav tengah (Video) menggunakan TikTok-style button (cyan + red offset).
**Cart & Chat** ada di `AppHeader` (header tiap tab), bukan di bottom nav.

## AppHeader
`lib/app/modules/main/widgets/app_header.dart` — dipakai di semua tab kecuali VideoTab.
- Logo `par`**`ela`** atau judul tab
- Chat icon → `Routes.MESSAGES`
- Cart icon dengan badge dari `MainController.cartCount`

## Models

```dart
ProductModel    — id, name, brand, price, originalPrice, rating, reviewCount,
                  isBestSeller, sellerId, categoryId, description,
                  colors (List<int>), sizes (List<String>), color (Color)
UserModel       — id, name, email, phone, address, avatarUrl, verified
CartItemModel   — productId, quantity, color(int), size, price
OrderModel      — id, date, status, total, items(List<String>), tracking
NotificationModel — id, title, body, isRead, time, type
SellerModel     — id, name, rating, productCount, verified, description
AddressModel    — id, label, recipient, street, city, postalCode, isDefault
PaymentMethodModel — id, label, type, last4, isDefault
ReviewModel     — id, productId, userId, userName, rating, comment, date
CategoryModel   — id, label, icon(IconData)
BannerModel     — tag, title, subtitle, colorStart, colorEnd
ConversationModel — id, sellerName, sellerInitial, avatarColor, lastMessage,
                    time, isRead, unreadCount, isOnline
MessageModel    — id, text, time, isMe, isRead
```

## GetX Rules
- **Obx** hanya boleh membungkus widget yang **langsung** membaca observable. Jangan bungkus `ListView.builder`/`GridView.builder` — observable harus dibaca **di dalam** `itemBuilder` via `Obx` per-item.
- **Get.find\<T\>()** di `onInit()` — pastikan dependency sudah terdaftar di `AppBinding` sebelum controller dipakai.
- `MainController` adalah sumber kebenaran untuk `cartItems`, `wishlistIds`, `products`, `categories`, `banners`, `stories`.

## Mock Data
Semua mock ada di `lib/app/data/mock/mock_content.dart`:
- `MockContent.mockProducts` — 8 produk
- `MockContent.mockCategories` — 8 kategori
- `MockContent.mockBanners` — 3 banner
- `MockContent.mockStories` — 5 story
- `MockContent.mockOrders` — 5 order
- `MockContent.mockNotifications` — 10 notifikasi
- `MockContent.mockSellers` — 5 seller
- `MockContent.mockUser` — 1 user
- `MockContent.mockAddresses` — 2 alamat
- `MockContent.mockPaymentMethods` — 3 metode bayar
- `MockContent.mockCartItems` — 3 item awal cart
- `MockContent.mockReviews` — reviews per produk

## Commands
```bash
flutter analyze          # wajib clean sebelum commit
flutter run              # development
flutter build apk        # Android release
flutter build ios        # iOS release
```

## Aturan Penting
1. Jalankan `flutter analyze` setelah setiap perubahan — harus **No issues found**
2. Jangan akses `MockContent` langsung dari controller atau view — selalu lewat repository
3. Jangan akses `StorageService.instance` langsung dari controller — lewat `CartRepository`
4. Setiap modul baru harus punya: `binding/`, `controllers/`, `views/`
5. Route baru wajib didaftarkan di `app_routes.dart` (Routes + _Paths) DAN `app_pages.dart`
6. Warna baru? Tambahkan ke `app_colors.dart`, jangan hardcode di widget
7. Saat BE sudah siap: buat `Api*Repository`, daftarkan di `AppBinding` gantikan `Mock*Repository`
