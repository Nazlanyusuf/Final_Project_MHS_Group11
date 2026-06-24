import 'package:flutter/material.dart';

abstract class RefreshablePage extends StatefulWidget {
  const RefreshablePage({super.key});
}

abstract class RefreshablePageState<T extends RefreshablePage> extends State<T> {
  void refresh();
}
