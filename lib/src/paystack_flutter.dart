library paystack_flutter;

import 'package:flutter/material.dart';
import 'package:paystack_for_flutter/src/core/utils/functions.dart';
import 'package:paystack_for_flutter/src/models/paystack_callback.dart';
import 'package:paystack_for_flutter/src/paystack_webview.dart';

// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

/// The PaystackFlutter class provides a convenient way to integrate Paystack payments into your Flutter applications.
/// It handles the initialization of the payment process, navigation to the Paystack webview, and callback handling.
class PaystackFlutter {
  ///
  /// **Required parameters:**
  ///
  /// - [context] The current build context.
  /// - [secretKey] Your Paystack secret key.
  /// - [amount] The amount to be charged in the smallest currency unit. If amount is 600, multiply by 100(600*100)
  /// - [email] The customer's email address.
  /// - [callbackUrl] The URL to which Paystack will redirect the user after the transaction.
  /// - [onSuccess] A callback function to be called when the payment is successful.
  /// - [onCancelled] A callback function to be called when the payment is canceled.
  ///
  /// **Optional parameters:**
  ///
  /// - [showProgressBar] If true, it shows progress bar to inform user an action is in progress when getting checkout link from Paystack.
  /// - [reference] A custom reference for the transaction.
  /// - [paymentOptions] A list of payment options allowed for the transaction.
  ///     - **Available Payment Options:**
  ///       - [PaymentOption.card] Allows payment with debit/credit cards.
  ///       - [PaymentOption.bank] Allows payment via bank.
  ///       - [PaymentOption.bankTransfer] Allows payment via bank transfer (alternative to `bank`).
  ///       - [PaymentOption.ussd] Allows payment via USSD mobile banking.
  ///       - [PaymentOption.mobileMoney] Allows payment via mobile money wallets (e.g., Mpesa, MTN Mobile Money).
  ///       - [PaymentOption.eft] Allows payment via EFT (Electronic Funds Transfer).
  ///       - [PaymentOption.qr] Allows payment via QR codes.
  ///
  /// - [currency] The currency used for the transaction. If omitted, it uses the default Currency of the country associated with your Paystack account.
  ///     - **Supported Currencies:**
  ///       - [Currency.NGN] (Nigerian Naira)
  ///       - [Currency.USD] (US Dollar)
  ///       - [Currency.GHS] (Ghanaian Cedi)
  ///       - [Currency.ZAR] (South African Rand)
  ///       - [Currency.KES] (Kenyan Shilling)
  /// - [confirmTransaction] Whether to confirm the transaction before redirecting the user.
  /// - [metaData] Additional metadata to be associated with the transaction.
  ///
  /// Initiates a Paystack payment process.
  Future<void> pay({
    /// The current build context.
    required BuildContext context,

    /// Your Paystack secret key.
    required String secretKey,

    /// The amount to be charged in the smallest currency unit.
    required double amount,

    /// The customer's email address.
    required String email,

    /// A custom reference for the transaction.
    String? reference,

    /// Shows progress bar if true, when fetching authorization URL from Paystack.
    bool? showProgressBar,

    /// A list of payment options allowed for the transaction.
    /// See the documentation for available options.
    List<PaymentOption>? paymentOptions,

    /// The currency used for the transaction.
    /// See the documentation for supported currencies.
    Currency? currency,

    /// Whether to confirm the transaction before redirecting the user.
    bool? confirmTransaction,

    /// The URL to which Paystack will redirect the user after the transaction.
    required String callbackUrl,

    /// Additional metadata to be associated with the transaction.
    dynamic metaData,

    /// A callback function to be called when the payment is successful.
    required Function(PaystackCallback) onSuccess,

    /// A callback function to be called when the payment is canceled.
    required Function(PaystackCallback) onCancelled,
  }) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaystackWebview(
          secretKey: secretKey,
          email: email,
          amount: amount,
          reference: reference,
          showProgressBar: showProgressBar,
          confirmTransaction: confirmTransaction,
          paymentOptions: paymentOptions,
          currency: currency,
          callbackUrl: callbackUrl,
          metaData: metaData,
          onSuccess: onSuccess,
          onCancelled: onCancelled,
        ),
      ),
    );
  }
}
