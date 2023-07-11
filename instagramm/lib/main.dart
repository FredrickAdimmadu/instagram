import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramm/providers/user_provider.dart';
import 'package:instagramm/responsive/mobile_screen_layout.dart';
import 'package:instagramm/responsive/responsive_layout.dart';
import 'package:instagramm/responsive/web_screen_layout.dart';
import 'package:instagramm/screens/login_screen.dart';
import 'package:instagramm/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagramm/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize app based on platform- web or mobile

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBZSM4Zn50SXPpf1xv_uWfv4U1AKcJmBzI',
        appId: '1:1056062674368:web:18c6e70c12adedb4d26425',
        messagingSenderId: '1056062674368',
        projectId: 'instagram-8be62',
        storageBucket: 'instagram-8be62.appspot.com',
      ),
    );
  } else {

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if the snapshot has data, which means the user is logged in,
                // then we check the width of the screen and display the appropriate layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to the future hasn't been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
