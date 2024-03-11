import 'package:dio/dio.dart';
import 'package:eshop/features/products/models/product_model.dart';
import 'package:eshop/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:eshop/shared/environments/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'features/products/product_details_page.dart';
import 'features/shopping_cart/shopping_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 10;
  final _pagingController = PagingController<int, Results>(
    firstPageKey: 0,
  );
  final Environment environment = Environment.instance;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchProducts(pageKey);
    });
  }

  Future<void> fetchProducts(int pageKey) async {
    try {
      var headers = {'Cookie': 'sessionid=e1cpz4p1cnb8puq6xuxyytjydmfofyrv'};
      var dio = Dio();
      var url =
          '${environment.getBaseUrl}${environment.all_products_sub_url}?_start=$pageKey&_limit=$_pageSize';
      var response = await dio.request(
        url,
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<Results> postList = (response.data['results'] as List)
            .map((i) => Results.fromJson(i))
            .toList();

        final isLastPage = postList.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(postList);
        } else {
          // Increment the nextPageKey by the page size
          final nextPageKey = pageKey + postList.length;
          _pagingController.appendPage(postList, nextPageKey);
        }
      } else {
        _pagingController.error = Exception('Failed to load album');
      }
    } catch (e) {
      _pagingController.error = Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Eshop"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(_pagingController),
                );
              },
            ),
          ],
        ),
        body: ProductGridViewWidget(_pagingController),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingCartPage(),
              ),
            );
          },
          child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
            builder: (context, state) {
              if (state is ShoppingCartLoaded) {
                final cartItems = state.cartItems;
                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartItems.isNotEmpty)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cartItems.length.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const Icon(Icons.shopping_cart);
            },
          ),
        ));
  }
}

class ProductGridViewWidget extends StatelessWidget {
  final PagingController<int, Results> pagingController;

  const ProductGridViewWidget(this.pagingController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                pagingController.refresh();
              },
              child: PagedGridView<int, Results>(
                pagingController: pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.9,
                ),
                builderDelegate: PagedChildBuilderDelegate<Results>(
                  itemBuilder: (context, product, index) {
                    return ProductItems(product: product);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<Results> {
  final PagingController<int, Results> pagingController;

  ProductSearchDelegate(this.pagingController);

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
        close(context, Results());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = pagingController.itemList
        ?.where((product) =>
            product.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results != null && results.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              var suggestion = results.elementAt(index);
              return ProductItems(product: suggestion);
            },
          )
        : Center(child: Text('No results found'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pagingController.itemList
        ?.where((product) =>
            product.name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return suggestions != null && suggestions.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8,
            ),
            itemCount: suggestions!.length,
            itemBuilder: (context, index) {
              var suggestion = suggestions.elementAt(index);
              return ProductItems(product: suggestion);
            },
          )
        : const Center(child: Text('No suggestions'));
  }
}

class ProductItems extends StatelessWidget {
  final Results product;
  const ProductItems({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsDetailsPage(product),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                product.image ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Text(
                product.name ?? '',
                style: const TextStyle(
                    fontSize: 10.0, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              product.description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              'TZS ${product.price}',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                decoration: (product.discountPrice != null &&
                        product.discountPrice != 0)
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            if (product.discountPrice != null && product.discountPrice != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'Discount: ${product.discountPrice}',
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
