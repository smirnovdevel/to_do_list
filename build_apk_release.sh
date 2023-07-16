echo 'Starting developer build apk'
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --release --target lib/main_dev.dart
echo 'apk developer build done'