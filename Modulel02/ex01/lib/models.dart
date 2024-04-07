class City {
  final String name;
  final String region;
  final String country;

  City({required this.name, required this.region, required this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      region: json['region'],
      country: json['country'],
    );
  }
}
