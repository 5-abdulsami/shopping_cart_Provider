import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cart/CartProvider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider_cart/cart_model.dart';
import 'package:provider_cart/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MY Products'),
        centerTitle: true,
        actions: [
          Center(
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
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Image(
                            image: AssetImage('images/empty_cart.webp'),
                            width: 200,
                            height: 200,
                          ),
                          Text(
                            'Explore Products and add to Cart',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 22),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                              height: 100,
                                              width: 100,
                                              image: NetworkImage(snapshot
                                                  .data![index].image
                                                  .toString())),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data![index]
                                                                  .id!);
                                                          cart.decrementCounter();
                                                          cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .productPrice
                                                                .toString()),
                                                          );
                                                        },
                                                        child:
                                                            Icon(Icons.delete)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot.data![index].unitTag
                                                          .toString() +
                                                      " " +
                                                      r"$" +
                                                      snapshot.data![index]
                                                          .productPrice
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                int quantity =
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .quantity!;
                                                                int price = snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!;
                                                                quantity--;
                                                                int? newPrice =
                                                                    quantity *
                                                                        price;

                                                                if (quantity >
                                                                    0) {
                                                                  dbHelper!
                                                                      .updateQuantity(
                                                                    Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productId
                                                                            .toString(),
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName
                                                                            .toString(),
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice,
                                                                        productPrice:
                                                                            newPrice,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag
                                                                            .toString(),
                                                                        image: snapshot
                                                                            .data![index]
                                                                            .image
                                                                            .toString()),
                                                                  )
                                                                      .then(
                                                                          (value) {
                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.removeTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;
                                                                  quantity++;
                                                                  int?
                                                                      newPrice =
                                                                      quantity *
                                                                          price;

                                                                  dbHelper!
                                                                      .updateQuantity(
                                                                    Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productId
                                                                            .toString(),
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName
                                                                            .toString(),
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice,
                                                                        productPrice:
                                                                            newPrice,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag
                                                                            .toString(),
                                                                        image: snapshot
                                                                            .data![index]
                                                                            .image
                                                                            .toString()),
                                                                  )
                                                                      .then(
                                                                          (value) {
                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.addTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
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
                            }));
                  }
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('images/empty_cart.webp'),
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Explore Products',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 22),
                        ),
                      ],
                    ),
                  );
                }
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                  ? false
                  : true,
              child: Card(
                elevation: 15,
                child: Column(
                  children: [
                    ReusableWidget(
                        title: 'Sub Total : ',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    ReusableWidget(
                        title: 'Discount(20%) : ',
                        value: r'$' +
                            ((value.getTotalPrice() * 20) / 100)
                                .toStringAsFixed(2)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                      ),
                      child: ReusableWidget(
                          title: 'Total : ',
                          value: r'$' +
                              ((value.getTotalPrice() -
                                      ((value.getTotalPrice() * 20) / 100))
                                  .toStringAsFixed(2))),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
