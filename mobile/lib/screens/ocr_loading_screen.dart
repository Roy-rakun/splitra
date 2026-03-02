import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:splitra_lst/utils/theme.dart';
import 'package:splitra_lst/services/api_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'review_receipt_screen.dart';
import 'dart:convert';
import 'add_expense_screen.dart';

class OcrLoadingScreen extends StatefulWidget {
  final String imagePath;
  final bool isPersonalExpense;
  const OcrLoadingScreen({Key? key, required this.imagePath, this.isPersonalExpense = false}) : super(key: key);

  @override
  State<OcrLoadingScreen> createState() => _OcrLoadingScreenState();
}

class _OcrLoadingScreenState extends State<OcrLoadingScreen> {
  String statusText = "Reading receipt...";

  @override
  void initState() {
    super.initState();
    _startLoadingSequence();
  }

  void _startLoadingSequence() async {
    // 1. Ekstraksi Teks Lokal menggunakan ML Kit Text Detection
    String extractedText = "";
    try {
      final inputImage = InputImage.fromFilePath(widget.imagePath);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      extractedText = recognizedText.text;
      await textRecognizer.close();
    } catch (e) {
      debugPrint("OCR ML Kit Error: \$e");
    }

    if (mounted) {
      setState(() {
        statusText = "Parsing items and prices..."; 
      });
    }

    // 2. Hubungi Backend Endpoint LLM Gemini
    Map<String, dynamic>? aiParsedData;
    try {
      final response = await ApiService.post('/bills/parse', {
         'ocr_text': extractedText
      });
      
      if (response.statusCode == 200) {
          final resData = jsonDecode(response.body);
          aiParsedData = resData['data'];
      } else {
          debugPrint("Failed to parse OCR: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error contacting Parse API: \$e");
    }

    // Done
    if (mounted) {
       if (widget.isPersonalExpense) {
          Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => AddExpenseScreen(parsedData: aiParsedData)),
          );
       } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ReviewReceiptScreen(parsedData: aiParsedData)),
          );
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Animasi OCR Mock
             Container(
               padding: const EdgeInsets.all(24),
               decoration: BoxDecoration(
                 color: AppTheme.cardWhite,
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(
                     color: AppTheme.primaryPink.withOpacity(0.1),
                     blurRadius: 30,
                     spreadRadius: 10,
                   )
                 ]
               ),
               child: Stack(
                 alignment: Alignment.center,
                 children: [
                   const CircularProgressIndicator(
                     color: AppTheme.primaryPink,
                     strokeWidth: 3,
                   ).animate().scaleXY(begin: 1, end: 1.5, duration: 1000.ms, curve: Curves.easeInOut).then().scaleXY(begin: 1.5, end: 1),
                   const Icon(Icons.document_scanner_outlined, size: 40, color: AppTheme.navyDark)
                     .animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .custom(
                        duration: 800.ms,
                        builder: (context, value, child) {
                           return Transform.translate(
                              offset: Offset(0, -5 + (value * 10)),
                              child: child,
                           );
                        }
                     ),
                 ],
               ),
             ).animate().fadeIn(),
             
             const SizedBox(height: 40),
             
             Text(
                statusText,
                style: GoogleFonts.inter(
                  color: AppTheme.navyDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
             ).animate(key: ValueKey(statusText)).fadeIn(duration: 300.ms).slideY(begin: 0.1),
             
             const SizedBox(height: 12),
             
             Text(
               "Tenang, semua item bisa lo edit manual setelah ini. ✨",
               style: GoogleFonts.inter(
                  color: AppTheme.greyText,
                  fontSize: 14,
               ),
               textAlign: TextAlign.center,
             ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
