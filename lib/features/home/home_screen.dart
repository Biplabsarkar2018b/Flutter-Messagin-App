import 'package:chatty/api/auth_repo.dart';
import 'package:chatty/common/utils/loading_screen.dart';
import 'package:chatty/features/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  void signOut() {
    ref.read(authRepoProvider.notifier).signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(authRepoProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Container(
              padding: EdgeInsets.all(size.width * 0.01),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const LoadingScreen()
          : StreamBuilder<QuerySnapshot>(
              stream: usersCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null || snapshot.data!.size == 0) {
                  return Text('No users found.');
                }
                // print(snapshot.data!.docs[0].data());
                return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, int index) {
                      final user = snapshot.data!.docs[index];
                      
                      return ListTile(
                        title: Text(user['displayName']),
                        subtitle: Text(user['isActive'].toString()),
                        onTap: () {
                          
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: [user.reference.id]);
                        },
                      );
                    });
              }),
    );
  }
}
