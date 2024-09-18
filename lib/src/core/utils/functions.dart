export 'package:paystack_flutter/src/core/utils/functions.dart';

// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

enum PaymentOption {
  card,
  bank,
  bankTransfer,
  ussd,
  mobileMoney,
  eft,
  qr,
}

enum Currency {
  NGN,
  USD,
  GHS,
  ZAR,
  KES,
}

/// convert List of PaymentOptions to List of Strings
List<String>? convertPaymentOptionEnumToString(List<PaymentOption>? options){
  List<String> stringOptions = [];
  if(options != null && options.isNotEmpty){
    for(PaymentOption paymentOption in options){
      stringOptions.add(paymentOption.toPaymentOptionString());
    }
    return stringOptions;
  }else {
    return null;
  }
}

extension PaymentOptionExtension on PaymentOption {
  String toPaymentOptionString() {
    switch (this) {
      case PaymentOption.card:
        return "card";
      case PaymentOption. bank:
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

extension CurrencyExtension on Currency {
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