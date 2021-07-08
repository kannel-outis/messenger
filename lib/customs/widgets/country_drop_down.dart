import 'package:flutter/material.dart';
import 'package:messenger/models/country_code.dart';

class CountryDropDown extends StatelessWidget {
  final List<CountryCode>? listOfCodes;

  final CountryCode? value;
  final Function(CountryCode?)? onChanged;
  const CountryDropDown(
      {Key? key, this.listOfCodes, this.value, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: DropdownButton<CountryCode>(
          dropdownColor: Colors.grey,
          value: value ?? listOfCodes![0],
          underline: SizedBox(),
          elevation: 0,
          isExpanded: false,
          items: listOfCodes!
              .map(
                (e) => DropdownMenuItem<CountryCode>(
                  value: e,
                  child: Container(
                    width: 70,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          child: Image.asset(e.flagUri!),
                        ),
                        SizedBox(width: 5),
                        Container(child: Text(e.dialCode!))
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
