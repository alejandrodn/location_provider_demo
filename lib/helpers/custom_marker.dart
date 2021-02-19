import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getAssetImageMarker() async {
  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 5),
    'assets/images/custom-pin.png',
  );
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final resp = await Dio().get(
      "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png",
      options: Options(responseType: ResponseType.bytes));

  final bytes = resp.data;

  final imageCodec =
      await instantiateImageCodec(bytes, targetHeight: 150, targetWidth: 150);
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
