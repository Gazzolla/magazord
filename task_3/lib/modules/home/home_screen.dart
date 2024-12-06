import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:task_3/modules/home/home_store.dart';
import 'package:task_3/modules/product/product_screen.dart';
import 'package:task_3/shared/models/products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final FormControl searchControl = FormControl();
    HomeController controller = HomeController();

    return Scaffold(
      backgroundColor: Color(0xffe9ebea),
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ReactiveTextField(
                    onChanged: (control) {
                      controller.setSearch(control.value);
                    },
                    formControl: searchControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: "Pesquisar...",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: InkWell(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: InkWell(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            "1",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    "https://mezmoveis.cdn.magazord.com.br/img/2024/11/banner/1945/banner-02.png",
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) => SizedBox(),
                  ),
                  Observer(
                    builder: (_) {
                      return Column(
                        children: [
                          for (Product product in controller.products)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  if (product.images.isNotEmpty)
                                    Observer(builder: (_) {
                                      return Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.memory(
                                                base64Decode(product.actualImage),
                                                fit: BoxFit.scaleDown,
                                                height: 300,
                                              ),
                                            ],
                                          ),
                                          if (product.base64Images.length > 1)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    for (String image in product.base64Images)
                                                      InkWell(
                                                        onTap: () {
                                                          product.setImage(image);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          child: Container(
                                                            padding: EdgeInsets.all(2),
                                                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
                                                            width: 50,
                                                            child: Image.memory(
                                                              base64Decode(image),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      );
                                    }),
                                  Text(
                                    product.title,
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    "R\$ ${product.price.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      "Detalhes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
