import 'dart:convert';

import 'package:ldc_tool/common/util/dc_safe_convert.dart';

class EatModel {
  EatModel({
    this.id,
    this.name,
    this.image,
    this.section,
    this.type,
    this.greatFood,
    this.badFood,
    this.price,
    this.cashback,
    this.score,
    this.url,
    this.remark,
  });

  factory EatModel.fromJson(Map<String, dynamic> json) {
    final List<int>? section = json['section'] is List ? <int>[] : null;
    if (section != null) {
      for (final dynamic item in json['section']!) {
        if (item != null) {
          section.add(asT<int>(item)!);
        }
      }
    }

    final List<int>? type = json['type'] is List ? <int>[] : null;
    if (type != null) {
      for (final dynamic item in json['type']!) {
        if (item != null) {
          type.add(asT<int>(item)!);
        }
      }
    }

    final List<int>? cashback = json['cashback'] is List ? <int>[] : null;
    if (cashback != null) {
      for (final dynamic item in json['cashback']!) {
        if (item != null) {
          cashback.add(asT<int>(item)!);
        }
      }
    }
    return EatModel(
      id: asT<int?>(json['id']),
      name: asT<String?>(json['name']),
      image: asT<String?>(json['image']),
      section: section,
      type: type,
      greatFood: asT<String?>(json['great_food']),
      badFood: asT<String?>(json['bad_food']),
      price: asT<String?>(json['price']),
      cashback: cashback,
      score: asT<double?>(json['score']),
      url: asT<String?>(json['url']),
      remark: asT<String?>(json['remark']),
    );
  }

  int? id;
  String? name;
  String? image;
  List<int>? section;
  List<int>? type;
  String? greatFood;
  String? badFood;
  String? price;
  List<int>? cashback;
  double? score;
  String? url;
  String? remark;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
        'section': section,
        'type': type,
        'great_food': greatFood,
        'bad_food': badFood,
        'price': price,
        'cashback': cashback,
        'score': score,
        'url': url,
        'remark': remark,
      };
}
