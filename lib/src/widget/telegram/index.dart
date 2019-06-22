part of link_preview;

class TelegramLinkPreview extends PreviewLink {
  build(String url) {
    return this.render(url, (dynamic body) {
      return TelegramView(
        imageUrl: body['image_url'],
        title: body['title'],
        url: body['url'],
        description: body['description'],
      );
    });
  }
}
