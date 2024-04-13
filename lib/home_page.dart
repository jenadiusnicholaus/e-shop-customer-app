import 'dart:async';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/products/models/product_model.dart';
import 'package:eshop/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:eshop/shared/environments/environment.dart';
import 'package:eshop/shared/utils/secure_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marquee/marquee.dart';

import 'features/auth/login/login.dart';
import 'features/categories/category_model.dart' as CategoryModel;
import 'features/products/product_details_page.dart';
import 'features/shopping_cart/shopping_cart.dart';
import 'shared/environments/navigationn_state.dart';

const List<String> scopes = <String>[
  'email',
  // 'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  static const _pageSize = 5;
  final _pagingController = PagingController<int, Results>(
    firstPageKey: 0,
  );
  final _categoryPagingController =
      PagingController<int, CategoryModel.Results>(
    firstPageKey: 0,
  );
  late final PageController _controller;
  dynamic selectedCategory = "all";

  final Environment environment = Environment.instance;

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  void initState() {
    NavigationState.homepage;
    _categoryPagingController.addPageRequestListener((pageKey) {
      _fetchCategories(pageKey);
    });

    context.read<ShoppingCartBloc>().add(GetCartItems());
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      fetchProducts(pageKey, selectedCategory);
    });

    super.initState();
  }

  Future<void> _fetchCategories(int pageKey) async {
    try {
      var dio = Dio();
      var url = '${environment.getBaseUrl}${environment.category_list_sub_url}';
      var response = await dio.request(
        '$url?_start=$pageKey&_limit=10',
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        final newItems = (response.data['results'] as List)
            .map((i) => CategoryModel.Results.fromJson(i))
            .toList();

        final nextPageKey = newItems.isEmpty ? null : pageKey + newItems.length;

        _categoryPagingController.appendPage(newItems, nextPageKey);
      } else {
        _categoryPagingController.error = response.statusMessage;
      }
    } catch (error) {
      _categoryPagingController.error = error;
    }
  }

  Future<void> fetchProducts(int pageKey, dynamic category) async {
    try {
      var dio = Dio();
      var url =
          '${environment.getBaseUrl}${environment.all_products_sub_url}?_start=$pageKey&_limit=$_pageSize&category=$category';
      var response = await dio.request(
        url,
        options: Options(
          method: 'GET',
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
    } catch (e, s) {
      log('error', error: e, stackTrace: s);
      _pagingController.error = Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Cartopia'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: const Text('Shopping Cart'),
              onTap: () {
                NavigationState.cartpage;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartPage(),
                  ),
                );
              },
            ),

            // logout
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await _handleSignOut();
                SecureLocalStorage.deleteValue('access_token');
                SecureLocalStorage.deleteValue('refresh_token');
                // goto login page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () {
            setState(() {
              selectedCategory = "all";
            });
            ;

            _pagingController.refresh();
          },
        ),
        child: CustomScrollView(
          // controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              title: Text(user?.displayName ?? ''),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(_pagingController),
                    );
                  },
                ),
              ],
              floating: false,
              pinned: true,
              snap: false,
              elevation: 10.0,
              shadowColor: Colors.black45,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),

              //pinned to the top
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: GestureDetector(
                  onTap: () {},
                  child: const ImageSliders(),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(
                    60.0), // Set this to your desired height
                child: Container(
                  height: 32.h,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 10.0),
                  child: PagedListView<int, CategoryModel.Results>(
                    scrollDirection: Axis.horizontal,
                    pagingController: _categoryPagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<CategoryModel.Results>(
                      itemBuilder: (context, item, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = 'all';
                              });
                              _pagingController.refresh();
                            },
                            child: Chip(
                              backgroundColor: selectedCategory == 'all'
                                  ? Colors.red
                                  : null, // Highlight if selected
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              avatar: const Icon(
                                Icons.category,
                                color: Colors.amber,
                              ),
                              label: Text('All',
                                  style: selectedCategory == 'all'
                                      ? TextStyle(color: Colors.white)
                                      : null),
                            ),
                          );
                        }
                        return Container(
                          width: 120.w,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = item.id;
                              });
                              _pagingController.refresh();
                            },
                            child: Chip(
                                backgroundColor: selectedCategory == item.id
                                    ? Colors.red
                                    : null, // Highlight if selected
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                label: Marquee(
                                  text: item.name ?? '',
                                  style: selectedCategory == item.id
                                      ? TextStyle(color: Colors.white)
                                      : null,
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 20.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            PagedSliverGrid<int, Results>(
              pagingController: _pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.9,
              ),
              builderDelegate: PagedChildBuilderDelegate<Results>(
                itemBuilder: (context, product, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ProductItems(product: product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
      ),
    );
  }
}

class ProductGridViewWidget extends StatelessWidget {
  final PagingController<int, Results> pagingController;

  const ProductGridViewWidget(this.pagingController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
        NavigationState.productDetailspage;
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                product.image ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
            // Flexible(
            //   child: Text(
            //     product.name ?? '',
            //     style: const TextStyle(
            //         fontSize: 10.0, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Text(
              product.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.0),
            ),
            if (product.discountPrice != null && product.discountPrice != 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TZS ${product.sellingPrice}',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      '${product.discountPrice}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                'TZS ${product.sellingPrice}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageSliders extends StatefulWidget {
  const ImageSliders({super.key});

  @override
  State<ImageSliders> createState() => _ImageSlidersState();
}

class _ImageSlidersState extends State<ImageSliders> {
  final List<String>? imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList!
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'No. ${imgList!.indexOf(item)} image',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Scaffold(
      body: Container(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 1.8,
            enlargeCenterPage: true,
          ),
          items: imageSliders,
        ),
      ),
    );
  }
}
