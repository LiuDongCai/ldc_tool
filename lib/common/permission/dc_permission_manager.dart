import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:ldc_tool/common/util/dc_tool.dart';
import 'package:ldc_tool/common/widgets/dialog/dc_alert_dialog.dart';
import 'package:ldc_tool/common/widgets/toast/dc_toast.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限管理
class DCPermissionManager {
  factory DCPermissionManager() => _getInstance();

  static DCPermissionManager get instance => _getInstance();
  static DCPermissionManager? _instance;

  DCPermissionManager._internal();

  static DCPermissionManager _getInstance() {
    _instance ??= DCPermissionManager._internal();
    return _instance!;
  }

  /// 检查相片和影片权限（若没有权限则会自动申请权限）
  Future<bool> checkPhotosPermission(BuildContext context) async {
    List<Permission> permissions = [];
    if (DCTool.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var androidSdkInt = androidInfo.version.sdkInt;
      if (androidSdkInt < 33) {
        permissions.add(Permission.storage);
      } else {
        permissions.addAll([
          Permission.photos,
          Permission.videos,
        ]);
      }
    } else {
      permissions.add(Permission.photos);
    }
    // 权限状态
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }
    // 检查是否所有权限已被授予
    if (statuses.values.every(_isPermissionAllow)) {
      return true;
    }
    // 收集需要请求的权限
    permissions = statuses.entries
        .where((entry) => !_isPermissionAllow(entry.value))
        .map((entry) => entry.key)
        .toList();
    //请求权限
    statuses = await permissions.request();
    // 再次检查是否所有权限已被授予
    if (statuses.values.every(_isPermissionAllow)) {
      return true;
    }
    // 处理权限被拒绝的情况
    if (context.mounted) {
      // 当多权限被拒后，Android端暂时无法精准判断权限状态
      // https://github.com/Baseflow/flutter-permission-handler/issues/1393
      // bool isPermanentlyDenied =
      //     statuses.values.contains(PermissionStatus.permanentlyDenied);
      _handlePermissionDenied(
        context,
        isPermanentlyDenied: true,
        title: '相片和影片权限被拒绝',
        dialogMsg: '建议前往系统设置，在「应用程式」中打開權限「相片和影片」開關',
        toastMsg: '相片和影片权限被拒绝',
      );
    }
    return false;
  }

  /// 检查相机权限（若没有权限则会自动申请权限）
  Future<bool> checkCameraPermission(BuildContext context) async {
    final hasPermission = await checkPermission(
      context: context,
      permission: Permission.camera,
      title: '相机',
    );
    return hasPermission;
  }

  /// 检查麦克风权限（若没有权限则会自动申请权限）
  Future<bool> checkMicrophonePermission(BuildContext context) async {
    final hasPermission = await checkPermission(
      context: context,
      permission: Permission.microphone,
      title: '麦克风',
    );
    return hasPermission;
  }

  /// 检查指定权限（若没有权限则会自动申请权限）
  Future<bool> checkPermission({
    required BuildContext context,
    required Permission permission,
    required String title,
  }) async {
    PermissionStatus status = await permission.status;
    if (_isPermissionAllow(status)) {
      return true;
    }
    status = await permission.request();
    if (_isPermissionAllow(status)) {
      return true;
    }
    if (context.mounted) {
      _handlePermissionDenied(
        context,
        isPermanentlyDenied: status == PermissionStatus.permanentlyDenied,
        title: '$title权限被拒绝',
        dialogMsg: '建议前往系统设置，在「应用程式」中打開權限「$title」開關',
        toastMsg: '$title权限被拒绝',
      );
    }
    return false;
  }

  /// 检查指定权限组（若没有权限则会自动申请权限）
  Future<bool> checkPermissionGroup({
    required BuildContext context,
    required List<Permission> permissions,
    required String title,
  }) async {
    if (permissions.isEmpty) return true;
    // 权限状态
    Map<Permission, PermissionStatus> statuses = {};
    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }
    // 检查是否所有权限已被授予
    if (statuses.values.every(_isPermissionAllow)) {
      return true;
    }
    // 收集需要请求的权限
    permissions = statuses.entries
        .where((entry) => !_isPermissionAllow(entry.value))
        .map((entry) => entry.key)
        .toList();
    // 请求权限
    statuses = await permissions.request();
    // 再次检查是否所有权限已被授予
    if (statuses.values.every(_isPermissionAllow)) {
      return true;
    }
    // 处理权限被拒绝的情况
    if (context.mounted) {
      _handlePermissionDenied(
        context,
        isPermanentlyDenied: true,
        title: '$title权限被拒绝',
        dialogMsg: '建议前往系统设置，在「应用程式」中打開權限「$title」開關',
        toastMsg: '$title权限被拒绝',
      );
    }
    return false;
  }

  /// 是否有权限（仅判断是否有权限，不做权限申请）,True:有权限，False:无权限
  Future<bool> isHasPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    return _isPermissionAllow(status);
  }

  /// 检查权限是否被允许
  bool _isPermissionAllow(PermissionStatus status) {
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  /// 处理权限被拒绝
  void _handlePermissionDenied(
    BuildContext context, {
    required bool isPermanentlyDenied,
    required String title,
    required String dialogMsg,
    required String toastMsg,
  }) {
    if (isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (_) => DCAlertDialog(
          title: title,
          message: dialogMsg,
          positiveText: "去設置",
          negativeText: "取消",
          onPositive: () {
            AppSettings.openAppSettings();
          },
        ),
      );
    } else {
      DCToast.show(message: toastMsg);
    }
  }
}
