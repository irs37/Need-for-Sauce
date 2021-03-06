part of models;

class NhentaiResults {
  NhentaiResults({
    this.result,
    this.numPages,
    this.perPage,
  });

  List<NhentaiResult> result;
  int numPages;
  int perPage;

  factory NhentaiResults.fromJson(Map<String, dynamic> json) => NhentaiResults(
        result: json["result"] == null
            ? null
            : List<NhentaiResult>.from(
                json["result"].map((x) => NhentaiResult.fromJson(x))),
        numPages: json["num_pages"],
        perPage: json["per_page"],
      );
}

class NhentaiResult {
  NhentaiResult({
    this.id,
    this.mediaId,
    this.title,
    this.images,
    this.scanlator,
    this.uploadDate,
    this.tags,
    this.numPages,
    this.numFavorites,
  });

  int id;
  String mediaId;
  NhentaiTitle title;
  NhentaiImages images;
  String scanlator;
  int uploadDate;
  List<NhentaiTag> tags;
  int numPages;
  int numFavorites;

  factory NhentaiResult.fromJson(Map<String, dynamic> json) => NhentaiResult(
        id: (json["id"] is int) ? json['id'] : int.parse(json['id']),
        mediaId: json["media_id"],
        title:
            json["title"] == null ? null : NhentaiTitle.fromJson(json["title"]),
        images: json["images"] == null
            ? null
            : NhentaiImages.fromJson(json["images"]),
        scanlator: json["scanlator"],
        uploadDate: json["upload_date"],
        tags: json["tags"] == null
            ? null
            : List<NhentaiTag>.from(
                json["tags"].map((x) => NhentaiTag.fromJson(x))),
        numPages: json["num_pages"],
        numFavorites: json["num_favorites"],
      );

  static Future<NhentaiResult> getInfo(String source) async {
    var response;

    try {
      response = await Sauce.nhentai().get(
          '/api/galleries/search?query=${Uri.encodeQueryComponent(source.replaceAll(RegExp(r'\s-'), ' ').replaceAll(RegExp(r'(?<=\s)(_*?)(?=\s)'), '|'))}');
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.connectTimeout:
          {
            throw NoInfoException("Connection timeout");
          }
        case DioErrorType.response:
        case DioErrorType.cancel:
        case DioErrorType.other:
          {
            throw NoInfoException("Couldn't connect to nhentai.net");
          }
      }
    }

    if (response != null && response.data["result"].isNotEmpty) {
      return NhentaiResult.fromJson(response.data["result"][0]);
    } else {
      return null;
    }
  }

  static List<String> getTags(List<NhentaiTag> tags) {
    List<NhentaiTag> filteredTags =
        tags.where((e) => (e.type == Type.TAG)).toList();

    return filteredTags.map((e) => e.name).toList();
  }
}

class NhentaiImages {
  NhentaiImages({
    this.pages,
    this.cover,
    this.thumbnail,
  });

  List<NhentaiCover> pages;
  NhentaiCover cover;
  NhentaiCover thumbnail;

  factory NhentaiImages.fromJson(Map<String, dynamic> json) => NhentaiImages(
        pages: json["pages"] == null
            ? null
            : List<NhentaiCover>.from(
                json["pages"].map((x) => NhentaiCover.fromJson(x))),
        cover:
            json["cover"] == null ? null : NhentaiCover.fromJson(json["cover"]),
        thumbnail: json["thumbnail"] == null
            ? null
            : NhentaiCover.fromJson(json["thumbnail"]),
      );
}

class NhentaiCover {
  NhentaiCover({
    this.t,
    this.w,
    this.h,
  });

  T t;
  int w;
  int h;

  factory NhentaiCover.fromJson(Map<String, dynamic> json) => NhentaiCover(
        t: tValues.map[json["t"]],
        w: json["w"],
        h: json["h"],
      );
}

enum T { J, P, G }

final tValues = EnumValues({"g": T.G, "j": T.J, "p": T.P});

class NhentaiTag {
  NhentaiTag({
    this.id,
    this.type,
    this.name,
    this.url,
    this.count,
  });

  int id;
  Type type;
  String name;
  String url;
  int count;

  factory NhentaiTag.fromJson(Map<String, dynamic> json) => NhentaiTag(
        id: json["id"],
        type: nhentaiTypeValues.map[json["type"]],
        name: json["name"],
        url: json["url"],
        count: json["count"],
      );
}

enum Type { LANGUAGE, PARODY, GROUP, ARTIST, TAG, CATEGORY, CHARACTER }

final nhentaiTypeValues = EnumValues({
  "artist": Type.ARTIST,
  "category": Type.CATEGORY,
  "character": Type.CHARACTER,
  "group": Type.GROUP,
  "language": Type.LANGUAGE,
  "parody": Type.PARODY,
  "tag": Type.TAG
});

class NhentaiTitle {
  NhentaiTitle({
    this.english,
    this.japanese,
    this.pretty,
  });

  String english;
  String japanese;
  String pretty;

  factory NhentaiTitle.fromJson(Map<String, dynamic> json) => NhentaiTitle(
        english: json["english"],
        japanese: json["japanese"],
        pretty: json["pretty"],
      );
}
