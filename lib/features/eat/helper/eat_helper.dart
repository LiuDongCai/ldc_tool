import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ldc_tool/base/network/dc_network.dart';
import 'package:ldc_tool/features/common/network/dc_api.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';

class EatHelper {
  /// 主食列表
  static List<EatModel> eatMainList = [];

  /// 饮品列表
  static List<EatModel> eatDrinkList = [];

  /// 甜点列表
  static List<EatModel> eatDessertList = [];

  /// 获取餐馆列表-主食
  static Future<List<EatModel>> getEatMainList() async {
    // 如果主食列表不为空，则直接返回
    if (eatMainList.isNotEmpty) {
      return eatMainList;
    }
    // 如果主食列表为空，则先从网络获取
    final result = await DCNetwork.instance.get(
      path: DCApi.eatMainList,
    );
    if (result.statusCode == 200) {
      final eatList = result.data;
      if (eatList is List) {
        final eatMainList = eatList.map((e) => EatModel.fromJson(e)).toList();
        EatHelper.eatMainList = eatMainList;
        return eatMainList;
      }
    }

    // 如果网络获取失败，则从本地获取
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_main.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      final eatMainList = eatList.map((e) => EatModel.fromJson(e)).toList();
      EatHelper.eatMainList = eatMainList;
      return eatMainList;
    }
    return [];
  }

  /// 获取餐馆列表-饮品
  static Future<List<EatModel>> getEatDrinkList() async {
    // 如果饮品列表不为空，则直接返回
    if (eatDrinkList.isNotEmpty) {
      return eatDrinkList;
    }
    // 如果饮品列表为空，则先从网络获取
    final result = await DCNetwork.instance.get(
      path: DCApi.eatDrinkList,
    );
    if (result.statusCode == 200) {
      final eatList = result.data;
      if (eatList is List) {
        final eatDrinkList = eatList.map((e) => EatModel.fromJson(e)).toList();
        EatHelper.eatDrinkList = eatDrinkList;
        return eatDrinkList;
      }
    }

    // 如果网络获取失败，则从本地获取
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_drink.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      final eatDrinkList = eatList.map((e) => EatModel.fromJson(e)).toList();
      EatHelper.eatDrinkList = eatDrinkList;
      return eatDrinkList;
    }
    return [];
  }

  /// 获取餐馆列表-甜点
  static Future<List<EatModel>> getEatDessertList() async {
    // 如果甜点列表不为空，则直接返回
    if (eatDessertList.isNotEmpty) {
      return eatDessertList;
    }
    // 如果甜点列表为空，则先从网络获取
    final result = await DCNetwork.instance.get(
      path: DCApi.eatDessertList,
    );
    if (result.statusCode == 200) {
      final eatList = result.data;
      if (eatList is List) {
        final eatDessertList =
            eatList.map((e) => EatModel.fromJson(e)).toList();
        EatHelper.eatDessertList = eatDessertList;
        return eatDessertList;
      }
    }

    // 如果网络获取失败，则从本地获取
    final jsonString =
        await rootBundle.loadString('assets/json/eat/eat_dessert.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      final eatDessertList = eatList.map((e) => EatModel.fromJson(e)).toList();
      EatHelper.eatDessertList = eatDessertList;
      return eatDessertList;
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

  /// 获取餐馆列表-根据大类
  static Future<List<EatModel>> getEatList({
    required EatMainType mainType,
  }) async {
    switch (mainType) {
      case EatMainType.all:
        return await getEatAllList();
      case EatMainType.main:
        return await getEatMainList();
      case EatMainType.drink:
        return await getEatDrinkList();
      case EatMainType.dessert:
        return await getEatDessertList();
    }
  }
}
