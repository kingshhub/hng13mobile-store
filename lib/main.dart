import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/presentation/providers/product_provider.dart';
import 'package:storekeeper_app/presentation/providers/store_provider.dart';
import 'package:storekeeper_app/presentation/screens/product_list_screen.dart';
import 'package:storekeeper_app/presentation/screens/store_setup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StorekeeperApp());
}

class StorekeeperApp extends StatelessWidget {
  const StorekeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()..loadStoreName()),
      ],
      child: MaterialApp(
        title: 'Mobile Store Inventory',
        debugShowCheckedModeBanner: false,
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
        themeMode: ThemeMode.system,
        routes: {
          '/': (context) => Consumer<StoreProvider>(
                builder: (context, storeProvider, _) {
                  if (!storeProvider.isInitialized) {
                    return const Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }
                  if (storeProvider.storeName == null) {
                    return const StoreSetupScreen();
                  }
                  return const ProductListScreen();
                },
              ),
          '/store-setup': (context) => const StoreSetupScreen(),
        },
      ),
    );
  }
}
