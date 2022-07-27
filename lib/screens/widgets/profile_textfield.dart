import 'package:flutter/material.dart';

class profile_textfield extends StatelessWidget {
  var validator;

  var onTap;

  var hintText;

  var labelText;

  IconData? prefixIcon;

  profile_textfield({
    Key? key,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.onTap,
    this.validator,
    this.name,
  }) : super(key: key);

  final TextEditingController? name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onTap: onTap,
      controller: name,
      decoration: InputDecoration(
        hintText: hintText,
        // helperText: '',
        labelText: labelText,

        fillColor: Color.fromARGB(255, 182, 222, 255),
        filled: true,
        hoverColor: Color.fromARGB(255, 0, 140, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // icon: Icon(
        //   Icons.circle,
        //   size: 13,
        // ),
        prefixIcon: Icon(prefixIcon),
        // suffixIcon: Icon(Icons.nam),
      ),
    );
  }
}
