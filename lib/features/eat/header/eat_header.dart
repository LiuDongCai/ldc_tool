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

  /// 面包蛋糕
  breadCake(16),

  /// 咖啡奶茶
  coffeeTea(17),

  /// 甜品
  dessert(18),

  /// 其他
  other(19);

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
  dapeng(10),

  /// 其他
  other(99);

  final int type;

  const SectionType(this.type);

  /// 获取地区名称
  String get name => switch (this) {
        SectionType.longhua => '龙华',
        SectionType.futian => '福田',
        SectionType.nanshan => '南山',
        SectionType.luohu => '罗湖',
        SectionType.baoan => '宝安',
        SectionType.longgang => '龙岗',
        SectionType.yantian => '盐田',
        SectionType.pingshan => '坪山',
        SectionType.guangming => '光明',
        SectionType.dapeng => '大鹏',
        SectionType.other => '其他',
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
