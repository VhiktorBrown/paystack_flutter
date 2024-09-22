// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

/// This class represents a Paystack payment callback, containing information about a transaction.
/// It provides the reference and access code for the transaction.
class PaystackCallback {
  /// The unique reference of the transaction.
  final String reference;

  /// The access code associated with the transaction.
  final String accessCode;

  /// Creates a new PaystackCallback object.
  ///
  /// [reference] is required and represents the unique reference of the transaction.
  /// [accessCode] is required and represents the access code associated with the transaction.
  PaystackCallback({
    required this.reference,
    required this.accessCode,
  });
}
