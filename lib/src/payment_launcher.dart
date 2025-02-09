import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:payment_launcher/src/models.dart';
import 'package:payment_launcher/src/utils.dart';

class PaymentLauncher {
  static const MethodChannel _channel = MethodChannel('payment_launcher');

  /// Returns list of installed payment apps on the device.
  static Future<List<AvailablePayment>> get installedPayments async {
    final payments = await _channel.invokeMethod('getInstalledPayments');
    debugPrint('installedPayments : ${payments.toString()}');
    return List<AvailablePayment>.from(
      payments.map((payment) => AvailablePayment.fromJson(payment)),
    );
  }

  /// Opens payment app specified in [paymentType]
  static Future<dynamic> showPayment({
    required PaymentType paymentType,
    required String title,
    String? description,
  }) async {
    final Map<String, String?> args = {
      'paymentType': Utils.enumToString(paymentType),
      'title': title,
      'description': description,
    };
    return _channel.invokeMethod('launchPayment', args);
  }

  /// Returns boolean indicating if payment app is installed
  static Future<bool?> isPaymentAvailable(PaymentType paymentType) async {
    return _channel.invokeMethod(
      'isPaymentAvailable',
      {'paymentType': Utils.enumToString(paymentType)},
    );
  }
}
