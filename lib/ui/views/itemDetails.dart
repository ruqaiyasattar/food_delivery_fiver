import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_delivery_app/core/models/ShoppingCart.dart';
import 'package:food_delivery_app/core/models/favourite_products.dart';
import 'package:food_delivery_app/core/models/product.dart';
import 'package:food_delivery_app/ui/shared/toast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../shared/text_styles.dart' as style;

final stateBloc = StateBloc();

class ItemDetails extends StatelessWidget {
  final Product product;
  final FavouriteProducts favouriteProducts;

  ItemDetails({@required this.product,@required this.favouriteProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutStarts(
        product: product,
        favouriteProducts: this.favouriteProducts,
      ),
    );
  }
}

class LayoutStarts extends StatelessWidget {
  final Product product;
  final FavouriteProducts favouriteProducts;

  LayoutStarts({this.product,this.favouriteProducts});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailsAnimation(product: product,favouriteProducts: favouriteProducts,),
        CustomBottomSheet(context: context,product: product,),
        RentButton(
          onClick: (){
            Provider.of<ShoppingCart>(context, listen: false).addProduct(product);
            ToastCall.showToast("Aggiungi al Carrello",isLong: false);
          },
        ),
      ],
    );
  }
}

class RentButton extends StatelessWidget {
  final Function onClick;

  const RentButton({Key key, this.onClick}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 200,
        child: FlatButton(
          onPressed: onClick,
          child: Text(
            "Aggiungi al carrello ",
            style: style.arialTheme,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
          ),
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(25),
        ),
      ),
    );
  }
}

class CarDetailsAnimation extends StatefulWidget {
  final Product product;
  final FavouriteProducts favouriteProducts;

  CarDetailsAnimation({this.product,this.favouriteProducts});

  @override
  _CarDetailsAnimationState createState() => _CarDetailsAnimationState();
}

class _CarDetailsAnimationState extends State<CarDetailsAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    super.initState();

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      initialData: StateProvider().isAnimating,
      stream: stateBloc.animationStatus,
      builder: (context, snapshot) {
        snapshot.data ? forward() : reverse();

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: DishDetails(product: widget.product,favouriteProducts: widget.favouriteProducts,),
          ),
        );
      },
    );
  }
}

class DishDetails extends StatefulWidget {
  final Product product;
  final FavouriteProducts favouriteProducts;
  DishDetails({this.product,this.favouriteProducts});

  @override
  _DishDetailsState createState() => _DishDetailsState();
}

class _DishDetailsState extends State<DishDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Positioned(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: CarCarousel(product:widget.product),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 25),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 42,
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(right: 25),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      widget.product.liked=!widget.product.liked;
                      widget.product.liked?
                      widget.favouriteProducts.addProduct(widget.product.id)
                          :widget.favouriteProducts.removeProduct(widget.product.id);
                    });
                  },
                  child: widget.product.liked ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 42,
                  ):Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 42,
                  ),
                )
              )
            ],
          ),
        ),
      ],
    ));
  }

  _carTitle(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              style: style.headerStyle.copyWith(
                fontSize: 62,
              ),
              children: [
                TextSpan(text: widget.product.name),
                TextSpan(text: "\n"),
                TextSpan(text: widget.product.category, style: style.subcardTitleStyle),
              ]),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(
                text: widget.product.price.toString(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 48,
                    fontWeight: FontWeight.w900)),
            TextSpan(
              text: " \$",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 48,
                  fontWeight: FontWeight.w900),
            )
          ]),
        ),
      ],
    );
  }
}

class CarCarousel extends StatefulWidget {
  final Product product;
  CarCarousel({this.product});

  @override
  _CarCarouselState createState() => _CarCarouselState();
}

class _CarCarouselState extends State<CarCarousel> {
  List<String> imgList;

  List<Widget> child() {}
  List<Widget> childe;

  List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;

  @override
  void initState() {
    imgList = widget.product.images;
    childe = _map<Widget>(imgList, (index, String assetName) {
      return Container(
          decoration: BoxDecoration(),
          child: Hero(
            tag: widget.product.id,
            child: Image.network(
              assetName,
              fit: BoxFit.cover,
              color: Colors.lightBlueAccent.withOpacity(0.2),
              colorBlendMode: BlendMode.hardLight,
            ),
          ));
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            autoPlay: true,
            height: MediaQuery.of(context).size.height * 0.9,
            viewportFraction: 1.0,
            items: childe,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.7,
            left: MediaQuery.of(context).size.width * 0.32,
            child: Container(
              //margin: EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _map<Widget>(imgList, (index, assetName) {
                  return Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                        color: _current == index
                            ? Colors.grey[100]
                            : Colors.grey[600]),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///////////////////
class CustomBottomSheet extends StatefulWidget {
  final BuildContext context;
//  final Map<String, dynamic> dish;
  final Product product;

  CustomBottomSheet({this.context, this.product});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop;

  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    double sheetTop = MediaQuery.of(widget.context).size.height * 0.8;
    double minSheetTop = 30;
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
            controller.forward();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(product: widget.product),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  final Product product;

  SheetContainer({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Theme.of(context).cardColor),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.only(left: 15),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      product.name,
                      style: style.headerStyle2,
                    ),
                    Text(
                      '  ${product.category}',
                      style: style.subHintTitle,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
//                Row(
//                  children: <Widget>[
//                    SmoothStarRating(
//                        allowHalfRating: false,
//                        starCount: 5,
//                        rating: dish['rating'],
//                        size: 20.0,
//                        color: Color(0xFFFEBF00),
//                        borderColor: Color(0xFFFEBF00),
//                        spacing: 0.0),
//                    Text(
//                      '  (${dish['rating']})',
//                      style: style.subHintTitle,
//                    )
//                  ],
//                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'PREZZO ',
                      style: style.cardTitleStyle,
                    ),
                    Text(
                      '${product.price} €',
                      style: style.headerStyle3
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Descrizione del prodotto',
                  style: style.headerStyle2,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  product.description??"Nessuna descrizione disponibile",
                   style: style.textTheme,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawReviewTile(context, name, asset) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(asset))),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  name,
                  style: style.headerStyle3,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: 5,
                        size: 20.0,
                        color: Color(0xFFFEBF00),
                        borderColor: Color(0xFFFEBF00),
                        spacing: 0.0),
                    Text(
                      ' June 7, 2020',
                      style: style.subHintTitle,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'This is the best food you can ever try Delicious and Have a nice plating and the service and delivery was really quickly',
                  softWrap: true,
                  maxLines: 3,
                  style: style.textTheme.copyWith(fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }
}

class StateBloc {
  StreamController animationController = StreamController.broadcast();
  final StateProvider provider = StateProvider();

  Stream get animationStatus => animationController.stream;

  void toggleAnimation() {
    provider.toggleAnimationValue();
    animationController.sink.add(provider.isAnimating);
  }

  void dispose() {
    animationController.close();
  }
}

class StateProvider {
  bool isAnimating = true;

  void toggleAnimationValue() => isAnimating = !isAnimating;
}
