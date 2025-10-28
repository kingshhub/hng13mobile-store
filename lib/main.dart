import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/presentation/providers/product_provider.dart';
import 'package:storekeeper_app/presentation/screens/product_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StorekeeperApp());
}

class StorekeeperApp extends StatelessWidget {
  const StorekeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        title: 'Mobile Store Inventory',
        debugShowCheckedModeBanner: false,

        //  Light Theme
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF1976D2),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2),
            brightness: Brightness.light,
          ),
        ),

        //  Dark Theme
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1976D2),
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2),
            brightness: Brightness.dark,
          ),
        ),

        //  Auto-switch based on system settings
        themeMode: ThemeMode.system,

        //  Home Screen
        home: const ProductListScreen(),
      ),
    );
  }
}
