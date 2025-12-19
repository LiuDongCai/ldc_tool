import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';

typedef EatLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatLogic, W>;

typedef EatLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatLogic, W>;

/// 更新类型
enum EatUpdateId {
  /// 轮播图指示器
  eatBannerIndicator,
}

/// 菜系枚举
enum FoodType {
  /// 粤菜
  cantonese(1),

  /// 客家菜
  hakka(2),

  /// 潮汕菜
  chaoshan(3),

  /// 烧烤烤串
  barbecue(4),

  /// 川湘菜
  sichuan(5),

  /// 川渝火锅
  sichuanHotpot(6),

  /// 潮汕牛肉火锅
  chaoshanHotpot(7),

  /// 东北菜
  northeast(8),

  /// 日式料理
  japanese(9),

  /// 韩式料理
  korean(10),

  /// 西餐
  western(11),

  /// 海鲜
  seafood(12),

  /// 米粉面馆
  riceNoodle(13),

  /// 快餐
  fastFood(14),

  /// 小吃
  snack(15),

  /// 麻辣烫
  malangtang(16),

  /// 面包蛋糕
  breadCake(17),

  /// 咖啡奶茶
  coffeeTea(18),

  /// 甜品
  dessert(19),

  /// 其他
  other(20);

  final int type;

  const FoodType(this.type);

  /// 获取菜系名称
  String get name => switch (this) {
        FoodType.cantonese => '粤菜',
        FoodType.hakka => '客家菜',
        FoodType.chaoshan => '潮汕菜',
        FoodType.barbecue => '烧烤烤串',
        FoodType.sichuan => '川湘菜',
        FoodType.sichuanHotpot => '川渝火锅',
        FoodType.chaoshanHotpot => '潮汕牛肉火锅',
        FoodType.northeast => '东北菜',
        FoodType.japanese => '日式料理',
        FoodType.korean => '韩式料理',
        FoodType.western => '西餐',
        FoodType.seafood => '海鲜',
        FoodType.riceNoodle => '米粉面馆',
        FoodType.fastFood => '快餐',
        FoodType.snack => '小吃',
        FoodType.malangtang => '麻辣烫',
        FoodType.breadCake => '面包蛋糕',
        FoodType.coffeeTea => '咖啡奶茶',
        FoodType.dessert => '甜品',
        FoodType.other => '其他',
      };
}

/// 地区枚举
/// 不传section时，默认所有区都可能有的地区
enum SectionType {
  /// 龙华
  longhua(1),

  /// 福田
  futian(2),

  /// 南山
  nanshan(3),

  /// 罗湖
  luohu(4),

  /// 宝安
  baoan(5),

  /// 龙岗
  longgang(6),

  /// 盐田
  yantian(7),

  /// 坪山
  pingshan(8),

  /// 光明
  guangming(9),

  /// 大鹏
  dapeng(10);

  final int type;

  const SectionType(this.type);

  /// 获取地区名称
  String get name => switch (this) {
        SectionType.longhua => '龙华区',
        SectionType.futian => '福田区',
        SectionType.nanshan => '南山区',
        SectionType.luohu => '罗湖区',
        SectionType.baoan => '宝安区',
        SectionType.longgang => '龙岗区',
        SectionType.yantian => '盐田区',
        SectionType.pingshan => '坪山区',
        SectionType.guangming => '光明区',
        SectionType.dapeng => '大鹏新区',
      };
}

/// 返现平台
enum CashbackPlatform {
  /// 灰太狼
  huitailang(1),

  /// 歪麦
  waimai(2);

  final int platform;

  const CashbackPlatform(this.platform);

  /// 获取返现平台名称
  String get name => switch (this) {
        CashbackPlatform.huitailang => '灰太狼',
        CashbackPlatform.waimai => '歪麦',
      };
}

/// 点餐大类
enum EatMainType {
  /// 全部
  all(1),

  /// 主食
  main(2),

  /// 饮品
  drink(3),

  /// 甜点
  dessert(3);

  final int type;

  const EatMainType(this.type);

  /// 获取点餐大类名称
  String get name => switch (this) {
        EatMainType.all => '全部',
        EatMainType.main => '主食',
        EatMainType.drink => '饮品',
        EatMainType.dessert => '甜点',
      };
}
