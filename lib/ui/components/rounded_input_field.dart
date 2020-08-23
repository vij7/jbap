import 'package:flutter/material.dart';

import 'package:jobapp/constants.dart';
import 'package:jobapp/ui/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Color color;
  final Color iconcolor;
  final ValueChanged<String> onSaved;
  final ValueChanged<String> validator;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  const RoundedInputField({
    Key key,
    this.hintText,
    // this.icon = Icons.person,
    this.icon,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.color = kPrimaryLightColor,
    this.iconcolor = kPrimaryColor,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: iconcolor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
