import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductReviewsScreen extends StatelessWidget {
  final int productId;

  ProductReviewsScreen({required this.productId});

  Future<List<dynamic>> fetchReviews() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/$productId'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['reviews'];
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Reviews"),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading reviews", style: TextStyle(color: Colors.red, fontSize: 16)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No reviews available", style: TextStyle(fontSize: 16)));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reviews = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(reviews['reviewerName'][0].toUpperCase(), style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      reviews['reviewerName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        children: [
                          Text(reviews['comment'], style: TextStyle(color: Colors.grey[600])),Text(reviews['date'],style: TextStyle(color: Colors.grey[600]))
                        ],
                      ),
                    ),
                    
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${reviews['rating']} star", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Rating", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}