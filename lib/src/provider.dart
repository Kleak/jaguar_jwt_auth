part of jaguar_jst_auth.src;

const String kJwtHeaderKey = 'Authorization';

class JwtInfo {
  final String tokenName;

  final String tokenSecret;

  final Duration tokenDuration;

  const JwtInfo(this.tokenSecret,
      {this.tokenName: kJwtHeaderKey, this.tokenDuration});
}

class JwtHelper {
  final JwtInfo info;

  String get tokenName => info.tokenName;

  String get tokenSecret => info.tokenSecret;

  Duration get tokenDuration => info.tokenDuration;

  const JwtHelper(this.info);

  JwaSymmetricKeySignatureContext get _signatureContext =>
      new JwaSymmetricKeySignatureContext(tokenSecret);

  /// Issues a token
  String issueToken(String issuer, String subject,
      {Duration duration, List<String> audience}) {
    DateTime issuedAt = new DateTime.now();
    if (duration == null) {
      duration = tokenDuration;
    }
    DateTime expiry = issuedAt.add(duration);
    final claimSet = new OpenIdJwtClaimSet.build(
        issuer: issuer,
        subject: subject,
        audience: audience,
        expiry: expiry,
        issuedAt: issuedAt);
    JsonWebToken jwt = new JsonWebToken.jws(claimSet, _signatureContext);
    return jwt.encode();
  }

  /// Issues custom token
  String issuerCustomToken(JwtClaimSet claimSet,
      {JwaSignatureContext signatureContext}) {
    JsonWebToken jwt =
        new JsonWebToken.jws(claimSet, signatureContext ?? _signatureContext);
    return jwt.encode();
  }

  /// Validates token
  bool isTokenValid(String token, List<String> audience) {
    if (token == null) {
      return false;
    }
    JsonWebToken jwt = decodeToken(token);
    OpenIdJwtClaimSet claimSet = jwt.claimSet;
    Set<ConstraintViolation> violations =
        claimSet.validate(const JwtClaimSetValidationContext());
    if (violations.isEmpty &&
        (claimSet?.audience == null || claimSet.audience.isEmpty)) {
      return true;
    }

    if (violations.isEmpty && claimSet?.audience != null) {
      for (String aud in claimSet.audience) {
        if (audience.contains(aud)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Decodes the token
  JsonWebToken decodeToken(String token) => new JsonWebToken.decode(token);
}
