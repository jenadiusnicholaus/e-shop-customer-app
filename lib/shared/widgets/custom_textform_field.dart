// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      this.lableText,
      this.controller,
      this.keyboardType,
      this.obscureText,
      this.readOnly,
      this.maxLines,
      this.maxLength,
      this.validator,
      this.onSaved,
      this.onChanged,
      this.onTap,
      this.suffixIcon,
      this.prefixIcon,
      this.suffix,
      this.prefix,
      this.contentPadding,
      this.padding,
      this.hintText,
      this.enabled,
      this.initialValue});

  final String? lableText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;

  final String? initialValue;

  final bool? enabled;

  dynamic brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = brightness == Brightness.dark;
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      initialValue: initialValue,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: lableText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffix: suffix,
        prefix: prefix,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(.5),
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(.5),
        ),
        contentPadding: contentPadding ?? const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
