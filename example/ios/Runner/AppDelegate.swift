import UIKit
import Flutter
import SwiftSoup

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let controller: FlutterViewController = window.rootViewController as! FlutterViewController
    let previewChannel = FlutterMethodChannel(name: "plugins.flutter.io/link_preview", binaryMessenger: controller)

    previewChannel.setMethodCallHandler({
      [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "metaData" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterMethodNotImplemented)
        return
      }
      let url = args["url"] as? String
      self?.getLinkPreview(result: result, url: URL(string: url!)!)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
          } catch (Exception.Error(let type, let message)) {
            continue
          }
        }

        result(NSDictionary(dictionary: parsedString))
      } catch Exception.Error(let type, let message) {
        print(message)
      } catch {
        print("error")
        result(FlutterMethodNotImplemented)
      }
    }
    task.resume()
  }

}
