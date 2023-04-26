class User {
  final String id;
  final String name;
  final String email;
  final String upiId;
  final bool isKYCVerified;
  final int credibilityScore;

  static const empty = const User(isKYCVerified: false,credibilityScore: 0,id: "-1",email: "",name: "",upiId: "");

  const User({
      required this.id,
    required this.name,
      required this.email,
      required this.upiId,
      required this.credibilityScore,
      required this.isKYCVerified});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['email'] = this.email;
    data['upi_id'] = this.upiId;
    data['isKYCVerified'] = this.isKYCVerified;
    data['credibility_core'] = this.credibilityScore;
    return data;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        id: json['id'],
        upiId: json['upi_id'],
        credibilityScore: json['credibility_score'],
        isKYCVerified: json['isKYCVerified']);
  }
}
