import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:task_3/shared/models/products.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Observer(builder: (_) {
                  return Image.memory(
                    base64Decode(product.actualImage),
                    fit: BoxFit.scaleDown,
                    height: MediaQuery.of(context).size.height * .4,
                  );
                }),
                if (product.base64Images.length > 1)
                  Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (String image in product.base64Images)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    product.setImage(image);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Observer(builder: (_) {
                                      return Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(5),
                                          border: product.actualImage == image ? Border.all(color: Colors.blue) : null,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Image.memory(
                                          base64Decode(image),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              )
                          ],
                        )),
                  ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 32),
                          Text(
                            product.rating.toStringAsFixed(0),
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        product.title,
                        style: TextStyle(fontSize: 32),
                      ),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Tooltip(
                            message: "Não desenvolvido",
                            triggerMode: TooltipTriggerMode.tap,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Adicionar ao Carrinho",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
