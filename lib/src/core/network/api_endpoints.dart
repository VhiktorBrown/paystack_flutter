// base url

const baseUrl = 'https://api.paystack.co';

// paystack endpoints
class _PaystackEndpoints {
  final String initializeTransaction = '$baseUrl/transaction/initialize';
  String verifyTransaction(String reference) => '$baseUrl/transaction/verify/$reference';
}

//endpoints
final paystackEndpoints = _PaystackEndpoints();
