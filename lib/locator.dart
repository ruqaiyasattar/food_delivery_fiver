import 'package:food_delivery_app/core/models/product_list.dart';
import 'package:get_it/get_it.dart';

import './core/Dish_list.dart';
import './core/card_model.dart';
import './core/card_list_model.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(()=>ProductList());
  locator.registerFactory(() => FoodList()) ;
  locator.registerLazySingleton(() => CardListModelView());
  locator.registerLazySingleton(() => CardModel()) ;
}