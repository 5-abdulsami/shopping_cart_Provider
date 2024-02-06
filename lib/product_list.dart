import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:provider_cart/CartProvider.dart';
import 'package:provider_cart/cart_model.dart';
import 'package:provider_cart/cart_screen.dart';
import 'package:provider_cart/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://tse4.mm.bing.net/th?id=OIP.B6ncfVM1AFU3AWJJbyupRgHaFG&pid=Api&P=0&w=300&h=300',
    'https://tse3.mm.bing.net/th?id=OIP.DsdFEw2-2VUE_4Krmzo1agHaFj&pid=Api&P=0&h=180',
    'https://tse4.mm.bing.net/th?id=OIP.ILg_L9WAvlCzKgYJpYZVnAHaE7&pid=Api&P=0&h=180',
    'https://tse4.mm.bing.net/th?id=OIP.lJ56UgUMXm_poLrAjqnWKQHaE8&pid=Api&P=0&h=180',
    'https://tse3.mm.bing.net/th?id=OIP.0ooqvZYhnKuye7MJqP1JAgHaHC&pid=Api&P=0&h=180',
    'https://tse3.mm.bing.net/th?id=OIP.4JpE2JX5Jr1tEGj-FmSP7QHaGz&pid=Api&P=0&h=180',
    'https://tse3.mm.bing.net/th?id=OIP.JeF2KAZviinPMn8Vv62VEQHaHa&pid=Api&P=0&h=180',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => CartScreen())));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(
                                        productImage[index].toString())),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        productUnit[index].toString() +
                                            " " +
                                            r"$" +
                                            productPrice[index].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            dbHelper!
                                                .insert(Cart(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName:
                                                        productName[index]
                                                            .toString(),
                                                    initialPrice:
                                                        productPrice[index],
                                                    productPrice:
                                                        productPrice[index],
                                                    quantity: 1,
                                                    unitTag: productUnit[index]
                                                        .toString(),
                                                    image: productImage[index]
                                                        .toString()))
                                                .then((value) {
                                              cart.incrementCounter();
                                              cart.addTotalPrice(double.parse(
                                                  productPrice[index]
                                                      .toString()));
                                              print(
                                                  'Product Added to Cart Successfully!');
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
