import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled/productDescription.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  final url = Uri.parse("https://dummyjson.com/products");

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['products'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Products",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            Text("Super Summer Sale",style: TextStyle(fontSize: 13,color: Colors.grey),)
          ],
        ),

      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text('Failed to load products. Please try again.'),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final products = snapshot.data!;

            if (products.isEmpty) {
              return const Center(child: Text('No products available'));
            }
            return ListView.builder(

              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final discount= product['discountPercentage'];
                List<dynamic> urls= product['images'];
                String imgurl= urls[0].toString();
                double newPrice = product['price']-product['price']*1/100;
                return InkWell(
                  onTap: () {
                    // Define the action when the tile is clicked
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductDescription(imgurl, product['category'], product['description'], product['title'],newPrice,product['rating'])));
                    // You can navigate to a new screen or show more details here
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Image takes half of the row
                          Stack(
                            children:[ Image.network(
                              product['thumbnail'], // Assuming 'thumbnail' is the image URL
                              width: 100, // Adjust width and height based on your design
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Container(

                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text("-${discount}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                              ),

                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red),
                              margin: EdgeInsets.all(7),
                            )]

                          ),
                          const SizedBox(width: 16), // Space between image and text
                          // Text takes the other half
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBar.readOnly(
                                      size: 25,
                                      filledIcon: Icons.star,
                                      emptyIcon: Icons.star_border,
                                      initialRating: product['rating'],
                                      maxRating: 5,
                                    ),
                                    Text("(${product['rating']})")
                                  ],
                                ),
                                Text(
                                  product['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Row(

                                  children: [
                                    Text(
                                      '${product['price']}\$',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${newPrice.toStringAsFixed(2)}\$",
                                      style: TextStyle(color: Colors.red),),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.redAccent,
        unselectedLabelStyle: TextStyle(color:Colors.grey),

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),

        ],
        currentIndex: 1,


      ),
    );
  }
}
