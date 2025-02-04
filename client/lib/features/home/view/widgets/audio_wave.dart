import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer();
    } else {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
          ),
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: playerController, // Use playerController here
            playerWaveStyle: const PlayerWaveStyle(
              liveWaveColor: Color(0xff45859d),
              fixedWaveColor: Pallete.borderColor,
              showSeekLine: false,
              spacing: 6,
            ),
            enableSeekGesture: true, // Make sure gestures are enabled properly
          ),
        ),
      ],
    );
  }
}
