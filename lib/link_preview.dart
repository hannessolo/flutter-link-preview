library link_preview;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:meta/meta.dart';
import 'package:async/async.dart';
import 'package:link_preview/src/repository/metadata_provider.dart';

part 'src/widget/preview_link.dart';
part 'src/widget/whatsapp/index.dart';
part 'src/widget/whatsapp/view.dart';
part 'src/widget/telegram/index.dart';
part 'src/widget/telegram/view.dart';
part 'src/widget/twitter/index.dart';
part 'src/widget/twitter/view.dart';
part 'src/widget/skype/index.dart';
part 'src/widget/skype/view.dart';
part 'src/widget/linkedin/index.dart';
part 'src/widget/linkedin/view.dart';

// Fetch meta data
Future<Map<String, dynamic>> fetchData(String url) async {
  return (await MetadataProvider().fetchMetadata(url)).toJson();
}

class LinkPreview {
  Future<Map<String, dynamic>> getUrlMetaData({@required String url}) async {
    // Run in new thread
    return await compute(fetchData, url);
  }
}
