import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produk.dart';
import '../models/cart_item.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kasir.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image_url TEXT
      )
    ''');
  }

  // === OPERATIONS UNTUK PRODUK ===
  Future<List<Produk>> getProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) => Produk.fromMap(json)).toList();
  }

  Future<int> insertProduct(Produk product) async {
    final db = await instance.database;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProduct(Produk product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // === OPERATIONS UNTUK KERANJANG ===
  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final result = await db.query('cart');
    return result.map((json) => CartItem.fromMap(json)).toList();
  }

  Future<int> insertCart(CartItem item) async {
    final db = await instance.database;
    return await db.insert(
      'cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCartQuantity(String id, int quantity) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(String id) async {
    final db = await instance.database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}