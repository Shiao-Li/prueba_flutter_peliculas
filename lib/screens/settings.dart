import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/login.dart';
import 'package:movies/theme/theme_state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);

    // Verifica si el usuario está autenticado
    User? user = _auth.currentUser;
    bool isLoggedIn = user != null;

    List<Color> borders = [Colors.black, Colors.white, Colors.white];
    List<Color> colors = [Colors.white, Color(0xff242248), Colors.black];
    List<String> themes = ['Light', 'Dark', 'Amoled'];

    return Theme(
      data: state.themeData,
      child: Container(
        color: state.themeData.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundColor: state.themeData.colorScheme.secondary,
                          radius: 40,
                          child: Icon(
                            isLoggedIn ? Icons.person : Icons.person_outline,
                            size: 40,
                            color: state.themeData.primaryColor,
                          ),
                        ),
                      ),
                      if (isLoggedIn)
                        Column(
                          children: [
                            Text(
                              user.email ?? '',
                              style: state.themeData.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                // Cerrar sesión
                                await _auth.signOut();
                                setState(() {});
                              },
                              child: Text('Log Out'),
                            ),
                          ],
                        )
                      else
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  themeData: state.themeData,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Log In / Sign Up',
                            style: state.themeData.textTheme.bodyLarge,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Theme',
                    style: state.themeData.textTheme.bodyLarge,
                  ),
                ],
              ),
              subtitle: SizedBox(
                height: 100,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: borders[index]),
                                      color: colors[index]),
                                ),
                              ),
                              Text(themes[index],
                                  style: state.themeData.textTheme.bodyLarge)
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      switch (index) {
                                        case 0:
                                          state.saveOptionValue(
                                              ThemeStateEnum.light);
                                          break;
                                        case 1:
                                          state.saveOptionValue(
                                              ThemeStateEnum.dark);
                                          break;
                                        case 2:
                                          state.saveOptionValue(
                                              ThemeStateEnum.amoled);

                                          break;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: state.themeData.primaryColor ==
                                            colors[index]
                                        ? Icon(Icons.done,
                                            color:
                                                state.themeData.colorScheme.secondary)
                                        : Container(),
                                  ),
                                ),
                              ),
                              Text(themes[index],
                                  style: state.themeData.textTheme.bodyLarge)
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
