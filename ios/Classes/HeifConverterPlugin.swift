import Flutter
import UIKit

public class HeifConverterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "heif_converter", binaryMessenger: registrar.messenger())
    let instance = HeifConverterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "convert":
      guard let input = call.arguments as? Dictionary<String, Any>,
            let path = input["path"] as? String else {
        result(FlutterError(code: "illegalArgument", message: "Invalid arguments.", details: nil))
        return
      }
      var output: String?
      if let o = input["output"] as? String, !o.isEmpty {
        output = o
      }
      var format: String?
      if let f = input["format"] as? String, !f.isEmpty {
        format = f
      }
      if output == nil {
        if let fmt = format {
          output = NSTemporaryDirectory().appendingFormat("%d.%@", Int(Date().timeIntervalSince1970 * 1000), fmt)
        } else {
          result(FlutterError(code: "illegalArgument", message: "Output path and format is blank.", details: nil))
          return
        }
      }
      let converted = convert(path: path, output: output!)
      if converted == nil {
        result(FlutterError(code: "conversionFailed", message: "Failed to convert image: \(path)", details: nil))
      } else {
        result(converted)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func convert(path: String, output: String) -> String? {
    guard let image = UIImage(contentsOfFile: path) else {
      return nil
    }
    let imageData: Data?
    if output.hasSuffix(".jpg") || output.hasSuffix(".jpeg") {
      imageData = image.jpegData(compressionQuality: 1.0)
    } else {
      imageData = image.pngData()
    }
    guard let data = imageData else {
      return nil
    }
    FileManager.default.createFile(atPath: output, contents: data, attributes: nil)
    return output
  }
}
