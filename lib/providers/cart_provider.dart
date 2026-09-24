import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get totalAmount {
    var total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> fetchCartItems() async {
    _items = await DBHelper.instance.getCartItems();
    notifyListeners();
  }

  Future<void> addItem(CartItem item) async {
    await DBHelper.instance.insertCart(item);
    await fetchCartItems();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity <= 0) {
      await removeItem(id);
    } else {
      await DBHelper.instance.updateCartQuantity(id, quantity);
      await fetchCartItems();
    }
  }

  Future<void> removeItem(String id) async {
    await DBHelper.instance.deleteCartItem(id);
    await fetchCartItems();
  }
}