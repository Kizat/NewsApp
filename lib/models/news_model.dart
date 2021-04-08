import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) => List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsModelToJson(List<NewsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsModel {
    NewsModel({
        this.source,
        this.author,
        this.title,
        this.description,
        this.url,
        this.urlToImage,
        this.publishedAt,
        this.content,
    });

    Source source;
    String author;
    String title;
    String description;
    String url;
    String urlToImage;
    DateTime publishedAt;
    String content;

    NewsModel copyWith({
        Source source,
        String author,
        String title,
        String description,
        String url,
        String urlToImage,
        DateTime publishedAt,
        String content,
    }) => 
        NewsModel(
            source: source ?? this.source,
            author: author ?? this.author,
            title: title ?? this.title,
            description: description ?? this.description,
            url: url ?? this.url,
            urlToImage: urlToImage ?? this.urlToImage,
            publishedAt: publishedAt ?? this.publishedAt,
            content: content ?? this.content,
        );

    factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}

class Source {
    Source({
        this.id,
        this.name,
    });

    String id;
    String name;

    Source copyWith({
        String id,
        String name,
    }) => 
        Source(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
