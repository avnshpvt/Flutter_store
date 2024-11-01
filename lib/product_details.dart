import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_store/editproduct.dart';
import 'package:flutter_store/review.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

 Future<void> fetchProductDetail() async {
  print('Fetching product details for ID: ${widget.productId}');
  final response = await http.get(Uri.parse('https://dummyjson.com/products/${widget.productId}'));

  if (response.statusCode == 200) {
    print('Product details fetched successfully: ${response.body}');
    setState(() {
      product = json.decode(response.body);
      isLoading = false;
    });
  } else {
    print('Failed to fetch product details: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load product');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
  IconButton(
    icon: Icon(Icons.edit, color: Colors.black),
    onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProductScreen(
        productId: widget.productId,
        currentTitle: product?['title'] ?? '',
        currentPrice: product?['price'] ?? 0.0,
        currentDescription: product?['description'] ?? '',
      ),
    ),
  );

  if (result == true) {
    fetchProductDetail(); 
  }
},
  ),
],
      ),
      backgroundColor: Color.fromARGB(255, 254, 252, 252),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 120,
                            backgroundColor: Color.fromARGB(255, 245, 211, 211),
                            backgroundImage: NetworkImage(product?['thumbnail'] ?? ''),
                          ),
                          Positioned(
                            right: -66,
                            top: 50,
                            child: Column(
                              children: (product?['images'] as List<dynamic>)
                                  .take(3)
                                  .map((imageUrl) => ColorOption(iconUrl: imageUrl))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "\$${product?['price']?.toStringAsFixed(2) ?? '0.00'}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          product?['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (product?['category'] != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product!['category'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(product!['availabilityStatus'],style: TextStyle(color: Colors.orangeAccent),),
                    SizedBox(height: 8),
                    Text(
                      "About the item",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Full Specification"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.blue[100],
                          ),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductReviewsScreen(productId: widget.productId),
                              ),
                            );
                          },
                          child: Text("Reviews"),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      product?['description'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.storefront, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Aghmashenebeli Ave 75",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "1 Item is in the way",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.indigoAccent[100],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 28),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.shopping_cart),
          label: Text("ADD TO CART"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo[900],
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}



class ColorOption extends StatelessWidget {
  final String iconUrl;

  ColorOption({required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Colors.grey[300],
        backgroundImage: NetworkImage(iconUrl),
      ),
    );
  }
}
