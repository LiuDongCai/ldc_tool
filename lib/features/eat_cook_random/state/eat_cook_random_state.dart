import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';

class EatCookRandomState {
  /// 大类选择
  int cookCount = 3;

  /// 几汤
  int soupCount = 1;

  /// 随机结果
  List<EatCookModel>? randomResultList;

  /// 励志话语
  List<String> motivationalWords = [
    '人生如进食，细嚼慢咽才能品出真味。',
    '饥饿是最好的调味，经历匮乏方懂珍惜。',
    '碗中见天地，一餐一饭皆是修行。',
    '好好吃饭，是疲惫生活里最扎实的抵抗。',
    '食物温暖胃，梦想照亮路——两者皆不可辜负。',
    '与其等待盛宴，不如把眼前的饭嚼出甘甜。',
    '最难的坚持，往往藏在最简单的“按时吃饭”里。',
    '吃饭要趁热，追梦要趁早。',
    '真正的成长，是既能咽下委屈，也能消化营养。',
    '你的身体是神殿，请用干净温暖的食物供奉它。',
  ];
}
