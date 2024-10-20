
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{
  static String get bannerAdUnitId {
    if(Platform.isAndroid){
      // Test ad unit id later change to my
      return "ca-app-pub-4372330859692195/6068409508";
    } else if(Platform.isIOS){
      // Test ad unit id later change to my ad unit id
      return "ca-app-pub-4372330859692195/3006932201";
    } else{
      throw UnsupportedError('Unsupported platform');
    }
  }

  // initializing mobile ads
  Future<InitializationStatus> initAd(){
    return MobileAds.instance.initialize();
  }
}