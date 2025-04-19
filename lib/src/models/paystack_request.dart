// Created by Victor on 09/09/2024.
// Modified by Victor on 04/19/2025.
// Copyright (c) 2024 Elite Developers.
// All rights reserved.

/// This class represents a payment request object used for interacting with the Paystack payment gateway.
/// It contains the necessary information to initiate a payment transaction.
class PaystackRequest {
  /// The amount to be charged in the smallest currency unit (e.g., kobo for Nigeria).
  /// This is a required field.
  final double amount;

  /// The customer's first name.
  final String? firstName;

  /// The customer's last name.
  final String? lastName;

  /// The customer's email address for the transaction.
  /// This is a required field.
  final String email;

  /// A unique reference for the transaction. If not provided, Paystack will generate one.
  final String? reference;

  /// A URL to which Paystack will redirect the user after the transaction.
  /// This overrides the callback URL set in your Paystack dashboard (Required).
  final String callback;

  /// **Payment Options (channels):**
  ///
  /// A list of strings specifying the payment channels allowed for the transaction.
  /// If not included, payment channels already set on your Paystack dashboard will be used.
  ///
  /// **Available Payment Channels:**
  ///
  /// - [card] Allows payment with debit/credit cards.
  /// - [bank] Allows payment via bank.
  /// - [ussd] Allows payment via USSD mobile banking.
  /// - [mobile_money] Allows payment via mobile money wallets (e.g., Mpesa, MTN Mobile Money).
  /// - [bank_transfer] Allows payment via bank transfers with temporary bank accounts generated on the fly.
  /// - [qr] Allows payment via QR codes.
  /// - [eft] Allows electronic funds transfer
  ///
  /// **Example:**
  /// ```dart
  /// PaystackRequest(
  ///   amount: 1000.00,
  ///   email: "[email address]",
  ///   callback: "[callback URL]",
  ///   channels: ["card", "bank"],
  /// );
  /// ```
  final List<String>? channels;

  /// The currency used for the transaction. If omitted, it defaults to NGN (Nigerian Naira).
  ///
  /// **Supported Currencies:**
  ///
  /// - [NGN] (Nigerian Naira)
  /// - [USD] (US Dollar)
  /// - [EUR] (Euro)
  /// - [GHS] (Ghanaian Cedi)
  /// - [ZAR] (South African Rand)
  /// - [KES] (Kenyan Shilling)
  ///
  final String? currency;

  /// Any additional metadata you want to associate with the transaction.
  /// This can be a map of key-value pairs (optional).
  dynamic metaData;

  /// Creates a new PaystackRequest object.
  ///
  /// [amount] is required and represents the amount to be charged.
  ///
  /// [firstName] is optional and represents the first name of the customer.
  ///
  /// [lastName] is optional and represents the last name of the customer.
  ///
  /// [email] is required and represents the customer's email address.
  ///
  /// [reference] is optional and represents a unique reference for the transaction.
  ///
  /// [callback] is optional and represents a URL to redirect the user after the transaction.
  ///
  /// [channels] is optional and represents the payment options that are permitted for the transaction - bank transfer,
  /// ussd, etc. If not included, payment channels already set on the dashboard is used.
  ///
  /// [currency] is optional and represents the currency used for the transaction. If omitted, it defaults to NGN(Nigerian Naira).
  ///
  /// [metaData] is optional and represents any additional metadata you want to associate with the transaction.
  PaystackRequest({
    required this.amount,
    this.firstName,
    this.lastName,
    required this.email,
    this.reference,
    required this.callback,
    this.metaData,
    this.channels,
    this.currency,
  });

  /// Updates or adds the provided key-value pair to the `metadata`.
  /// Ensures `metaData` is a Map before adding the data.
  void updateMetadata(String key, String value) {
    if (metaData == null) {
      metaData = {}; // Initialize as an empty Map if not already set
    } else if (metaData is! Map) {
      throw ArgumentError('metaData must be a Map');
    }
    metaData[key] = value;
  }

  /// Converts the PaystackRequest object to a JSON map suitable for sending to the Paystack API.
  Map<String, dynamic> toJson() {
    // Call updateMetadata to ensure the "cancel_action" key-value pair is added
    updateMetadata(
        "cancel_action", "https://github.com/VhiktorBrown/paystack_flutter");

    final Map<String, dynamic> baseJson = {
      "amount": amount,
      "email": email,
      "callback_url": callback
    };

    //check if the first name and last name are passed
    List<CustomField> customFields = [];
    if(firstName != null){
      customFields.add(
        CustomField(
            displayName: 'Customer Name',
            variableName: 'customer_name',
            value: firstName!)
      );
    }
    // if(lastName != null){
    //   customFields.add(
    //       CustomField(
    //           displayName: 'Last Name',
    //           variableName: 'last_name',
    //           value: lastName!)
    //   );
    // }
    metaData['custom_fields'] =
        customFields.map((field) => field.toJson()).toList();

    /// Only include optional fields if they have a value.
    // if(firstName != null){
    //   baseJson["first_name"] = firstName;
    // }
    // if(lastName != null){
    //   baseJson["last_name"] = lastName;
    // }
    if (reference != null) {
      baseJson["reference"] = reference;
    }
    if (metaData != null) {
      baseJson["metadata"] = metaData;
    }
    if (channels != null && channels!.isNotEmpty) {
      baseJson["channels"] = channels!;
    }
    if (currency != null) {
      baseJson["currency"] = currency!;
    }

    return baseJson;
  }
}


class CustomField {
  final String displayName;
  final String variableName;
  final String value;
  CustomField({
    required this.displayName,
    required this.variableName,
    required this.value,
});

  Map<String, dynamic> toJson() => {
    'display_name': displayName,
    'variable_name': variableName,
    'value': value,
  };
}