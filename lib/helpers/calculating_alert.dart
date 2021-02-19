import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void calculatingAlert(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Espere por favor"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Calculando ruta"), CircularProgressIndicator()],
        ),
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Espere por favor"),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Calculando ruta"), CupertinoActivityIndicator()],
          ),
        ),
      ),
    );
  }
}
