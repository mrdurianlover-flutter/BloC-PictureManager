const String pictureBaseUrl =
    "https://pic-dev.courthias.space/api/v1/picture/img/";

class Picture {
  late String? id;
  late String? owner;
  late String? title;
  late String? url;
  late String? thumbnail;
  late DateTime? createdAt;
  List<String> tags = [];

  Picture(
    this.id,
    this.owner,
    this.title,
    this.url,
    this.thumbnail,
    this.createdAt,
    this.tags,
  );

  Picture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    title = json['name'];
    url = pictureBaseUrl + json['photo'];
    thumbnail = pictureBaseUrl + json['thumbnail'];
    createdAt = DateTime.parse(json['createdAt']);
    for (String tag in json['tags']) {
      if (tag != "EMPTY_TAG") tags.add(tag);
    }
  }
}
