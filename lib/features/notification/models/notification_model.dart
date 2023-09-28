import 'package:flutter/material.dart';

bool notifNew = false;
List<Row> notif = []; //have to change into firebase

void notifAdd(String mes, String name) {
  notifNew = true;
  notif.add(Row(
    children: [
      Text(mes, style: const TextStyle(fontSize: 20.0)),
      Text(name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))
    ],
  ));
}
