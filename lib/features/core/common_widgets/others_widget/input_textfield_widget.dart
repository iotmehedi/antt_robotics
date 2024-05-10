import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/signup_page/riverpod_provider/provider.dart';

class InputTextfiledWidget extends ConsumerWidget {
  final String? label;
  final String? hint;
  final bool? iconStatus;
  final String? inputType;
  final String? function;
  final int? length;
  final String? specialCharacter;
  final String? keyWord;

  InputTextfiledWidget({
    super.key,
    this.label,
    this.hint,
    this.iconStatus,
    this.inputType,
    this.function,
    this.length,
    this.specialCharacter,
    this.keyWord,
  });
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    if (controller.text.isEmpty) {
      controller.text = function!;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
    return Consumer(builder: (context, ref, child) {
      return TextField(
        inputFormatters: inputType == "number"
            ? [
                LengthLimitingTextInputFormatter(length),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [
                LengthLimitingTextInputFormatter(length),
                FilteringTextInputFormatter.deny(RegExp(specialCharacter!)),
              ],
        controller: controller,
        cursorColor: Colors.black,
        obscureText: keyWord == 'password'
            ? !ref.watch(passwordVisibility)
            : keyWord == 'confirmPassword'
                ? !ref.watch(confirmPasswordVisibility)
                : false,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400),
        keyboardType: keyWord == 'email'
            ? TextInputType.emailAddress
            : inputType == "number"
                ? const TextInputType.numberWithOptions(
                    signed: true, decimal: false)
                : TextInputType.text,
        maxLines: 1,
        onChanged: (value) {
          if (keyWord == "email") {
            ref.read(email.notifier).state = value;
          } else if (keyWord == "password") {
            ref.read(password.notifier).state = value;
          } else if (keyWord == "confirmPassword") {
            ref.read(confirmPassword.notifier).state = value;
          } else if (label == "Min Age") {
            // Handle logic for "Min Age"
          } else if (label == "Max Age") {
            // Handle logic for "Max Age"
          }
        },
        decoration: InputDecoration(
          labelStyle:
              TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(.60)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.orange,
                width: 10.0,
              ),
              borderRadius: BorderRadius.circular(4.0)),
          labelText: label,
          fillColor: Colors.black,
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0xffFFFFFF).withOpacity(.60)),
          suffixIcon: keyWord == 'password'
              ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    ref.watch(passwordVisibility)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    widgetRef.read(passwordVisibility.notifier).state =
                        !widgetRef.read(passwordVisibility.notifier).state;
                  },
                )
              : keyWord == 'confirmPassword'
                  ? IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        ref.watch(confirmPasswordVisibility)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        widgetRef
                                .read(confirmPasswordVisibility.notifier)
                                .state =
                            !widgetRef
                                .read(confirmPasswordVisibility.notifier)
                                .state;
                      },
                    )
                  : null,
          // errorText: snapshot.error,
        ),
        key: Key('${keyWord}'),
      );
    });
  }
}
