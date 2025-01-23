import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // เพิ่ม Google Maps API Key ที่นี่
    GMSServices.provideAPIKey("AIzaSyBqCSDj6uncmfNSNQn2an_10WD2IRTpPZU")
    
    // ลงทะเบียน Plugins
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
