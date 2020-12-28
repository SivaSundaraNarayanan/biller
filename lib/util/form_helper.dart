import 'dart:async';

import 'package:biller/util/constant_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class FormHelper {
  static Widget getInputField({
    @required BuildContext context,
    @required String Function(String) validator,
    TextEditingController controller,
    bool multilines = false,
    InputDecoration decoration,
    String hint = "",
    int maxLength,
    TextInputType keyboardType,
    bool disabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(
            hint,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              // color: Colors.grey[600],
            ),
          ),
        ),
        TextFormField(
          validator: validator,
          autofocus: true,
          enabled: !disabled,
          maxLength: maxLength,
          minLines: multilines ? 1 : null,
          maxLines: multilines ? 3 : null,
          controller: controller,
          textCapitalization: multilines
              ? TextCapitalization.sentences
              : TextCapitalization.words,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType ?? TextInputType.name,
          decoration: decoration,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  static Widget getAutoCompleteField({
    TextEditingController controller,
    Widget headerAction,
    String hint = '',
    @required FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback,
    @required Widget Function(BuildContext, dynamic) itemBuilder,
    @required void Function(dynamic) onSuggestionSelected,
    InputDecoration decoration,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              headerAction,
            ],
          ),
        ),
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: decoration,
            controller: controller,
          ),
          suggestionsCallback: suggestionsCallback,
          keepSuggestionsOnLoading: false,
          loadingBuilder: (BuildContext context) {
            return Container(
              height: 72,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          itemBuilder: itemBuilder,
          onSuggestionSelected: onSuggestionSelected,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  static Widget getDropDownField({
    @required BuildContext context,
    List<DropdownMenuItem<String>> items,
    String hint = "",
    InputDecoration decoration,
    Function(String) onChanged,
    String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(
            hint,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              // color: Colors.grey[600],
            ),
          ),
        ),
        DropdownButtonFormField(
          decoration: decoration,
          items: items,
          onChanged: onChanged,
          value: value,
        ),
      ],
    );
  }

  static Widget getDatePicker({
    String hint = "",
    @required DateTime selectedDate,
    @required BuildContext context,
    @required Function(DateTime) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(
            hint,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.blue,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat(ConstantHelper.dateFormat).format(selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDatePicker(
                    initialDatePickerMode: DatePickerMode.day,
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  ).then((date) {
                    onSelect(date);
                  });
                },
                icon: Icon(
                  Icons.date_range,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static InputDecoration getInputDecoration({
    String error,
    @required BuildContext context,
    Widget prefix,
    Widget suffix,
  }) {
    return InputDecoration(
      prefix: prefix,
      suffix: suffix,
      errorText: error,
      contentPadding: EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  static Widget getFormCard({
    @required List<Widget> children,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Card(
          elevation: 2.5,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  static Widget getSubmitButton({
    @required BuildContext context,
    @required void Function() onPressed,
  }) {
    return FloatingActionButton.extended(
      heroTag: 'Fab',
      onPressed: onPressed,
      label: Text('ADD'),
      icon: Icon(Icons.add),
    );
  }
}

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
          ),
          hintText: 'Search',
          filled: true,
          fillColor: Colors.grey[300],
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
