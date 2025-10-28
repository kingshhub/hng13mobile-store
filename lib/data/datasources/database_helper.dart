import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:storekeeper_app/data/models/product_model.dart';
import 'package:storekeeper_app/utils/constants.dart';

// Singleton class to manage the database connection and raw CRUD operations.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DatabaseConstants.databaseName);

    // Open the database or create it if it doesn't exist
    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the products table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseConstants.createTableSQL);
  }

  // Create: Insert a new product into the database
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      DatabaseConstants.tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read: Retrieve all products
  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseConstants.tableProducts);

    // Convert List<Map> to List<Product>
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Updates an existing product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      DatabaseConstants.tableProducts,
      product.toMap(),
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [product.id],
    );
  }

  // Delete: Delete a product by ID
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseConstants.tableProducts,
      where: '${DatabaseConstants.columnId} = ?',
      whereArgs: [id],
    );
  }
}
