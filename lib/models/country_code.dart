class CountryCode {
  final String name;
  final String flagUri;
  final String code;
  final String dialCode;

  CountryCode({
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      code: json['code'],
      dialCode: json['dial_code'],
      flagUri: 'flags/${json['code'].toLowerCase()}.png',
    );
  }
}
