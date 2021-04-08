import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetBuilder<SettingsController>(
          builder: (settingsController) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    key: Key(
                        "${settingsController.currentTheme}${settingsController.currentApiKey}"),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "set key...",
                          labelStyle: TextStyle(
                            color: Get.theme.textTheme.bodyText1.color
                                .withOpacity(0.5),
                          ),
                        ),
                        initialValue: settingsController.apiKey.value,
                        onChanged: (val) {
                          settingsController.setApiKey(val);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "set theme...",
                          labelStyle: TextStyle(
                            color: Get.theme.textTheme.bodyText1.color
                                .withOpacity(0.5),
                          ),
                        ),
                        initialValue: settingsController.theme.value,
                        onChanged: (val) {
                          settingsController.setTheme(val);
                        },
                      ),
                    ],
                  ),
                ),
                settingsController.theme.value !=
                            settingsController.currentTheme &&
                        settingsController.apiKey.value !=
                            settingsController.currentApiKey
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  settingsController.allSettingsUpdate();
                                },
                                child: Text("Save"),
                              ),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                settingsController.setDefault();
                              },
                              child: Text("Reset"),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
