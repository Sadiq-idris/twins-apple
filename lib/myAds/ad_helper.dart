
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{
  static String get bannerAdUnitId {
    if(Platform.isAndroid){
      // Test ad unit id later change to my
      return "ca-app-pub-3940256099942544/6300978111";
    } else if(Platform.isIOS){
      // Test ad unit id later change to my ad unit id
      return "ca-app-pub-3940256099942544/2934735716";
    } else{
      throw UnsupportedError('Unsupported platform');
    }
  }

  // initializing mobile ads
  Future<InitializationStatus> initAd(){
    return MobileAds.instance.initialize();
  }
}