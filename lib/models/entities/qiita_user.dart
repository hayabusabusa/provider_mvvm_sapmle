class QiitaUser {
  final String name;
  final String profileImageURL;

  QiitaUser({
    this.name,
    this.profileImageURL
  });

  static QiitaUser fromJson(Map<String, dynamic> json) {
    return QiitaUser(
      name: json['name'],
      profileImageURL: json['profile_image_url'],
    );
  }
}