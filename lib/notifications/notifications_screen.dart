import 'dart:io';

import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button_2.dart';
import 'package:admin_review/notifications/notification_controller.dart';
import 'package:flutter/material.dart';

import 'image_picker_view.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _bodyTextEditingController =
      TextEditingController();
  File _selectedImage;

  _onImageSelection(File image) {
    _selectedImage = image;
  }

  _onSendPressed() async {
    if (_titleTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification title is required')),
      );
    } else if (_bodyTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification body is required')),
      );
    } else {
      String message = await NotificationController.sendPushNotification(
          title: _titleTextEditingController.text,
          body: _bodyTextEditingController.text,
          image: _selectedImage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Push Notifications'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(
            height: 20,
          ),
          _AppTextField(
            controller: _titleTextEditingController,
            hint: 'Notification Title',
          ),
          const SizedBox(
            height: 40,
          ),
          _AppTextField(
            controller: _bodyTextEditingController,
            hint: 'Notification Body',
            isMultiLine: true,
          ),
          const SizedBox(
            height: 40,
          ),
          ImagePickerView(
            onImageSelection: _onImageSelection,
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomButton2('Send Notification', _onSendPressed),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}

class _AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isMultiLine;
  final TextInputType keyboardType;
  _AppTextField(
      {Key key,
      this.hint,
      this.controller,
      this.isMultiLine = false,
      this.keyboardType})
      : super(key: key);

  @override
  __AppTextFieldState createState() => __AppTextFieldState();
}

class __AppTextFieldState extends State<_AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: OutlineInputBorder(borderSide: BorderSide()),
      ),
      maxLines: widget.isMultiLine ? 5 : 1,
      keyboardType: widget.keyboardType,
    );
  }
}
