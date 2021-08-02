class Album {
  late String? id;
  late String? name;
  late String? owner;

  Album(this.id, this.name, this.owner);

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['galleryname'];
    owner = json['owner'];
  }
}
