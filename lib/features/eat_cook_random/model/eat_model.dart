import 'dart:convert';

import 'package:ldc_tool/common/util/dc_safe_convert.dart';

class EatCookModel {
  EatCookModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.ingredients,
    this.step,
    this.url,
    this.remark,
  });

  factory EatCookModel.fromJson(Map<String, dynamic> json) {
    final List<Ingredients>? ingredients =
        json['ingredients'] is List ? <Ingredients>[] : null;
    if (ingredients != null) {
      for (final dynamic item in json['ingredients']!) {
        if (item != null) {
          ingredients
              .add(Ingredients.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CookStep>? step = json['step'] is List ? <CookStep>[] : null;
    if (step != null) {
      for (final dynamic item in json['step']!) {
        if (item != null) {
          step.add(CookStep.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return EatCookModel(
      id: asT<int?>(json['id']),
      name: asT<String?>(json['name']),
      description: asT<String?>(json['description']),
      image: asT<String?>(json['image']),
      ingredients: ingredients,
      step: step,
      url: asT<String?>(json['url']),
      remark: asT<String?>(json['remark']),
    );
  }

  int? id;
  String? name;
  String? description;
  String? image;
  List<Ingredients>? ingredients;
  List<CookStep>? step;
  String? url;
  String? remark;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'ingredients': ingredients,
        'step': step,
        'url': url,
        'remark': remark,
      };
}

class Ingredients {
  Ingredients({
    this.name,
    this.amount,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) => Ingredients(
        name: asT<String?>(json['name']),
        amount: asT<String?>(json['amount']),
      );

  String? name;
  String? amount;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'amount': amount,
      };
}

class CookStep {
  CookStep({
    this.image,
    this.description,
  });

  factory CookStep.fromJson(Map<String, dynamic> json) => CookStep(
        image: asT<String?>(json['image']),
        description: asT<String?>(json['description']),
      );

  String? image;
  String? description;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'image': image,
        'description': description,
      };
}
