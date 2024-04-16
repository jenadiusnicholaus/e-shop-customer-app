import 'package:eshop/features/products/models/product_model.dart';
import 'package:eshop/features/shopping_cart/shopping_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/environments/environment.dart';
import '../shopping_cart/bloc/shopping_cart_bloc.dart';
import 'bloc/product_bloc.dart';
import 'models/prodict_details_model.dart';
import 'package:intl/intl.dart';

class ProductsDetailsPage extends StatefulWidget {
  final Results product;

  const ProductsDetailsPage(this.product, {super.key});

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  late ScrollController _scrollController;
  bool _showPriceInAppBar = false;
  String? selectedColorCode;
  bool colorSelected = false;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(FetchProductDetails(productId: widget.product.id));

    _scrollController = ScrollController()..addListener(_scrollListener);
    context.read<ShoppingCartBloc>().add(GetCartItems());
  }

  Widget buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Divider(),
        for (var item in items)
          ListTile(
            title: Text(item),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildColorSection(String title, List<String> colorCodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Divider(
          color: !colorSelected ? Colors.red : Colors.grey,
        ),
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                spacing: 10,
                children: colorCodes.map((colorCode) {
                  final color = Color(
                      int.parse(colorCode.substring(1, 7), radix: 16) +
                          0xFF000000);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorSelected = true;
                        selectedColorCode = colorCode;
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColorCode == colorCode
                            ? Border.all(width: 2, color: Colors.black)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
                right: 0,
                child: Text(
                  colorSelected ? '' : 'Select product color',
                  style: const TextStyle(color: Colors.red, fontSize: 12.0),
                ))
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSpecSection(String title, List<ProductSpecifications> specs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Specifications'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: specs.length,
                    // separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${specs[index].specName!}:",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                specs[index].specValue!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        // const Divider()
      ],
    );
  }

  Widget buildSizeSection(String title, List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Divider(),
        Wrap(
          spacing: 10,
          children: sizes.map((size) {
            return Chip(
              label: Text(size),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildImageSection(String title, List<String> imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const Divider(),
        Container(
          height: 80, // Reduced height
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding:
                            EdgeInsets.zero, // Make dialog cover entire screen
                        child: Stack(
                          alignment: Alignment
                              .topRight, // Align close button to top right
                          children: [
                            Image.network(
                              Environment.environmentType ==
                                      EnvironmentType.remote_dev
                                  ? imageUrls[index]
                                  : Environment.IMAGE_URL + imageUrls[index],
                              fit: BoxFit.contain,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                      0.5), // Semi-transparent black
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: Environment.environmentType ==
                            EnvironmentType.remote_dev
                        ? imageUrls[index]
                        : Environment.IMAGE_URL + imageUrls[index],
                    fit: BoxFit.cover,
                    width: 100, // Reduced width
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildReviewSection(String title, List<ProductReviews> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${reviews.length})',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Divider(),
        Container(
          height: reviews.length > 0 ? 200 : 0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index];
              return Container(
                width: 300,
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user!.username!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(
                            review.rating!.toInt(),
                            (index) => Icon(Icons.star, color: Colors.yellow),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            review.review.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildDescriptionSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildPriceRow() {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'sw_TZ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.product.discountPrice != null &&
                widget.product.discountPrice > 0)
              Flexible(
                child: Text('  ${formatCurrency.format(widget.product.price)} ',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade600)),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.product.discountPrice != null &&
                        widget.product.discountPrice > 0.0
                    ? ' ${formatCurrency.format(widget.product.discountPrice)} '
                    : ' ${formatCurrency.format(widget.product.sellingPrice)} ',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            if (widget.product.discountPrice != null &&
                widget.product.discountPrice > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${((widget.product.price - widget.product.discountPrice!) / widget.product.price * 100).round()}% off',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: (widget.product.productDeliveryInfos!.isNotEmpty &&
                  widget.product.productDeliveryInfos!.first.freeDelivery ==
                      true)
              ? const Text(
                  'Free Delivery',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10.0,
                  ),
                )
              : Text(
                  widget.product.productDeliveryInfos!.isNotEmpty &&
                          widget.product.productDeliveryInfos!.first
                                  .deliveryCost ==
                              0.0
                      ? 'Delivery Cost: TSh ${widget.product.productDeliveryInfos!.first.deliveryCost}'
                      : '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 300 && !_showPriceInAppBar) {
      setState(() {
        _showPriceInAppBar = true;
      });
    } else if (_scrollController.offset < 300 && _showPriceInAppBar) {
      setState(() {
        _showPriceInAppBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            title: _showPriceInAppBar
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.product.discountPrice != null &&
                              widget.product.discountPrice > 0)
                            Text(
                              'TSh ${widget.product.price}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.product.discountPrice != null &&
                                      widget.product.discountPrice > 0
                                  ? 'TSh ${widget.product.discountPrice}'
                                  : 'TSh ${widget.product.price}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: (widget
                                    .product.productDeliveryInfos!.isNotEmpty &&
                                widget.product.productDeliveryInfos?.first
                                        .deliveryCost ==
                                    0.0 &&
                                widget.product.productDeliveryInfos?.first
                                        .freeDelivery ==
                                    true)
                            ? const Text(
                                'Free Delivery',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10.0,
                                ),
                              )
                            : Text(
                                widget.product.productDeliveryInfos!
                                            .isNotEmpty &&
                                        widget.product.productDeliveryInfos
                                                ?.first.deliveryCost !=
                                            0
                                    ? 'Delivery Cost: TSh ${widget.product.productDeliveryInfos?.first.deliveryCost}'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10.0,
                                )),
                      ),
                    ],
                  )
                : const Text(''),
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding:
                            EdgeInsets.zero, // Make dialog cover entire screen
                        child: Stack(
                          alignment: Alignment
                              .topRight, // Align close button to top right
                          children: [
                            Image.network(
                              key: _key,
                              widget.product.image ??
                                  'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                      0.5), // Semi-transparent black
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Image.network(
                  widget.product.image ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(' ${widget.product.name}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          trailing: IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Add your share functionality here
                            },
                          ),
                        ),
                        const Divider(),
                        buildPriceRow(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  if (state is ProductDetailsLoaded) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildImageSection(
                                          'Product Images',
                                          state.productDetails.data!
                                              .productImages!
                                              .map((image) => image.image ?? "")
                                              .toList(),
                                        ),
                                      ],
                                    );
                                  }
                                  return const Center(
                                      child: Text('Loading...'));
                                },
                              ),
                              Text(
                                'Details',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<ProductBloc, ProductState>(
                                builder: (context, state) {
                                  if (state is ProductDetailsLoaded) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<ProductBloc, ProductState>(
                                          builder: (context, state) {
                                            if (state is ProductDetailsLoaded) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildColorSection(
                                                    'Product Colors',
                                                    state.productDetails.data!
                                                        .productColors!
                                                        .map((color) =>
                                                            color.color!)
                                                        .toList(),
                                                  ),
                                                  // buildSizeSection(
                                                  //   'Product Sizes',
                                                  //   state.productDetails.data!
                                                  //       .productSize!
                                                  //       .map((size) =>
                                                  //           size.size!)
                                                  //       .toList(),
                                                  // ),
                                                  // ignore: prefer_is_empty

                                                  buildSpecSection(
                                                    'Product Specifications',
                                                    state.productDetails.data!
                                                        .productSpecifications!,
                                                  ),

                                                  const Divider(),
                                                  buildDescriptionSection(
                                                      'Description',
                                                      widget.product
                                                              .description ??
                                                          ''),

                                                  buildReviewSection(
                                                    'Product Reviews',
                                                    state.productDetails.data!
                                                        .productReviews!,
                                                  ),
                                                ],
                                              );
                                            }
                                            return const Center(
                                                child: Text('Loading...'));
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                  return const Center(
                                      // shimmer effect for loading
                                      child: Text('Loading...'));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // add a floading action button for go to cart

      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () async {
          // List<Map<String, dynamic>> cartItems = await getCartItems();
          // animateItemToCart(context, _key);

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

      persistentFooterButtons: [
        // add to cart button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                if (selectedColorCode != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delivery Confirmation'),
                        content:
                            const Text('Do you want the product delivered?'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Yes'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            onPressed: () {
                              if (selectedColorCode != null) {
                                context
                                    .read<ShoppingCartBloc>()
                                    .add(AddItemToCart(
                                      delivered: true,
                                      productColor: selectedColorCode ?? "",
                                      product: widget.product,
                                    ));
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    colorSelected = false;
                  });
                }
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {},
              icon: const Icon(Icons.payment, color: Colors.white),
              label: const Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 9, 9, 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AnimatedItem extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Widget child;

  AnimatedItem(
      {required this.startPosition,
      required this.endPosition,
      required this.child});

  @override
  _AnimatedItemState createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation =
        Tween<Offset>(begin: widget.startPosition, end: widget.endPosition)
            .animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: child!,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
