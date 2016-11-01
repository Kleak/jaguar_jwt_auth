// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_jst_auth.src;

import 'package:dart_jwt/dart_jwt.dart';
import 'package:jaguar/jaguar.dart';
import "package:crypto/crypto.dart" as Crypto;

part 'provider.dart';
part 'password_hasher.dart';

/// Interceptor to authenticate requests using JWT
///
/// Property [provider] provides information about JWT
/// Property [audience] provides a list of expected audience
@InterceptorClass()
class JwtAuthHeader extends Interceptor {
  /// JWT provider
  final JwtHelper provider;

  /// List of expected audience
  final List<String> audience;

  const JwtAuthHeader(this.provider, this.audience);

  @InputHeaders()
  JsonWebToken pre(Map<String, String> headers) {
    String token = headers[provider.tokenName];

    //Validate token
    if(!provider.isTokenValid(token, audience)) {
      //TODO raise unauth error
      throw new Exception("Auth failed!");
    }

    //Decode and provide token
    return provider.decodeToken(token)
        .claimSet.toJson();
  }
}

