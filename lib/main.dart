import 'package:chatty/common/providers.dart';
import 'package:chatty/common/utils/error_screen.dart';
import 'package:chatty/common/utils/loading_screen.dart';
import 'package:chatty/features/auth/login.dart';
import 'package:chatty/features/chat/chat_screen.dart';
import 'package:chatty/features/home/home_screen.dart';
import 'package:chatty/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authChangeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        // '/':(context)=>HomeScreen(),
        ChatScreen.routeName:(context)=>ChatScreen(),
      },
      home: authState.when(data: (user) {
        if (user != null) {
          return HomeScreen();
        } else {
          return const LoginScreen();
        }
      }, error: (e, st) {
        return ErrorScreen(error: e.toString(), st: st.toString());
      }, loading: () {
        return const LoadingScreen();
      }),
    );
  }
}
