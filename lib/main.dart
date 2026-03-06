import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'genui/ui_registry.dart';
import 'providers/cart_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  UiRegistry.instance.init();
  runApp(const SmartConvenienceApp());
}

class SmartConvenienceApp extends StatelessWidget {
  const SmartConvenienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Convenience',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const ChatScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    // 7-Eleven inspired green + orange palette
    const primaryGreen = Color(0xFF1B7742);
    const tertiaryOrange = Color(0xFFE8702A);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      tertiary: tertiaryOrange,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
