import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/sign_up.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
   final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // Remove the explicit `container` creation, as `ProviderScope` will manage it
  final container = ProviderContainer();  // Optional: you can remove this if not explicitly needed

  
    await container.read(authViewmodelProvider.notifier).initSharedPreferences();
    await container.read(authViewmodelProvider.notifier).getData();
  

  runApp(UncontrolledProviderScope(container:container,child:  const MyApp()));  // Only pass the child to `ProviderScope`
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rhythmix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.karlaTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: currentUser == null ? const SignUp() : HomePage(),
      // home: UploadSong(),
    );
  }
}
