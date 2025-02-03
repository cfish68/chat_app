import 'package:chat_app/repositories/message_repository.dart';
import 'package:chat_app/service/app_state.dart';
import 'package:chat_app/service/messageService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'pages/chatScreen.dart';
import 'pages/settingScreen.dart';
import 'pages/callScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        // Provide the UserState using ChangeNotifierProvider (if needed)
        ChangeNotifierProvider(
          create: (context) => UserState(),
        ),
        // Provide the MessageRepository at the top level
        Provider<MessageRepository>(
            create: (_) => MessageRepository(authService: UserState())),
        // Use ProxyProvider to create MessageService
        ChangeNotifierProxyProvider<MessageRepository, MessageService>(
          // create: (_) => MessageService(
          //     messageRepository: MessageRepository(authService: UserState())),
          create: (context) {
            final messageRepository =
                Provider.of<MessageRepository>(context, listen: false);
            final messageService =
                MessageService(messageRepository: messageRepository);
            messageService.init(); // Call init here
            return messageService;
          },
          update: (context, messageRepository, messageService) {
            messageService?.init();
            return messageService!;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<UserState>(
        builder: (context, userState, _) => true//userState.loggedIn
            ? MyAppPage(title: 'Flutter Demo Home Page')
            : signInPage(),
      ),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key, required this.title});

  final String title;

  @override
  State<MyAppPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyAppPage> {
  int _selectedPage = 0;

  final List<Widget> _screens = [chatScreen(), CallScreen(), SettingScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final userState = Provider.of<UserState>(context);
    return  Scaffold(
            body: IndexedStack(
              index: _selectedPage,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedPage,
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_sharp), label: 'Chats'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.call), label: 'Calls'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Settings'),
                ]));
  }
}
