import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0; // Corrected variable name for consistency
  final pages = [
    SongsPage(),
    LibraryPage()
  ];
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    print(user);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children:[ pages[selectedIndex] , Positioned(bottom: 0,child: MusicSlab(),)] ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        backgroundColor: Colors.black, // Set the bottom navigation bar color to black
        selectedItemColor: Colors.white, // Set the selected item color to white
        unselectedItemColor: Colors.grey, // Set the unselected item color to grey
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: selectedIndex == 0 ? Colors.white : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_music,
              color: selectedIndex == 1 ? Colors.white : Colors.grey,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
