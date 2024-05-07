import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_ai_chat/constants/key/gemini_api_key.dart';

class Start {
  Start._();
 static void init() {
    Gemini.init(apiKey: geminiApiKey);
  }
}
