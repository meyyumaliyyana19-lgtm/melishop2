import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CartProvider>(context, listen: false).fetchCartItems();
      }
    });
  }

  String _formatRupiah(double number) {
    double realPrice = number;
    if (realPrice > 0 && realPrice < 1000) {
      realPrice = realPrice * 1000;
    }
    int val = realPrice.toInt();
    String formatted = val.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.sanitizer, size: 30, color: Color(0xFFFF2B6D));
    }
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer, size: 30, color: Color(0xFFFF2B6D)));
    }
    final file = File(imageUrl);
    if (file.existsSync()) {
      return Image.file(file, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer, size: 30, color: Color(0xFFFF2B6D)));
    }
    return const Icon(Icons.sanitizer, size: 30, color: Color(0xFFFF2B6D));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: const Color(0xFFFF2B6D),
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang belanja kosong.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final item = cartItems[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImage(item.imageUrl),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(_formatRupiah(item.price * item.quantity)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  cartProvider.updateQuantity(item.id, item.quantity - 1);
                                },
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  cartProvider.updateQuantity(item.id, item.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            _formatRupiah(cartProvider.totalAmount),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF2B6D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur Pembayaran belum siap!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF2B6D),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Checkout', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}