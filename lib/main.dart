import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_app/JSONWebServer/products.dart';

void main() => runApp(MyApp(products: fetchProducts()));

List<Product> parseProducts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromMap(json)).toList();
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://192.168.12.19:8000/products.json'));
  if (response.statusCode == 200) {
    return parseProducts(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

class MyApp extends StatelessWidget {
  final Future<List<Product>>? products; // Added '?' for default value
  const MyApp({Key? key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Product Navigation demo home page',
        products: products, // Use the products parameter
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Future<List<Product>>? products; // Added '?' for default value
  const MyHomePage({Key? key, required this.title, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Navigation")),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.hasError) if (kDebugMode) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? ProductBoxList(
                    items: snapshot.data!) // Use '!' to ensure non-null value
                : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ProductBoxList extends StatelessWidget {
  final List<Product> items;
  const ProductBoxList({Key? key, required this .items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ProductBox(item: items[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(item: items[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key, required this.item}) : super(key: key);
  final Product item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset("assets/appimages/${item.image}"),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(item.description),
                      Text("Price: ${item.price}"),
                      const RatingBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RatingBox extends StatefulWidget {
  const RatingBox({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  int _rating = 0;

  void _setRatingAsOne() {
    setState(() {
      _rating = 1;
    });
  }

  void _setRatingAsTwo() {
    setState(() {
      _rating = 2;
    });
  }

  void _setRatingAsThree() {
    setState(() {
      _rating = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 20;
    if (kDebugMode) {
      print(_rating);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            icon: (_rating >= 1
                ? Icon(
                    Icons.star,
                    size: size,
                  )
                : Icon(
                    Icons.star_border,
                    size: size,
                  )),
            color: Colors.red[500],
            onPressed: _setRatingAsOne,
            iconSize: size,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            icon: (_rating >= 2
                ? Icon(
                    Icons.star,
                    size: size,
                  )
                : Icon(
                    Icons.star_border,
                    size: size,
                  )),
            color: Colors.red[500],
            onPressed: _setRatingAsTwo,
            iconSize: size,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            icon: (_rating >= 3
                ? Icon(
                    Icons.star,
                    size: size,
                  )
                : Icon(
                    Icons.star_border,
                    size: size,
                  )),
            color: Colors.red[500],
            onPressed: _setRatingAsThree,
            iconSize: size,
          ),
        ),
      ],
    );
  }
}

class ProductBox extends StatelessWidget {
  const ProductBox({Key? key, required this.item}) : super(key: key);
  final Product item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 140,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("assets/appimages/${item.image}"),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item.description),
                    Text("Price: ${item.price}"),
                    const RatingBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
