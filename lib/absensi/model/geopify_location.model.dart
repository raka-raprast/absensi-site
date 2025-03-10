import 'dart:convert';

class GeopifyLocation {
  String? name;
  String? oldName;
  String? country;
  String? countryCode;
  String? state;
  String? county;
  String? city;
  String? postcode;
  String? street;
  String? housenumber;
  double? lon;
  double? lat;
  String? stateCode;
  double? distance;
  String? resultType;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  String? category;
  Timezone? timezone;
  String? plusCode;
  String? plusCodeShort;
  Rank? rank;
  String? placeId;

  GeopifyLocation({
    this.name,
    this.oldName,
    this.country,
    this.countryCode,
    this.state,
    this.county,
    this.city,
    this.postcode,
    this.street,
    this.housenumber,
    this.lon,
    this.lat,
    this.stateCode,
    this.distance,
    this.resultType,
    this.formatted,
    this.addressLine1,
    this.addressLine2,
    this.category,
    this.timezone,
    this.plusCode,
    this.plusCodeShort,
    this.rank,
    this.placeId,
  });

  GeopifyLocation copyWith({
    String? name,
    String? oldName,
    String? country,
    String? countryCode,
    String? state,
    String? county,
    String? city,
    String? postcode,
    String? street,
    String? housenumber,
    double? lon,
    double? lat,
    String? stateCode,
    double? distance,
    String? resultType,
    String? formatted,
    String? addressLine1,
    String? addressLine2,
    String? category,
    Timezone? timezone,
    String? plusCode,
    String? plusCodeShort,
    Rank? rank,
    String? placeId,
  }) =>
      GeopifyLocation(
        name: name ?? this.name,
        oldName: oldName ?? this.oldName,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
        state: state ?? this.state,
        county: county ?? this.county,
        city: city ?? this.city,
        postcode: postcode ?? this.postcode,
        street: street ?? this.street,
        housenumber: housenumber ?? this.housenumber,
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
        stateCode: stateCode ?? this.stateCode,
        distance: distance ?? this.distance,
        resultType: resultType ?? this.resultType,
        formatted: formatted ?? this.formatted,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        category: category ?? this.category,
        timezone: timezone ?? this.timezone,
        plusCode: plusCode ?? this.plusCode,
        plusCodeShort: plusCodeShort ?? this.plusCodeShort,
        rank: rank ?? this.rank,
        placeId: placeId ?? this.placeId,
      );

  factory GeopifyLocation.fromRawJson(String str) =>
      GeopifyLocation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeopifyLocation.fromJson(Map<String, dynamic> json) =>
      GeopifyLocation(
        name: json["name"],
        oldName: json["old_name"],
        country: json["country"],
        countryCode: json["country_code"],
        state: json["state"],
        county: json["county"],
        city: json["city"],
        postcode: json["postcode"],
        street: json["street"],
        housenumber: json["housenumber"],
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        stateCode: json["state_code"],
        distance: json["distance"]?.toDouble(),
        resultType: json["result_type"],
        formatted: json["formatted"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        category: json["category"],
        timezone: json["timezone"] == null
            ? null
            : Timezone.fromJson(json["timezone"]),
        plusCode: json["plus_code"],
        plusCodeShort: json["plus_code_short"],
        rank: json["rank"] == null ? null : Rank.fromJson(json["rank"]),
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "old_name": oldName,
        "country": country,
        "country_code": countryCode,
        "state": state,
        "county": county,
        "city": city,
        "postcode": postcode,
        "street": street,
        "housenumber": housenumber,
        "lon": lon,
        "lat": lat,
        "state_code": stateCode,
        "distance": distance,
        "result_type": resultType,
        "formatted": formatted,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "category": category,
        "timezone": timezone?.toJson(),
        "plus_code": plusCode,
        "plus_code_short": plusCodeShort,
        "rank": rank?.toJson(),
        "place_id": placeId,
      };
}

class Rank {
  double? importance;
  double? popularity;

  Rank({
    this.importance,
    this.popularity,
  });

  Rank copyWith({
    double? importance,
    double? popularity,
  }) =>
      Rank(
        importance: importance ?? this.importance,
        popularity: popularity ?? this.popularity,
      );

  factory Rank.fromRawJson(String str) => Rank.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        importance: json["importance"]?.toDouble(),
        popularity: json["popularity"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "importance": importance,
        "popularity": popularity,
      };
}

class Timezone {
  String? name;
  String? offsetStd;
  int? offsetStdSeconds;
  String? offsetDst;
  int? offsetDstSeconds;
  String? abbreviationStd;
  String? abbreviationDst;

  Timezone({
    this.name,
    this.offsetStd,
    this.offsetStdSeconds,
    this.offsetDst,
    this.offsetDstSeconds,
    this.abbreviationStd,
    this.abbreviationDst,
  });

  Timezone copyWith({
    String? name,
    String? offsetStd,
    int? offsetStdSeconds,
    String? offsetDst,
    int? offsetDstSeconds,
    String? abbreviationStd,
    String? abbreviationDst,
  }) =>
      Timezone(
        name: name ?? this.name,
        offsetStd: offsetStd ?? this.offsetStd,
        offsetStdSeconds: offsetStdSeconds ?? this.offsetStdSeconds,
        offsetDst: offsetDst ?? this.offsetDst,
        offsetDstSeconds: offsetDstSeconds ?? this.offsetDstSeconds,
        abbreviationStd: abbreviationStd ?? this.abbreviationStd,
        abbreviationDst: abbreviationDst ?? this.abbreviationDst,
      );

  factory Timezone.fromRawJson(String str) =>
      Timezone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
        name: json["name"],
        offsetStd: json["offset_STD"],
        offsetStdSeconds: json["offset_STD_seconds"],
        offsetDst: json["offset_DST"],
        offsetDstSeconds: json["offset_DST_seconds"],
        abbreviationStd: json["abbreviation_STD"],
        abbreviationDst: json["abbreviation_DST"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "offset_STD": offsetStd,
        "offset_STD_seconds": offsetStdSeconds,
        "offset_DST": offsetDst,
        "offset_DST_seconds": offsetDstSeconds,
        "abbreviation_STD": abbreviationStd,
        "abbreviation_DST": abbreviationDst,
      };
}
