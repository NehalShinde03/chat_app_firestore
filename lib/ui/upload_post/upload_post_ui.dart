import 'package:flutter/material.dart';

class UploadPostUi extends StatefulWidget {
  const UploadPostUi({super.key});

  static const String routeName = '/upload_post_ui';
  static Widget builder(BuildContext context) => UploadPostUi();

  @override
  State<UploadPostUi> createState() => _UploadPostUiState();
}

class _UploadPostUiState extends State<UploadPostUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Post"),),
    );
  }
}
