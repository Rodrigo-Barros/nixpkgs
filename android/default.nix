with import <nixpkgs> {config.android_sdk.accept_license = true;};
androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "28";
  abiVersion = "x86"; # armeabi-v7a, mips, x86_64
  systemImageType = "google_apis_playstore";
}
