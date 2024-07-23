class AuthResponse {
  final AccessToken accessToken;
  final RefreshToken refreshToken;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: AccessToken.fromJson(json['data']['accessToken']),
      refreshToken: RefreshToken.fromJson(json['data']['refreshToken']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken.toJson(),
      'refreshToken': refreshToken.toJson(),
    };
  }
}

class AccessToken {
  final String token;
  final int expiredIn;

  AccessToken({
    required this.token,
    required this.expiredIn,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      token: json['token'],
      expiredIn: json['expiredIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiredIn': expiredIn,
    };
  }
}

class RefreshToken {
  final String token;
  final int expiredIn;

  RefreshToken({
    required this.token,
    required this.expiredIn,
  });

  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    return RefreshToken(
      token: json['token'],
      expiredIn: json['expiredIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expiredIn': expiredIn,
    };
  }
}
