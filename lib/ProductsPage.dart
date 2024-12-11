import 'package:flutter/material.dart';
import 'package:products_app/database_provider.dart';
import 'package:products_app/product.dart';
import 'package:provider/provider.dart';

TextEditingController cNameController = TextEditingController();
TextEditingController pNameController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController priceController = TextEditingController();

class Productspage extends StatefulWidget {
  const Productspage({super.key});

  @override
  State<Productspage> createState() => _ProductspageState();
}

class _ProductspageState extends State<Productspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text('Products App'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Products',
                style: TextStyle(fontSize: 25),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Product Info'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: pNameController,
                                decoration: InputDecoration(labelText: 'name'),
                              ),
                              TextField(
                                controller: quantityController,
                                decoration:
                                    InputDecoration(labelText: 'quantity'),
                              ),
                              TextField(
                                controller: priceController,
                                decoration: InputDecoration(labelText: 'price'),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                try {
                                  DatabaseProvider.instance.add(Product(
                                      name: pNameController.text,
                                      quantity:
                                          int.parse(quantityController.text),
                                      price:
                                          double.parse(priceController.text)));

                                  pNameController.clear();
                                  quantityController.clear();
                                  priceController.clear();
                                  Navigator.pop(context);
                                } catch (e) {
                                  SnackBar snack = SnackBar(
                                      content: Text(
                                          'please fill all feilds correctly'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                }
                              },
                              child: Text('add')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('cancel')),
                        ],
                      ),
                    );
                  },
                  child: Text('add product')),
            ],
          ),
          Consumer<DatabaseProvider>(
            builder: (context, value, child) {
              return FutureBuilder<List<Product>>(
                future: DatabaseProvider.instance.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> prds = snapshot.data!;
                    if (prds.isEmpty) {
                      return Text(
                        'no Products found',
                        style: TextStyle(fontSize: 25),
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                        itemCount: prds.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.purple[100],
                              leading: Text(prds[index].name),
                              title: Text('quantity: ${prds[index].quantity}'),
                              subtitle: Text('price: ${prds[index].price}'),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete_forever)),
                            ),
                          );
                        },
                      ));
                    }
                  } else if (snapshot.hasError) {
                    return Text('error:  ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
