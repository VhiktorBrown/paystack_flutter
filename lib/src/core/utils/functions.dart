export 'package:paystack_for_flutter/src/core/utils/functions.dart';

// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

/// Enum representing the different payment options supported by Paystack.
enum PaymentOption {
  /// Pay using a credit or debit card.
  card,

  /// Pay directly from your bank account.
  bank,

  /// Pay using a bank transfer.
  bankTransfer,

  /// Pay using a USSD code.
  ussd,

  /// Pay using a mobile money wallet.
  mobileMoney,

  /// Pay using Electronic Funds Transfer (EFT).
  eft,

  /// Pay using a QR code.
  qr,
}

/// Enum representing the different currencies supported by Paystack.
enum Currency {
  /// Nigerian Naira (NGN).
  NGN,

  /// United States Dollar (USD).
  USD,

  /// Ghanaian Cedi (GHS).
  GHS,

  /// South African Rand (ZAR).
  ZAR,

  /// Kenyan Shilling (KES).
  KES,
}

/// Converts a list of [PaymentOption] enums to a list of corresponding strings.
/// Used for communication with Paystack API which expects string values.
List<String>? convertPaymentOptionEnumToString(List<PaymentOption>? options) {
  List<String> stringOptions = [];
  if (options != null && options.isNotEmpty) {
    for (PaymentOption paymentOption in options) {
      stringOptions.add(paymentOption.toPaymentOptionString());
    }
    return stringOptions;
  } else {
    return null;
  }
}

/// Extension methods for [PaymentOption] enum.
extension PaymentOptionExtension on PaymentOption {
  /// Converts the current [PaymentOption] enum value to a string representation
  /// expected by the Paystack API.
  String toPaymentOptionString() {
    switch (this) {
      case PaymentOption.card:
        return "card";
      case PaymentOption.bank:
        return "bank";
      case PaymentOption.bankTransfer:
        return "bank_transfer";
      case PaymentOption.qr:
        return "qr";
      case PaymentOption.mobileMoney:
        return "mobile_money";
      case PaymentOption.ussd:
        return "ussd";
      case PaymentOption.eft:
        return "eft";
      default:
        return "Unknown";
    }
  }
}

/// Extension methods for [Currency] enum.
extension CurrencyExtension on Currency {
  /// Converts the current [Currency] enum value to a string representation
  /// expected by the Paystack API.
  String toCurrencyString() {
    switch (this) {
      case Currency.NGN:
        return "NGN";
      case Currency.USD:
        return "USD";
      case Currency.GHS:
        return "GHS";
      case Currency.ZAR:
        return "ZAR";
      case Currency.KES:
        return "KES";
      default:
        return "Unknown";
    }
  }
}
