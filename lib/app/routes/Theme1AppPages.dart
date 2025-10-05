import 'package:get/get.dart' show GetPage, Transition;
import 'package:odda/app/binding/address_binding.dart';
import 'package:odda/app/binding/chat_binding.dart';
import 'package:odda/app/binding/contact_binding.dart';
import 'package:odda/app/binding/detail_review_binding.dart';
import 'package:odda/app/binding/home_binding.dart';
import 'package:odda/app/binding/job_applicants_binding.dart';
import 'package:odda/app/binding/my_orders_binding.dart';
import 'package:odda/app/binding/notification_binding.dart';
import 'package:odda/app/binding/profile_binding.dart';
import 'package:odda/app/binding/search_binding.dart';
import 'package:odda/app/middleware/auth_middleware.dart';
import 'package:odda/app/ui/address/add_address_view.dart';
import 'package:odda/app/ui/address/address_view.dart';
import 'package:odda/app/ui/auth/login_view.dart';
import 'package:odda/app/ui/auth/sign_up_view.dart';
import 'package:odda/app/ui/auth/verification_view.dart';
import 'package:odda/app/ui/cart/cart_view.dart';
import 'package:odda/app/ui/chat/chat_view.dart';
import 'package:odda/app/ui/chat/message_list_view.dart';
import 'package:odda/app/ui/contact/contact_view.dart';
import 'package:odda/app/ui/detail_review/detail_review.dart';
import 'package:odda/app/ui/home/home_view.dart';
import 'package:odda/app/ui/job_appliciants/job_appliciants.dart';
import 'package:odda/app/ui/middle_page/root_view.dart';
import 'package:odda/app/ui/my_account/my_account_view.dart';
import 'package:odda/app/ui/my_orders/my_orders_view.dart';
import 'package:odda/app/ui/my_orders/order_details_view.dart';
import 'package:odda/app/ui/order_report_view.dart';
import 'package:odda/app/ui/profile/edit_profile_view.dart';
import 'package:odda/app/ui/profile/profile_view.dart';
import 'package:odda/app/ui/search/search_view.dart';
import 'package:odda/app/ui/splash/root_view.dart';
import 'package:odda/app/ui/splash/splash_view.dart';
import 'package:odda/app/ui/vendor_products/vendor_products_view.dart';
import 'package:odda/app/ui/wishlist/wishlist_view.dart';

import '../binding/auth_binding.dart';
import '../binding/cart_binding.dart';
import '../binding/category_binding.dart';
import '../binding/message_list_binding.dart';
import '../binding/order_report_binding.dart';
import '../binding/product_binding.dart';
import '../binding/product_detail_binding.dart';
import '../binding/vendor_products_binding.dart';
import '../binding/wishlist_binding.dart';
import '../ui/categories/category_view.dart';
import '../ui/notification/notification_view.dart';
import '../ui/product/product_detail.dart';
import '../ui/product/product_view.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.Root;

  static final routes = [
    GetPage(name: Routes.Root, page: () => const RootView(),),
    GetPage(name: Routes.Middle, page: () => const MiddleView(),middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.Splash, page: () => const SplashView()),
    GetPage(name: Routes.Login, page: () => const LoginView(),binding: AuthBinding()),
    GetPage(name: Routes.SignUpView, page: () => const SignUpView(),binding: AuthBinding()),
    GetPage(name: Routes.Verification, page: () => const VerificationView(),binding: AuthBinding()),
    GetPage(name: Routes.Home, page: () => const HomeView(),binding: HomeBinding()),
    GetPage(name: Routes.Search, page: () => const SearchView(),binding: SearchBinding()),
    GetPage(name: Routes.Category, page: () => CategoryView(),binding: CategoryBinding()),
    GetPage(name: Routes.ProductView, page: () => const ProductView(),binding: ProductBinding()),
    GetPage(name: Routes.ProductDetail, page: () => const ProductDetail(),binding: ProductDetailBinding()),
    GetPage(name: Routes.Cart, page: () => const CartView(),binding: CartBinding()),
    GetPage(name: Routes.Address, page: () => AddressView(),binding: AddressBinding()),
    GetPage(name: Routes.AddAddress, page: () => const AddAddressView(),binding: AddressBinding()),
    GetPage(name: Routes.MyAccount, page: () => const MyAccountView()),
    GetPage(name: Routes.MyOrders, page: () => const MyOrdersView(),binding: MyOrdersBinding()),
    GetPage(name: Routes.OrderDetailsView, page: () => const OrderDetailView(),binding: MyOrdersBinding()),
    GetPage(name: Routes.Profile, page: () => ProfileView(),binding: ProfileBinding()),
    GetPage(name: Routes.EditProfile, page: () => EditProfileView(),binding: ProfileBinding()),
    GetPage(name: Routes.Wishlist, page: () => WishlistView(),binding: WishlistBinding()),
    GetPage(name: Routes.Contact, page: () => ContactView(),binding: ContactBinding()),
    GetPage(name: Routes.Notification, page: () => NotificationView(),binding: NotificationBinding()),
    GetPage(name: Routes.DetailReview, page: () => DetailReview(),binding: DetailReviewBinding()),
    GetPage(name: Routes.ChatView, page: () =>  ChatView(),binding: ChatBinding()),
    GetPage(name: Routes.VendorChats, page: () =>  MessageListView(),binding: MessageListBinding()),
    GetPage(name: Routes.OrderReportView, page: () =>  const OrderReportView(),binding: OrderReportBinding()),
    GetPage(name: Routes.VendorProductsView, page: () =>  const VendorProductView(),binding: VendorProductBinding()),
    GetPage(name: Routes.JobApplicantView, page: () =>  const JobApplicants(),binding: JobApplicantsBinding()),
  ];
}
