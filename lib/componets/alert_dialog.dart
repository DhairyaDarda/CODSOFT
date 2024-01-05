// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:todo_list/componets/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;

  VoidCallback onSave;

  VoidCallback onCancel;

  DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[400],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Enter Task Name
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Create New Task Name"),
              ),

              // Save And Cancel Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Save Button
                  MyButton(
                    text: 'Save',
                    onPressed: onSave,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  //Cancel Button
                  MyButton(
                    text: 'Cancel',
                    onPressed: onCancel,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
