part of link_preview;

class LinkedInLinkPreview extends PreviewLink {
  build(String url) {
    return this.render(url, (dynamic body) {
      return LinkedInView(
        imageUrl: body['image_url'],
        title: body['title'],
        url: body['url'],
        description: body['description'],
      );
    });
  }
}
