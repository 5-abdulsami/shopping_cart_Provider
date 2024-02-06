import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cart/CartProvider.dart';
import 'package:provider_cart/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shopping Cart',
            theme: ThemeData(primarySwatch: Colors.teal),
            home: ProductListScreen(),
          );
        },
      ),
    );
  }
}
