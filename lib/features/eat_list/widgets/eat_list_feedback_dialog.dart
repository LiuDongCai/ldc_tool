import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/util/dc_keyboard_tool.dart';
import 'package:ldc_tool/common/widgets/toast/dc_toast.dart';
import 'package:ldc_tool/features/common/count/dc_event_config.dart';
import 'package:ldc_tool/features/common/count/dc_event_count.dart';

class EatListFeedbackDialog extends StatefulWidget {
  const EatListFeedbackDialog({
    super.key,
  });

  @override
  State<EatListFeedbackDialog> createState() => _EatListFeedbackDialogState();
}

class _EatListFeedbackDialogState extends State<EatListFeedbackDialog> {
  /// 反馈控制器
  final TextEditingController _feedbackController = TextEditingController();

  /// 评分
  double _score = 3.5;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.w),
        _buildFeedbackTitle(),
        SizedBox(height: 8.w),
        _buildFeedbackInfo(),
        SizedBox(height: 12.w),
        _buildFeedbackInput(),
        SizedBox(height: 12.w),
        _buildFeedbackScore(),
        SizedBox(height: 12.w),
        _buildFeedbackTip(),
        _buildFeedbackButton(),
        SizedBox(height: 12.w),
      ],
    );
    resultWidget = Stack(
      children: [
        resultWidget,
        // 关闭按钮
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            color: DCColors.dc42CC8F,
            iconSize: 28.sp,
            onPressed: () {
              DCKeyboardTool.hideKeyboard(context: context);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: resultWidget,
    );
    resultWidget = SingleChildScrollView(
      child: resultWidget,
    );
    resultWidget = Material(
      color: DCColors.dc00000000,
      child: resultWidget,
    );
    resultWidget = Center(
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点击空白处隐藏软键盘
        DCKeyboardTool.hideKeyboard(context: context);
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  ///  反馈标题
  Widget _buildFeedbackTitle() {
    Widget resultWidget = Text(
      '没有想吃的？',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
        height: 26 / 16,
      ),
    );
    return resultWidget;
  }

  /// 反馈信息
  Widget _buildFeedbackInfo() {
    Widget resultWidget = Text(
      '听说您有好吃的餐馆推荐，下个版本添加吧～',
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc666666,
        height: 20 / 14,
      ),
    );
    return resultWidget;
  }

  /// 反馈输入
  Widget _buildFeedbackInput() {
    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.w,
        color: DCColors.dc42CC8F,
      ),
    );
    Widget resultWidget = TextField(
      controller: _feedbackController,
      decoration: InputDecoration(
        hintText: '请输入餐馆名称',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: DCColors.dc999999,
        ),
        border: border,
        errorBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
        disabledBorder: border,
        enabledBorder: border,
        contentPadding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 反馈评分
  Widget _buildFeedbackScore() {
    Widget resultWidget = RatingBar.builder(
      initialRating: _score,
      minRating: 0.5,
      itemCount: 5,
      itemSize: 25.w,
      direction: Axis.horizontal,
      allowHalfRating: true,
      updateOnDrag: true,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: DCColors.dcFF8000,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _score = rating;
        });
      },
    );
    resultWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        resultWidget,
        Text(
          '$_score',
          style: TextStyle(
            fontSize: 14.sp,
            color: DCColors.dcFF8000,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    return resultWidget;
  }

  /// 反馈提示
  Widget _buildFeedbackTip() {
    if (_score > 3) {
      return const SizedBox.shrink();
    }
    Widget resultWidget = Text(
      '此功能旨在为用户提供好吃的餐馆\n3分以下的餐馆不支持添加!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.red,
        height: 20 / 14,
      ),
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 反馈按钮
  Widget _buildFeedbackButton() {
    Widget resultWidget = Text(
      '提交',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
      ),
    );
    resultWidget = Container(
      width: double.infinity,
      height: 44.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: DCColors.dc42CC8F,
        borderRadius: BorderRadius.circular(8.w),
      ),
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final eatName = _feedbackController.text;
        if (eatName.isEmpty) {
          DCToast.show(message: '请输入餐馆名称');
          return;
        }
        if (_score < 3) {
          DCToast.show(message: '3分以下的餐馆不支持添加');
          return;
        }
        // 统计事件
        DCEventCount.countEvent(
          DCEventName.eatNameFeedback,
          params: {
            DCEventParams.name: eatName,
            DCEventParams.score: _score,
            DCEventParams.submitTime: DateTime.now().millisecondsSinceEpoch,
          },
        );
        DCToast.show(message: '提交成功');
        Navigator.pop(context);
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
