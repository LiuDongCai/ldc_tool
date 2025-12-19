import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';

class EatHelper {
  /// 获取餐馆列表-主食
  static Future<List<EatModel>> getEatMainList() async {
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_main.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      return eatList.map((e) => EatModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 获取餐馆列表-饮品
  static Future<List<EatModel>> getEatDrinkList() async {
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_drink.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      return eatList.map((e) => EatModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 获取餐馆列表-甜点
  static Future<List<EatModel>> getEatDessertList() async {
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_dessert.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      return eatList.map((e) => EatModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 获取餐馆列表-全部
  static Future<List<EatModel>> getEatAllList() async {
    final mainList = await getEatMainList();
    final drinkList = await getEatDrinkList();
    final dessertList = await getEatDessertList();
    return [...mainList, ...drinkList, ...dessertList];
  }
}
