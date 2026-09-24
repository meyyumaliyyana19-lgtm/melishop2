import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/produk.dart';

class ProductProvider with ChangeNotifier {
  List<Produk> _products = [];

  List<Produk> get products => [..._products];
  List<Produk> get items => [..._products];

  Produk findById(String id) {
    return _products.firstWhere(
      (prod) => prod.id == id,
      orElse: () => Produk(
        id: '',
        name: 'Produk Tidak Ditemukan',
        price: 0,
        description: '',
        imageUrl: '',
      ),
    );
  }

  Future<void> fetchProducts() async {
    try {
      _products = await DBHelper.instance.getProducts();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch: $e");
    }
  }

  Future<void> fetchAndSetProducts() async {
    await fetchProducts();
  }

  Future<void> addProduct(Produk product) async {
    await DBHelper.instance.insertProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Produk product) async {
    await DBHelper.instance.updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(String id) async {
    await DBHelper.instance.deleteProduct(id);
    await fetchProducts();
  }
}