# 5999 Boyfriends Saver - 男友拍照救星

開啟後直接讀相機畫面，偵測人臉位置，顯示構圖指引，提示手機應該怎麼移動來拍出好照片。

## 核心功能

1. **全螢幕相機預覽** — 後鏡頭即時畫面
2. **即時人臉偵測** — Google ML Kit 人臉偵測，取得 bounding box
3. **構圖指引**：
   - 三分法格線 overlay
   - 方向提示（Move Left/Right/Up/Down, Come Closer, Step Back）
   - 構圖分數 0-100%（臉部中心與三分法交叉點的距離）

## 技術架構

- **Framework**: Flutter 3.27.4
- **相機**: `camera` package
- **人臉偵測**: `google_mlkit_face_detection`
- **目標平台**: iOS + Android

## 檔案結構

```
lib/
├── main.dart                  # App 入口
├── camera_screen.dart         # 相機畫面 + 主邏輯
├── face_detector_service.dart # ML Kit 人臉偵測封裝
├── composition_analyzer.dart  # 構圖分析（三分法 + 建議）
└── overlay_painter.dart       # 疊加層繪製（格線 + 提示文字）
```

## 編譯

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# iOS
flutter build ios
```

## 環境需求

- Flutter SDK 3.27+
- Android SDK (minSdk 21)
- JDK 17
