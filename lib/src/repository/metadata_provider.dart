import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:link_preview/src/repository/model/metadata.dart';

class MetadataProvider {

  Future<MetaData> fetchMetadata(String url) async {
    final response = await http.get(url);
    final document = parse(response.body);

    var elements = document.getElementsByTagName('meta');
    MetaData data = MetaData.empty();

    for (var el in elements) {
      if (!el.attributes.containsKey('property')) {
        continue;
      }
      var type = el.attributes['property'];
      switch (type) {
        case 'og:title':
          data = data.copyWithTitle(el.attributes['content']);
          break;
        case 'og:description':
          data = data.copyWithDescription(el.attributes['content']);
          break;
        case 'og:url':
          data = data.copyWithUrl(el.attributes['content']);
          break;
        case 'og:image':
          data = data.copyWithImage(el.attributes['content']);
          break;
      }
    }

    if (data.url == '') {
      data = data.copyWithUrl(url);
    }

    return data;
  }
}
