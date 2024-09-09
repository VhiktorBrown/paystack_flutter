library paystack_flutter;

import 'package:flutter/material.dart';
import 'package:paystack_flutter/src/models/paystack_callback.dart';
import 'package:paystack_flutter/src/paystack_webview.dart';

class PaystackFlutter {

  Future<void> pay({
    required BuildContext context,

    required String secretKey,

    required double amount,

    required String email,

    String? reference,

    bool? confirmTransaction,

    required String callbackUrl,

    dynamic metaData,

    required Function(PaystackCallback) onSuccess,

    required Function(PaystackCallback) onCancelled,
}) async {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return PaystackWebview(
          secretKey: secretKey,
          email: email,
          amount: amount,
          reference: reference,
          confirmTransaction: confirmTransaction,
          callbackUrl: callbackUrl,
          metaData: metaData,
          onSuccess: onSuccess,
          onCancelled: onCancelled,
        );
    }));
  }
}
