import 'package:eshop/features/auth/login/login.dart';
import 'package:eshop/features/products/bloc/product_bloc.dart';
import 'package:eshop/features/products/models.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:eshop/theming.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
  }

  List<String> dataList = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape'
  ];

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
              return const SizedBox();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
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
                        color: Colors.black,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(.5),
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.category,
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
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.8,
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
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      product.name!,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight
                                              .bold), // Reduced font size
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                      product.description ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.0), // Reduced font size
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Original Price: TSH ${product.price}', // Assuming 'originalPrice' is a field in your product model
                                        style: TextStyle(
                                          fontSize: 10.0, // Reduced font size
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      if (product.discountPrice != null &&
                                          product.discountPrice !=
                                              0) // Check if discount is not null or zero
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text(
                                            'Discount: ${product.discountPrice}%', // Assuming 'discount' is a field in your product model
                                            style: TextStyle(
                                              fontSize:
                                                  10.0, // Reduced font size
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 10.0),
                                        child: Text(
                                          'Current Price: TSH ${product.price}', // Assuming 'price' is a field in your product model
                                          style: TextStyle(
                                            fontSize: 10.0, // Reduced font size
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
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

    return ListView(
      children: results!
          .map((result) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(result.name!)),
                );
              },
              child: ListTile(title: Text(result!.name!))))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = dataList?.where((element) =>
        element!.name!.toLowerCase().startsWith(query.toLowerCase()));

    return ListView(
      children: suggestions!
          .map((suggestion) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(suggestion!.name!)),
                );
              },
              child: ListTile(title: Text(suggestion!.name!))))
          .toList(),
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
