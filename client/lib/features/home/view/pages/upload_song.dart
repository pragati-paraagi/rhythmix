// import 'package:client/core/theme/app_pallete.dart';
import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/view/widgets/loading.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSong extends ConsumerStatefulWidget {
  const UploadSong({super.key});

  @override
  ConsumerState<UploadSong> createState() => _UploadSongState();
}

class _UploadSongState extends ConsumerState<UploadSong> {
  // TextEditingControllers for SongName and Artist fields
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedThumbnail;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();
  void selectAudio() async{
     final pickedAudio = await pickAudio();
    if (pickedAudio!= null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async{
    final pickedImage = await pickImage();
    if (pickedImage!= null) {
      setState(() {
        selectedThumbnail = pickedImage;
      });
    }

  }
  

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewModelProvider.select((val)=> val?.isLoading == true));
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Upload Song',style: TextStyle(color: Colors.white54),),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white54),
            onPressed: () async{
               if(formKey.currentState!.validate() && selectedAudio!=null && selectedThumbnail!=null){
                ref.read(homeViewModelProvider.notifier).uploadSong(selectedAudio: selectedAudio!, 
               selectedThumbnail: selectedThumbnail!, 
               songName: songNameController.text, 
               artist: artistController.text, 
               selectedColor: selectedColor);
               }
               else{
                 showDialog(
                     context: context,
                     barrierDismissible: false,
                     builder: (context) => AlertDialog(
                         title: Text('Error'),
                         content: Text('Please fill all required fields'),
                         actions: <Widget>[
                           ElevatedButton(
                             onPressed: () {},
                             child: Text('OK'),
                           ),
                         ],
                     ),
                 );
               }
            },
          ),
        ],
      ),
      body: isLoading? Loader() : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedThumbnail!=null ? SizedBox(height:150, width: double.infinity, child:  ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedThumbnail!, fit:BoxFit.cover))):  DottedBorder(
                          color: Color(0xff45859d),
                          radius: Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          dashPattern: [10, 4],
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40, color: Color(0xff45859d),),
                                SizedBox(height: 15),
                                Text("Select the thumbnail",style: TextStyle(color: Color(0xff45859d)),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      selectedAudio!=null? AudioWave(path: selectedAudio!.path) :
                      // Using the custom input widget for PickSong (no controller)
                      CustomTextField(
                        label: "Pick Song",
                        isReadOnly: true,
                        onTap: selectAudio, // onTap for PickSong
                      ),
                  
                      SizedBox(height: 20),
                  
                      // Using the custom input widget for SongName (with controller)
                      CustomTextField(
                        label: "Song Name",
                        controller: songNameController,  // Controller for SongName
                        isReadOnly: false,
                      ),
                  
                      SizedBox(height: 20),
                  
                      // Using the custom input widget for Artist (with controller)
                      CustomTextField(
                        label: "Artist",
                        controller: artistController,  // Controller for Artist
                        isReadOnly: false,
                      ),
                      SizedBox(height: 25),
                      ColorPicker(
                        
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                        },
                        color:selectedColor,
                        onColorChanged: (Color color){
                           setState(() {
                             selectedColor = color;
                           });
                      },
                       
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }
}

