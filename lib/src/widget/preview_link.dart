part of link_preview;

class PreviewLink {
  AsyncMemoizer memoizer;
  MetadataProvider provider;
  PreviewLink() {
    provider = MetadataProvider();
    this.memoizer = AsyncMemoizer();
  }

  Widget render(String url, Function widget) {
    return FutureBuilder(
      future: this.getFuture('metaData', {'url': url}),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasError ? Container() : widget(snapshot.data)
            : Container();
      },
    );
  }

  getFuture(String name, dynamic params) {
    return this.memoizer.runOnce(() async {
      return (await provider.fetchMetadata(params['url'])).toJson();
    });
  }
}
