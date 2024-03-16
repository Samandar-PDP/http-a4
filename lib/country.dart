class Country {
  String? name;
  String? flag;
  String? capital;
  String? population;
  String? ccode;
  String? desc;
  String? ncode;
  String? currency;
  String? id;

  Country(
      {this.name,
        this.flag,
        this.capital,
        this.population,
        this.ccode,
        this.ncode,
        this.desc,
        this.currency,
        this.id});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flag = json['flag'];
    capital = json['capital'];
    population = json['population'];
    ccode = json['ccode'];
    ncode = json['ncode'];
    desc = json['desc'];
    currency = json['currency'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['name'] = this.name;
    data['flag'] = this.flag;
    data['capital'] = this.capital;
    data['population'] = this.population;
    data['ccode'] = this.ccode;
    data['ncode'] = this.ncode;
    data['desc'] = this.desc;
    data['currency'] = this.currency;
    data['id'] = this.id;
    return data;
  }
}