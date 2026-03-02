import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'ocr_loading_screen.dart';

class ScannerScreen extends StatefulWidget {
  final bool isPersonalExpense;
  const ScannerScreen({Key? key, this.isPersonalExpense = false}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
        
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOutSine,
    ));

    _scanAnimationController.repeat(reverse: true);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back, color: AppTheme.navyDark),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Camera View
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _isCameraInitialized && _cameraController != null
                ? CameraPreview(_cameraController!)
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "Initializing Camera...",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  ),
          ),
          
          // Overlay Scanner Bounding Box
          Center(
            child: Stack(
              children: [
                // Sudut-sudut merah mockup
                Container(
                  width: 300,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      // Top Left
                      Positioned(
                        top: 0, left: 0,
                        child: _buildCorner(isTop: true, isLeft: true),
                      ),
                      // Top Right
                      Positioned(
                        top: 0, right: 0,
                        child: _buildCorner(isTop: true, isLeft: false),
                      ),
                      // Bottom Left
                      Positioned(
                        bottom: 0, left: 0,
                        child: _buildCorner(isTop: false, isLeft: true),
                      ),
                      // Bottom Right
                      Positioned(
                        bottom: 0, right: 0,
                        child: _buildCorner(isTop: false, isLeft: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Animated Scanning Line (Garis Merah Bergerak)
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Positioned(
                top: 150 + (_scanAnimation.value * 380), // Sesuaikan range tinggi
                left: 40,
                right: 40,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPink,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPink.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // Shutter Button di Bawah
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                   if (_isCameraInitialized && _cameraController != null) {
                      try {
                        final image = await _cameraController!.takePicture();
                        if (mounted) {
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OcrLoadingScreen(imagePath: image.path, isPersonalExpense: widget.isPersonalExpense)));
                        }
                      } catch (e) {
                        debugPrint("Error taking picture: $e");
                      }
                   }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryPink.withOpacity(0.5), width: 3),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPink.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Ionicons.scan_outline, color: Colors.white, size: 36),
                  ).animate().scaleXY(begin: 0.9, end: 1.0, duration: 800.ms, curve: Curves.easeInOut).then().scaleXY(begin: 1.0, end: 0.9, duration: 800.ms, curve: Curves.easeInOut),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
           top: isTop ? BorderSide(color: AppTheme.primaryPink, width: 4) : BorderSide.none,
           left: isLeft ? BorderSide(color: AppTheme.primaryPink, width: 4) : BorderSide.none,
           right: !isLeft ? BorderSide(color: AppTheme.primaryPink, width: 4) : BorderSide.none,
           bottom: !isTop ? BorderSide(color: AppTheme.primaryPink, width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(20) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(20) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(20) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }
}
