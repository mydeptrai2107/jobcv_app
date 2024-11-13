import 'package:flutter/material.dart';

void notifaceError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.warning),
                              Expanded(
                                  child:
                                      Text(message))
                            ],
                          ),
                        ));
}