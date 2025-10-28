class DatabaseConstants {
  static const String databaseName = 'product_inventory.db';
  static const int databaseVersion = 1;

  // Table and column names
  static const String tableProducts = 'products';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnQuantity = 'quantity';
  static const String columnPrice = 'price';
  static const String columnImagePath = 'imagePath';

  // SQL Statement to create the table
  static const String createTableSQL = '''
    CREATE TABLE $tableProducts(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnQuantity INTEGER NOT NULL,
      $columnPrice REAL NOT NULL,
      $columnImagePath TEXT
    )
  ''';
}
