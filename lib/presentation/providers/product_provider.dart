import 'package:flutter/material.dart';
import 'dart:io';

import 'package:storekeeper_app/data/datasources/database_helper.dart';
import 'package:storekeeper_app/data/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Constructor: Load data immediately on initialization
  ProductProvider() {
    loadProducts();
  }

  // READ Operation: Load all products from the database
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _dbHelper.getProducts();
    } catch (e) {
      // Log the error but continue execution
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE Operation: Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      final id = await _dbHelper.insertProduct(product);
      if (id > 0) {
        // Add the new product with its generated ID to the local list
        final newProduct = product.copyWith(id: id);
        _products.add(newProduct);
        _products.sort((a, b) => a.name.compareTo(b.name));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }

  // UPDATE Operation: Edit an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      final count = await _dbHelper.updateProduct(product);
      if (count > 0) {
        // Find and replace the updated product in the local list
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
          _products.sort((a, b) => a.name.compareTo(b.name));
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  // DELETE Operation: Remove a product
  Future<void> deleteProduct(int id, String? imagePath) async {
    try {
      await _dbHelper.deleteProduct(id);

      // Attempt to delete the associated image file from local storage
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Successfully deleted image file: $imagePath');
        }
      }

      // Remove the product from the local list
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }
}
