class MetaData {

  final String imageUrl;
  final String title;
  final String description;
  final String url;
  final String favUrl;

  MetaData(this.imageUrl, this.title, this.description, this.url, this.favUrl);

  factory MetaData.empty() => MetaData('', '', '', '', '');

  MetaData copyWithImage(String imageUrl) =>
      MetaData(imageUrl, title, description, url, favUrl);

  MetaData copyWithTitle(String title) =>
      MetaData(imageUrl, title, description, url, favUrl);

  MetaData copyWithDescription(String description) =>
      MetaData(imageUrl, title, description, url, favUrl);

  MetaData copyWithUrl(String url) =>
      MetaData(imageUrl, title, description, url, favUrl);

  MetaData copyWithFavUrl(String favUrl) =>
      MetaData(imageUrl, title, description, url, favUrl);

  Map<String, dynamic> toJson() => {
    'image_url': imageUrl,
    'title': title,
    'description': description,
    'url': url,
    'fav_url': favUrl
  };

}
