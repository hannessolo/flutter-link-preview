import Flutter
import UIKit
import SwiftSoup

public class SwiftLinkPreviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.flutter.io/link_preview", binaryMessenger: registrar.messenger())
    let instance = SwiftLinkPreviewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
      result("iOS " + UIDevice.current.systemVersion)
    } else if (call.method == "metaData") {
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterMethodNotImplemented)
        return
      }
      let url = args["url"] as? String
      self.getLinkPreview(result: result, url: URL(string: url!)!)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

private func getLinkPreview(result: @escaping FlutterResult, url: URL) {

    var parsedString = [
      "image_url": "",
      "title": "",
      "url": "",
      "description": ""
    ]

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        return
      }
      do {
        let doc: Document = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        let metaTags: Elements = try doc.select("meta")

        for element: Element in metaTags {
          do {
            let metaType = try element.attr("property")
            switch metaType {
            case "og:title":
              parsedString["title"] = try element.attr("content")
              break
            case "og:description":
              parsedString["description"] = try element.attr("content")
              break
            case "og:image":
              parsedString["image_url"] = try element.attr("content")
              break
            default:
              continue
            }
          } catch (Exception.Error( _, _)) {
            continue
          }
        }

        result(NSDictionary(dictionary: parsedString))
      } catch Exception.Error(_, let message) {
        print(message)
      } catch {
        print("error")
        result(FlutterMethodNotImplemented)
      }
    }
    task.resume()
  }

}
