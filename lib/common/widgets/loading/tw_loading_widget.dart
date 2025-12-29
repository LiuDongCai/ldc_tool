import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 加载控件
class DCLoadingWidget extends StatelessWidget {
  final String? message;

  const DCLoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DCColors.dcFFFFFF,
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: DCColors.dcFFFFFF.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.w),
              Text(
                message ?? '加载中...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: DCColors.dc333333,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
