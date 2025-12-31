import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/base/cache/dc_cache.dart';
import 'package:ldc_tool/base/network/dc_network.dart';
import 'package:ldc_tool/common/util/dc_tool.dart';
import 'package:ldc_tool/features/common/router/dc_router_config.dart';
import 'package:ldc_tool/firebase_options.dart';
import 'package:oktoast/oktoast.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 确保 WidgetsFlutterBinding 初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化缓存（不传 path 参数，自动使用应用文档目录）
  await DCCache.instance.init();

  // 初始化firebase统计
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 启动应用
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 初始化网络请求
    DCNetwork.instance.init(
      connectTimeout: 30000,
      receiveTimeout: 30000,
      retryCount: 3, // 失败重试 3 次
      retryDelay: 1000, // 重试间隔 1 秒
      enableLog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        // 路由/状态管理
        Widget resultWidget = GetMaterialApp(
          initialRoute: DCPages.main,
          theme: ThemeData(
            // 解决ios上加粗(w500)无效问题
            fontFamilyFallback: DCTool.isIOS ? ["PingFang TC"] : null,
          ),
          debugShowCheckedModeBanner: false,
          getPages: router,
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
