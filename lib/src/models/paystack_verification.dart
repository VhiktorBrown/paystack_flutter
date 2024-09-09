class PaystackVerification {
  bool status;
  String message;
  String gatewayStatus;
  String gatewayResponse;
  PaystackVerification({
    required this.status,
    required this.message,
    required this.gatewayStatus,
    required this.gatewayResponse,
});

  factory PaystackVerification.fromJson(Map<String, dynamic> json){
    return PaystackVerification(
        status: json['status'],
        message: json['message'],
        gatewayStatus: json['data']['status'],
        gatewayResponse: json['data']['gateway_response']);
  }
}