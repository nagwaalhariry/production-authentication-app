import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfoDataSource {
  Future<String> getDeviceSerial();
}

class DeviceInfoDataSourceImpl implements DeviceInfoDataSource {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  Future<String> getDeviceSerial() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return '${info.brand}-${info.model}-${info.id}';
    }

    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return '${info.name}-${info.model}-${info.identifierForVendor ?? 'unknown'}';
    }

    // TODO: Support web, desktop, and custom hardware serial strategies.
    return 'unsupported-platform';
  }
}
