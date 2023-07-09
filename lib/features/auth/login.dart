import 'package:chatty/api/auth_repo.dart';
import 'package:chatty/common/utils/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void signInWithGoogle() {
      ref.watch(authRepoProvider.notifier).googleSignIn(context);
    }

    final isLoading = ref.watch(authRepoProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 17, 52, 0.9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 17, 52, 0.9),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color.fromRGBO(7, 17, 52, 0.9),
        ),
      ),
      // appBar: ,
      body: isLoading
          ? const LoadingScreen()
          : Center(
              child: InkWell(
                onTap: signInWithGoogle,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login With Google',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Image.asset(
                        'assets/icons/google_icon.png',
                        width: size.width * 0.07,
                        height: size.height * 0.07,
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                          size.width * 0.009,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          size: size.width * 0.07,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
