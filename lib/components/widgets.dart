import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

snackBar(@required context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration:const Duration(milliseconds: 600),
  ));
}

