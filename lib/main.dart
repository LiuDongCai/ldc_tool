import 'package:flutter/material.dart';
import 'package:ldc_tool/base/light_tracking/light_tracking.dart';
import 'package:ldc_tool/common/util/dc_log.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.red,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.blue,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.purple,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.pink,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.brown,
              ),
            ),
            _buildItem(),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.green,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
    resultWidget = LightTrackingProvider(
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget _buildItem() {
    Widget resultWidget = Container(
      height: 300,
      color: Colors.orange,
    );
    resultWidget = LTExposureDetector(
      id: '3a38713b-4cce-4fc8-bb19-8714f05676a9',
      overrideRatio: LTExposureRatio.appear,
      overrideTime: 1,
      onTrigger: () {
        DCLog.i('触发曝光统计');
      },
      child: resultWidget,
    );
    resultWidget = SliverToBoxAdapter(
      child: resultWidget,
    );
    return resultWidget;
  }
}
