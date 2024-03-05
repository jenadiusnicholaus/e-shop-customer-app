import 'package:eshop/features/auth/login/login.dart';
import 'package:eshop/features/products/bloc/product_bloc.dart';
import 'package:eshop/features/products/models.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:eshop/theming.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  String? token = 'jlll';
  runApp(MyApp(token: token));
}

class MyApp extends StatefulWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProductRepository(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(),
            ),
            BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(
                repository: context.read<ProductRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: widget.token != ''
                ? const MyHomePage(title: 'eshop')
                : const LoginPage(),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      var state = context.read<ProductBloc>().state;
      if (state is ProductsLoaded) {
        if (state.products.next != null) {
          context.read<ProductBloc>().add(FetchProducts(
                pageNo: state.products.next!.split('=')[1],
              ));
        }
      }
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      var state = context.read<ProductBloc>().state;
      if (state is ProductsLoaded) {
        if (state.products.previous != null) {
          var previousPage = state.products.previous?.split('=');
          context.read<ProductBloc>().add(FetchProducts(
                pageNo: (previousPage != null && previousPage.length > 1)
                    ? previousPage[1]
                    : '1',
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoaded) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(state.products.results),
                    );
                  },
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(.2),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.category_rounded,
                            size: 30, // IconThemeData
                            color: Theme.of(context).iconTheme.color),
                        title: Text('Item $index',
                            style: Theme.of(context).textTheme.headlineMedium),
                        subtitle: Text('Item $index',
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductsLoaded) {
                      return GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: state.products.results!.length,
                        itemBuilder: (context, index) {
                          var product = state.products.results![index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(product.name!),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Image.network(
                                      product.image ??
                                          'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        product.name!,
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      product.description ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          ' TSH ', // Assuming 'originalPrice' is a field in your product model
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight
                                                .bold, // Reduced font size
                                          ),
                                        ),
                                        Text(
                                          ' ${product.price}', // Assuming 'originalPrice' is a field in your product model
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight
                                                .bold, // Reduced font size
                                            decoration: (product
                                                            .discountPrice !=
                                                        null &&
                                                    product.discountPrice != 0)
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (product.discountPrice != null &&
                                      product.discountPrice !=
                                          0) // Check if discount is not null or zero
                                    if (product.discountPrice != null &&
                                        product.discountPrice !=
                                            0) // Check if discount is not null or zero
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          'Discount: ${product.discountPrice}%', // Assuming 'discount' is a field in your product model
                                          style: const TextStyle(
                                            fontSize: 10.0, // Reduced font size
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Free delivery', // Assuming 'originalPrice' is a field in your product model
                                          style: TextStyle(
                                            fontSize: 8.0,
                                            fontWeight: FontWeight
                                                .bold, // Reduced font size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ProductsError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Results?>? dataList;

  CustomSearchDelegate(this.dataList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = dataList?.where((element) =>
        element!.name!.toLowerCase().contains(query.toLowerCase()));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        itemCount: results!.length,
        itemBuilder: (context, index) {
          var result = results.elementAt(index);
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(result!.name!),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Image.network(
                      result!.image ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      result.description ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        const Text(
                          ' TSH ', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                          ),
                        ),
                        Text(
                          ' ${result.price}', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                            decoration: (result.discountPrice != null &&
                                    result.discountPrice != 0)
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (result.discountPrice != null &&
                      result.discountPrice !=
                          0) // Check if discount is not null or zero
                    if (result.discountPrice != null &&
                        result.discountPrice !=
                            0) // Check if discount is not null or zero
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Discount: ${result.discountPrice}%', // Assuming 'discount' is a field in your product model
                          style: const TextStyle(
                            fontSize: 10.0, // Reduced font size
                            color: Colors.red,
                          ),
                        ),
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Free delivery', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 8.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ... other widgets ...
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = dataList?.where((element) =>
        element!.name!.toLowerCase().startsWith(query.toLowerCase()));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          var suggestion = suggestions.elementAt(index);
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(suggestion!.name!),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AspectRatio(
                  //   aspectRatio: 1.5,
                  //   child: Image.network(
                  //     suggestion!.image ?? 'https://via.placeholder.com/150',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(5.0),
                  //   child: Text(
                  //     suggestion!.name!,
                  //     style:
                  //         TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Image.network(
                      suggestion!.image ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      suggestion.description ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        const Text(
                          ' TSH ', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                          ),
                        ),
                        Text(
                          ' ${suggestion.price}', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                            decoration: (suggestion.discountPrice != null &&
                                    suggestion.discountPrice != 0)
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (suggestion.discountPrice != null &&
                      suggestion.discountPrice !=
                          0) // Check if discount is not null or zero
                    if (suggestion.discountPrice != null &&
                        suggestion.discountPrice !=
                            0) // Check if discount is not null or zero
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Discount: ${suggestion.discountPrice}%', // Assuming 'discount' is a field in your product model
                          style: const TextStyle(
                            fontSize: 10.0, // Reduced font size
                            color: Colors.red,
                          ),
                        ),
                      ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Free delivery', // Assuming 'originalPrice' is a field in your product model
                          style: TextStyle(
                            fontSize: 8.0,
                            fontWeight: FontWeight.bold, // Reduced font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String item;

  const DetailsPage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Text('You selected: $item'),
      ),
    );
  }
}
