class Secret{
  final String apikey;

  Secret({this.apikey = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(apikey: jsonMap["api_key"]);
  }
}