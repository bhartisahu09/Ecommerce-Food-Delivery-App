import 'package:delivery_app/screens/cart_screen.dart';
import 'package:delivery_app/screens/forget_password_screen.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/item_details_screen.dart';
import 'package:delivery_app/screens/login_screen.dart' as login;
import 'package:delivery_app/screens/notification_screen.dart';
import 'package:delivery_app/screens/onboarding_screen.dart';
import 'package:delivery_app/screens/order_history_screen.dart';
import 'package:delivery_app/screens/order_success_screen.dart';
import 'package:delivery_app/screens/order_summary_screen.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/screens/signup_screen.dart';
import 'package:delivery_app/screens/splash_screen.dart';
import 'package:delivery_app/screens/thank_you_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'providers/order_provider.dart';
import 'providers/location_provider.dart';
import 'screens/location_screen.dart';
import 'utils/theme.dart';
import 'screens/favorites_screen.dart';
import 'screens/add_address_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Delivery App',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const login.LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/forget-password': (context) => const ForgetPasswordScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/home': (context) => const HomeScreen(),
          '/item-details': (context) => const ItemDetailsScreen(),
          '/cart': (context) => const CartScreen(),
          '/order-summary': (context) => const OrderSummaryScreen(),
          '/order-history': (context) => const OrderHistoryScreen(),
          '/thank-you': (context) => const ThankYouScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/location': (context) => const LocationScreen(),
          '/add-address': (context) => const AddAddressScreen(),
          '/orderHistory': (context) => const OrderHistoryScreen(),
          '/order-success': (context) => const OrderSuccessScreen(),
          '/notifications': (context) => const NotificationScreen(),
          
        },
      ),
    );
  }
}