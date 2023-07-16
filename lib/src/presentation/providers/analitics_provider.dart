import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Provider<FirebaseAnalytics> analyticsProvider =
    Provider((ref) => FirebaseAnalytics.instance);
