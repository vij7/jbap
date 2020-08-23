import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/ui/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onSaved;
  final ValueChanged<String> validator;
  final ValueChanged<String> onChanged;
  final onPressed;
  final TextInputType keyboardType;
  final Color color;
  final Color iconcolor;
  final bool obscureText;
  const RoundedPasswordField({
    Key key,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onPressed,
    this.keyboardType,
    this.color = kPrimaryLightColor,
    this.iconcolor = kPrimaryColor,
    this.obscureText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onSaved: onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: iconcolor,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: iconcolor,
              ),
              onPressed: onPressed),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
