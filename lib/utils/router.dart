import 'package:naga_exchange/bindings/email_verification_binding.dart';
import 'package:naga_exchange/bindings/home_binding.dart';
import 'package:naga_exchange/bindings/market_detail_binding.dart';
import 'package:naga_exchange/bindings/notification_screen_binding.dart';
import 'package:naga_exchange/bindings/otp_binding.dart';
import 'package:naga_exchange/bindings/security_binding.dart';
import 'package:naga_exchange/bindings/swap_history_binding.dart';
import 'package:naga_exchange/bindings/verification_binding.dart';
import 'package:naga_exchange/bindings/wallet_search_binding.dart';
import 'package:naga_exchange/views/DetailCryptoValue/market_detail.dart';
import 'package:naga_exchange/views/history/history.dart';
import 'package:naga_exchange/views/home/splash.dart';
import 'package:naga_exchange/views/home/on_boarding.dart';
import 'package:naga_exchange/views/auth/email_verification.dart';
import 'package:naga_exchange/views/auth/login.dart';
import 'package:naga_exchange/views/auth/2fa.dart';
import 'package:naga_exchange/views/auth/signup.dart';
import 'package:naga_exchange/views/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:naga_exchange/views/notification/notification_list.dart';
import 'package:naga_exchange/views/security/enable_otp.dart';
import 'package:naga_exchange/views/security/security.dart';
import 'package:naga_exchange/views/setting/setting.dart';
import 'package:naga_exchange/views/swap/swap.dart';
import 'package:naga_exchange/views/swap/swap_histroy.dart';
import 'package:naga_exchange/views/verification/verification.dart';
import 'package:naga_exchange/views/verification/verification_level.dart';
import 'package:naga_exchange/views/wallet/deposit/crypto.dart';
import 'package:naga_exchange/views/wallet/wallet_detail.dart';
import 'package:naga_exchange/views/wallet/wallet_search.dart';
import 'package:naga_exchange/views/wallet/withdraw/crypto.dart';
import 'package:get/get.dart';

class Router {
  static final route = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      // binding: SplashScreenBinding(),
    ),
    GetPage(
      name: '/on_boarding',
      page: () => OnBoarding(),
    ),
    GetPage(
      name: '/login',
      page: () => Login(),
    ),
    GetPage(
      name: '/2fa',
      page: () => TwoFA(),
    ),
    GetPage(
      name: '/register',
      page: () => SignUp(),
    ),
    GetPage(
      name: '/settings',
      page: () => Setting(),
    ),
    GetPage(
        name: '/security', page: () => Security(), binding: SecurityBinding()),
    GetPage(
        name: '/enable-otp', page: () => EnableOTP(), binding: OTPBinding()),
    GetPage(
        name: '/notifications',
        page: () => NotificationList(),
        binding: NotificationScreenBinding()),
    GetPage(
        name: '/email-verification',
        page: () => EmailVerification(),
        binding: EmailVerificationBinding()),
    GetPage(
      name: '/home',
      page: () => BottomNavBar(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/trading',
      page: () => BottomNavBar(),
      // binding: TradingBinding(),
    ),
    GetPage(
      name: '/wallets',
      page: () => BottomNavBar(),
    ),
    GetPage(
      name: '/wallet-detail',
      page: () => WalletDetail(),
    ),
    GetPage(
      name: '/deposit-crypto',
      page: () => DepositCrypto(),
    ),
    GetPage(
      name: '/withdrawl-crypto',
      page: () => WithdrawCrypto(),
    ),
    GetPage(
        name: '/wallets-search',
        page: () => WalletSearch(),
        binding: WalletSearchBinding()),
    GetPage(
      name: '/market-detail',
      page: () => MarketDetail(),
      binding: MarketDetailBinding(),
    ),
    GetPage(
      name: '/swap',
      page: () => Swap(),
      // binding: SwapBinding(),
    ),
    GetPage(
      name: '/swap-history',
      page: () => SwapHistory(),
      binding: SwapHistoryBinding(),
    ),
    GetPage(
      name: '/verification-level',
      page: () => VerificationLevel(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: '/profile-verification',
      page: () => Verification(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: '/history',
      page: () => History(),
    ),
  ];
}
