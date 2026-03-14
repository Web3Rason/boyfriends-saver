# 任務進度

## 2026-03-14
- [x] 安裝 Flutter SDK 3.27.4 到 C:\flutter
- [x] 安裝 JDK 17 到 C:\jdk-17.0.14+7
- [x] 安裝 Android SDK 到 C:\Android（platforms-34, build-tools-34.0.0）
- [x] 建立 Flutter 專案 5999_Boyfriends_Saver
- [x] 加入依賴：camera, google_mlkit_face_detection
- [x] 實作 main.dart — App 入口，強制直式
- [x] 實作 camera_screen.dart — 相機預覽 + 人臉偵測整合
- [x] 實作 face_detector_service.dart — ML Kit 人臉偵測封裝
- [x] 實作 composition_analyzer.dart — 三分法構圖分析 + 方向提示
- [x] 實作 overlay_painter.dart — 格線 + 臉框 + 方向提示 + 分數繪製
- [x] 設定 Android 相機權限（AndroidManifest.xml）
- [x] 設定 iOS 相機權限（Info.plist）
- [x] 設定 Android minSdk = 21
- [x] flutter analyze — 零問題
- [x] flutter test — 2 tests passed
- [x] flutter build apk --debug — 編譯成功

## 待辦
- [ ] 實機測試相機 + 人臉偵測
- [ ] 拍照功能（按鈕拍照）
- [ ] 前後鏡頭切換
