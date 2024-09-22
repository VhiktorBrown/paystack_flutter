// Created by Victor on 09/09/2024.
// Copyright (c) 2024 Elite Developers.All rights reserved.

class PayStackResponse {
  bool status;
  String message;
  String authorizationUrl;
  String reference;
  String accessCode;
  PayStackResponse({
    required this.status,
    required this.message,
    required this.authorizationUrl,
    required this.reference,
    required this.accessCode,
  });

  factory PayStackResponse.fromJson(Map<String, dynamic> json) {
    return PayStackResponse(
      status: json['status'],
      message: json['message'],
      authorizationUrl: json['data']['authorization_url'],
      reference: json['data']['reference'],
      accessCode: json['data']['access_code'],
    );
  }
}
