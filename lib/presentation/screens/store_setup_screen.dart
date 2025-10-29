import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/presentation/providers/store_provider.dart';
import 'package:storekeeper_app/presentation/screens/product_list_screen.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;

  void _submitStoreName() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      await context
          .read<StoreProvider>()
          .setStoreName(_nameController.text.trim());

      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        // Navigate to the main screen after successful setup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save store name. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store_mall_directory,
                size: 100,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Mobile Store!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s set up your inventory manager.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Store Name',
                    hintText: 'e.g., The Local Grocer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Store name is required.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitStoreName,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        elevation: 5,
                      ),
                      child: const Text(
                        'START MANAGING INVENTORY',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
