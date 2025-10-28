import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storekeeper_app/data/models/product_model.dart';
import 'package:storekeeper_app/presentation/providers/product_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? productToEdit;

  const AddEditProductScreen({super.key, this.productToEdit});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late double _price;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing product data if editing
    if (widget.productToEdit != null) {
      _name = widget.productToEdit!.name;
      _quantity = widget.productToEdit!.quantity;
      _price = widget.productToEdit!.price;
      _imagePath = widget.productToEdit!.imagePath;
    } else {
      // Default values for new product
      _name = '';
      _quantity = 0;
      _price = 0.0;
      _imagePath = null;
    }
  }

  // Helper to capture or pick image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 70, // Good balance for mobile storage
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // Show a dialog for image source selection
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1E88E5)),
              title: const Text('Capture with Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xFF43A047)),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Remove Image'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _imagePath = null;
                  });
                },
              ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  // Handles form submission (Create or Update)
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newProduct = Product(
        id: widget.productToEdit?.id,
        name: _name,
        quantity: _quantity,
        price: _price,
        imagePath: _imagePath,
      );

      final provider = context.read<ProductProvider>();
      bool success = false;

      if (widget.productToEdit == null) {
        // CREATE
        success = await provider.addProduct(newProduct);
      } else {
        // UPDATE
        success = await provider.updateProduct(newProduct);
      }

      if (success) {
        // Navigate back after successful operation
        if (mounted) Navigator.pop(context);
      } else {
        // Show error message (using SnackBar instead of alert)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to save product. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.productToEdit == null ? 'Add New Product' : 'Edit Product'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Product Image Display and Picker
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: _imagePath != null && _imagePath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(),
                          ),
                        )
                      : _buildPlaceholderIcon(),
                ),
              ),
              const SizedBox(height: 24.0),

              // Product Name Field
              TextFormField(
                initialValue: widget.productToEdit?.name,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.inventory_2),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Name cannot be empty' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16.0),

              // Quantity Field
              TextFormField(
                initialValue: widget.productToEdit?.quantity.toString() ?? '0',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity in Stock',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Quantity cannot be empty';
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Enter a valid positive number for quantity';
                  }
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              const SizedBox(height: 16.0),

              // Price Field
              TextFormField(
                initialValue:
                    widget.productToEdit?.price.toStringAsFixed(2) ?? '0.00',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price (\$)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Price cannot be empty';
                  if (double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Enter a valid non-negative price';
                  }
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              const SizedBox(height: 32.0),

              // Save Button
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: Text(
                  widget.productToEdit == null
                      ? 'ADD PRODUCT'
                      : 'UPDATE PRODUCT',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          size: 60,
          color: Colors.grey.shade600,
        ),
        const SizedBox(height: 8),
        Text(
          _imagePath != null
              ? 'Image Error / Tap to Change'
              : 'Tap to Add Image',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
