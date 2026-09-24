import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produk.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import 'edit_product_screen.dart';

class DetailProductScreen extends StatelessWidget {
  final Produk product;

  const DetailProductScreen({super.key, required this.product});

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
      return const Icon(Icons.sanitizer, size: 80, color: Color(0xFFFF2B6D));
    }
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer, size: 80, color: Color(0xFFFF2B6D)));
    }
    final file = File(imageUrl);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.sanitizer, size: 80, color: Color(0xFFFF2B6D)));
    }
    return const Icon(Icons.sanitizer, size: 80, color: Color(0xFFFF2B6D));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: const Color(0xFFFF2B6D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: _buildImage(product.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatRupiah(product.price),
                    style: const TextStyle(fontSize: 18, color: Color(0xFFFF2B6D), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description.isEmpty ? 'Tidak ada deskripsi.' : product.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      final cartItem = CartItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        productId: product.id,
                        name: product.name,
                        price: product.price,
                        quantity: 1,
                        imageUrl: product.imageUrl,
                      );
                      Provider.of<CartProvider>(context, listen: false).addItem(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Berhasil ditambahkan ke keranjang!')),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF2B6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}