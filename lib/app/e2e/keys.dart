import 'package:pointycastle/pointycastle.dart';

class MyPrivateKey extends RSAPrivateKey {
  MyPrivateKey(BigInt modulus, BigInt privateExponent, BigInt? p, BigInt? q)
      : super(modulus, privateExponent, p, q);
}

class MyPublicKey extends RSAPublicKey {
  MyPublicKey(BigInt modulus, BigInt exponent) : super(modulus, exponent);
}
