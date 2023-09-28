/* Import of necessary packages from Flutter (flutter/material.dart) and two
additional packages: audioplayers for audio playback and record for audio
recording.*/
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';

/* This defines a VoiceButton class which extends StatefulWidget. The class
takes several optional properties that can be passed when creating an instance
of this widget. These properties include buttonSize, buttonColor, size,
startRec, sendRec, and stopRec */
class VoiceButton extends StatefulWidget {
  /*declare an instance variable named buttonSize of type double. It is used to
  control the size of the button in the VoiceButton widget. By making it
  nullable, it allows the flexibility to either provide a specific size or not
  provide any size at all.*/
  final double? buttonSize;

  /*declare an instance variable named buttonColor of type Color. It is used to
  define the color of the button in the VoiceButton widget. By Making it
  nullable, it allows you to either provide a specific color value or omit
  the color altogether.*/
  final Color? buttonColor;

  /* define an instance variable named size of type double. This variable is
  used to determine the size of certain elements within the VoiceButton widget.
  Making it nullable provides the option to either provide a specific size
  value or not provide any size value at all.*/
  final double? size;

  /* declare an instance variable named startRec of type Function(). This
  variable is used to hold a reference to a function that can be called to
  start the voice recording functionality in the VoiceButton widget. Making it
  nullable provides flexibility to either provide a specific function reference
  or not provide any function reference at all.*/
  final Function()? startRec;

  /* declare an instance variable named sendRec of type Function(String path).
  This variable is used to hold a reference to a function that can be called to
  send the recorded audio data somewhere, likely for further processing or
  storage in the VoiceButton widget.*/
  final Function(String path)? sendRec;

  /* declare an instance variable named stopRec of type Function(String? path).
  This variable is used to hold a reference to a function that can be called to
  stop the voice recording functionality in the VoiceButton widget and
  potentially provide a path to the recorded audio.*/
  final Function(String? path)? stopRec;

  /* This is the constructor for the VoiceButton class. It assigns the provided
  property values to the corresponding instance variables.*/
  const VoiceButton(
      {super.key,
      this.buttonColor,
      this.buttonSize,
      this.startRec,
      this.stopRec,
      this.size,
      this.sendRec});

  /* This method overrides the createState method and returns an instance of
  _VoiceButtonState. It also defines a static constant routeName for possible
  navigation purposes.*/
  @override
  // ignore: library_private_types_in_public_api
  _VoiceButtonState createState() => _VoiceButtonState();
  static const String routeName = '/voice-recording';
}

/* This class (_VoiceButtonState) represents the state for the VoiceButton
widget. It holds several state variables, including _isRecording to track the
recording status, instances of Record and AudioPlayer for recording and playing
audio, variables for button size, color, and size, and functions for sending,
starting, and stopping recording.*/
class _VoiceButtonState extends State<VoiceButton> {
  bool _isRecording = false;

  /*The following variables are declared as late because they are being used
  within the state class _VoiceButtonState of the VoiceButton widget.They are
  being initialized in the initState method.*/
  /*Define an instance of the Record class, used for managing audio recording
  functionality.*/
  late Record audioRecord;

  /* Define an instance of the AudioPlayer class, used for playing audio.*/
  late AudioPlayer audioPlayer;

  /*A nullable double used to store the size of a button in the widget.*/
  late double? _buttonSize;

  /*A nullable Color used to store the color of a button in the widget.*/
  late Color? _buttonColor;

  /* A nullable double used to store a size value for some element in the
  widget.*/
  late double? si;

  /*A function that takes a String parameter path and is used to send recorded
  audio data.*/
  late Function(String path) _send;

  /*A function with no parameters, used to initiate some action (starting audio
  recording).*/
  late Function() _start;

  /*A function that takes a nullable String parameter path and is used to stop
  some action (stopping audio recording) and handle the recorded path.*/
  late Function(String? path) _stop;

