import Flutter
import UIKit

public class HeifConverterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "heif_converter", binaryMessenger: registrar.messenger())
    let instance = HeifConverterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "convert") {
      let input = call.arguments as! Dictionary<String, Any>
      let path = input["path"] as! String
      let output = input["output"] as! String
      result(convert(path, output))
    }
  }

  func convert(path: String, output: String) -> String? {
      let image : UIImage? = UIImage(named: path)
      if image == nil {
        return nil
      }
      let imageData = image!.jpegData(compressionQuality: 1.0)
      FileManager.default.createFile(atPath: output, contents: imageData, attributes: nil)
      return output
  }
}
