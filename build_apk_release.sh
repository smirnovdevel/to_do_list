echo 'Starting apk release build'
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --release --target lib/main_dev.dart
echo 'apk release build done'