/// This class represents a payment request object used for interacting with the Paystack payment gateway.
/// It contains the necessary information to initiate a payment transaction.
class PaystackRequest {
  /// The amount to be charged in the smallest currency unit (e.g., kobo for Nigeria).
  /// This is a required field.
  final double amount;

  /// The customer's email address for the transaction.
  /// This is a required field.
  final String email;

  /// A unique reference for the transaction. If not provided, Paystack will generate one.
  final String? reference;

  /// A URL to which Paystack will redirect the user after the transaction.
  /// This overrides the callback URL set in your Paystack dashboard (Required).
  final String callback;

  /// Any additional metadata you want to associate with the transaction.
  /// This can be a map of key-value pairs (optional).
  final dynamic metaData;

  /// Creates a new PaystackRequest object.
  ///
  /// [amount] is required and represents the amount to be charged.
  /// [email] is required and represents the customer's email address.
  /// [reference] is optional and represents a unique reference for the transaction.
  /// [callback] is optional and represents a URL to redirect the user after the transaction.
  /// [metaData] is optional and represents any additional metadata you want to associate with the transaction.
  PaystackRequest({
    required this.amount,
    required this.email,
    this.reference,
    required this.callback,
    this.metaData,
  });

  /// Converts the PaystackRequest object to a JSON map suitable for sending to the Paystack API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> baseJson = {
      "amount": amount,
      "email": email,
      "callback_url": callback
    };

    /// Only include optional fields if they have a value.
    if (reference != null) {
      baseJson["reference"] = reference;
    }
    if (metaData != null) {
      baseJson["metadata"] = metaData;
    }

    return baseJson;
  }
}