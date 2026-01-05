import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ldc_tool/base/network/dc_network.dart';
import 'package:ldc_tool/features/common/network/dc_api.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';

/// 家常菜 Helper
class EatCookHelper {
  /// 主菜列表
  static List<EatCookModel> cookMainList = [];

  /// 汤列表
  static List<EatCookModel> cookSoupList = [];

  /// 获取家常菜列表-主菜
  static Future<List<EatCookModel>> getCookMainList() async {
    // 如果主食列表不为空，则直接返回
    if (cookMainList.isNotEmpty) {
      return cookMainList;
    }
    // 如果主食列表为空，则先从网络获取
    final result = await DCNetwork.instance.get(
      path: DCApi.eatCookMainList,
    );
    if (result.statusCode == 200) {
      final cookList = result.data;
      if (cookList is List) {
        final cookMainList =
            cookList.map((e) => EatCookModel.fromJson(e)).toList();
        EatCookHelper.cookMainList = cookMainList;
        return cookMainList;
      }
    }

    // 如果网络获取失败，则从本地获取
    final jsonString =
        await rootBundle.loadString('build/web/json/eat_cook_main.json');
    final eatList = jsonDecode(jsonString);
    if (eatList is List) {
      final cookMainList =
          eatList.map((e) => EatCookModel.fromJson(e)).toList();
      EatCookHelper.cookMainList = cookMainList;
      return cookMainList;
    }
    return [];
  }

  /// 获取餐馆列表-饮品
  static Future<List<EatCookModel>> getCookSoupList() async {
    // 如果饮品列表不为空，则直接返回
    if (cookSoupList.isNotEmpty) {
      return cookSoupList;
    }
    // 如果饮品列表为空，则先从网络获取
    final result = await DCNetwork.instance.get(
      path: DCApi.eatCookSoupList,
    );
    if (result.statusCode == 200) {
      final cookList = result.data;
      if (cookList is List) {
        final cookDrinkList =
            cookList.map((e) => EatCookModel.fromJson(e)).toList();
        EatCookHelper.cookSoupList = cookDrinkList;
        return cookDrinkList;
      }
    }

    // 如果网络获取失败，则从本地获取
    final jsonString =
        await rootBundle.loadString('build/web/json/eat_cook_soup.json');
    final cookList = jsonDecode(jsonString);
    if (cookList is List) {
      final cookSoupList =
          cookList.map((e) => EatCookModel.fromJson(e)).toList();
      EatCookHelper.cookSoupList = cookSoupList;
      return cookSoupList;
    }
    return [];
  }

  /// 获取餐馆列表-全部
  static Future<List<EatCookModel>> getCookAllList() async {
    final mainList = await getCookMainList();
    final soupList = await getCookSoupList();
    return [...mainList, ...soupList];
  }

  /// 获取餐馆列表-根据大类
  static Future<List<EatCookModel>> getCookList({
    required EatCookMainType mainType,
  }) async {
    switch (mainType) {
      case EatCookMainType.all:
        return await getCookAllList();
      case EatCookMainType.main:
        return await getCookMainList();
      case EatCookMainType.soup:
        return await getCookSoupList();
    }
  }
}
