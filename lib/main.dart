import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/router/dc_router_config.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  // 确保 WidgetsFlutterBinding 初始化
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        // 路由
        Widget resultWidget = MaterialApp.router(
          theme: ThemeData(
            // 解决ios上加粗(w500)无效问题
            fontFamilyFallback: Platform.isIOS ? ["PingFang TC"] : null,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
        // 吐司
        resultWidget = OKToast(
          child: resultWidget,
        );
        return resultWidget;
      },
    );
    return resultWidget;
  }
}
