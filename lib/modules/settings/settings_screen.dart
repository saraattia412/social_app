import 'package:flutter/material.dart';
import '../../shared/cubit/cubit.dart';

import '../../shared/components/app_bar_design.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
        title: 'Profile Settings',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Row(
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                    ),
                    SizedBox(width: 5,),
                    const Text(
                      'Dark Mode',
                    ),
                  ],
                ),
                Switch(
                  value: AppCubit.get(context).isDark,
                  onChanged: (isDarkModeEnabled) {
                    AppCubit.get(context).changeAppMode();
                  },

                ),

              ],
            ),
            //dark mode design
          ],
        ),
      ),
    );
  }
}
