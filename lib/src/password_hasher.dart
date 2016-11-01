part of jaguar_jst_auth.src;

//TODO(Teja): add crypto algorithm chooser
/// Password hasher
class Hasher {
  final String salt;

  const Hasher(this.salt);

  String hash(String password) {
    String saltedPassword = password + salt;
    Crypto.Digest digest = Crypto.md5.convert(saltedPassword.codeUnits);
    return new String.fromCharCodes(digest.bytes);
  }

  /// Verifies the given password with given hash for the given salt
  bool verify(String pwd, String pwdHash) {
    return pwd == hash(pwdHash);
  }
}