  /*This method is called when the state is initialized. It assigns initial
  values to state variables and initializes the audio player and recorder
  instances. It also sets default values for _start, _stop, _buttonColor,
  _buttonSize, si, and _send based on widget properties.*/
  @override
  void initState() {
    _start = widget.startRec ?? () {};
    _stop = widget.stopRec ?? (path) {};
    _buttonColor = widget.buttonColor;
    _buttonSize = widget.buttonSize;
    si = widget.size;
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    _send = widget.sendRec ?? (path) {};
    super.initState();
  }

  /* This method is called when the state is disposed, allowing you to release
  resources. It disposes of the audio recorder and player instances.*/
  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  /*This method is called to start audio recording. It checks if the app has
  permission to record audio, starts the recording, updates UI and state
  variables, and sets _isRecording to true. */
  Future<void> _startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          _buttonSize = widget.buttonSize! * 1.2;
          _buttonColor = Colors.red;
          _start;
          _isRecording = true;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error Start Recording : $e');
    }
  }

  /*This method is called to stop audio recording. It stops the recording,
  updates UI and state variables, calls _stop, _send, and sets _isRecording
  to false. */
  Future<void> _stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        _buttonSize = widget.buttonSize!;
        _buttonColor = widget.buttonColor!;
        _stop(path);
        _send(path!);
        _isRecording = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error Stopping Record : $e');
    }
  }

  /*This method builds the UI for the VoiceButton widget. It uses a
  GestureDetector to capture long press events for starting and stopping
  recording. Inside the widget tree, there's an AnimatedContainer that animates
  changes in size and color. It also contains an Icon that displays a
  microphone icon depending on the recording state. The build method is
  overriding the build method from the StatefulWidget*/
  @override
  Widget build(
      BuildContext
          context) /*This is the build method, which is required to create and
          return the widget's user interface. It takes a BuildContext named
          context as a parameter.*/
  {
    /*This line starts the return statement and returns a GestureDetector
    widget. A GestureDetector is used to detect various gestures on its child
    widget.*/
    return GestureDetector(
      /*This is a property of the GestureDetector widget. It specifies a
      callback that will be executed when a long press gesture starts. The
      _startRecording function is called when this gesture occurs.*/
      onLongPressStart: (_) => _startRecording(),

      /*This is another property of the GestureDetector widget. It specifies a
      callback that will be executed when a long press gesture ends. The
      _stopRecording function is called when this gesture ends.*/
      onLongPressEnd: (_) => _stopRecording(),

      /*specifies the main content of the widget, which is an AnimatedContainer.
      An AnimatedContainer is a container that can animate its properties
      smoothly over time.*/
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds:
              100, /*This specifies the duration over which the animations
                in the AnimatedContainer will take place. In this case, it's
                set to 100 milliseconds.*/
        ),

        /*Set the width and height of the AnimatedContainer to the _buttonSize
        value. This will animate the container's size based on the value of
        _buttonSize.*/
        width: _buttonSize,
        height: _buttonSize,

        /*This sets the decoration of the AnimatedContainer. It includes a
        circular shape with a background color _buttonColor and a shadow.*/
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _buttonColor,
          boxShadow: const [
            BoxShadow(
              /*This is a definition of a shadow effect for the
                AnimatedContainer. It has an offset, blur radius, and color
                properties.*/
              offset: Offset(0, 4.0),
              blurRadius: 5,
              color: Colors.black26,
            )
          ],
        ),
        child: Icon(
          /*This is the child of the AnimatedContainer, which is an Icon widget.
          The icon displayed depends on whether _isRecording is true or false.
          If _isRecording is true, it shows a microphone icon (Icons.mic),
          otherwise, it shows a microphone-off icon (Icons.mic_none).*/
          _isRecording ? Icons.mic : Icons.mic_none,
          size: si,
          /*set the size and color of the Icon based on the values of
          the si and default Colors.white.*/

          color: Colors.white,
        ),
      ),
    );
  }
}
