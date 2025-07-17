# mobile_frontend

A new Flutter project.

---

# Building & Releasing the App for Production

## 1. Configure API Endpoint for AWS Production

**Where:**  
API/base URL should be injected at build time using a Dart environment variable.  
Recommended: Use `--dart-define` for Flutter (`const String apiBaseUrl = String.fromEnvironment('API_URL');` in your service classes; adjust code to read API URL via env).

**How to Adjust:**

- In your Dart code (e.g., service or config file), ensure API endpoint is sourced via:
  ```dart
  const String apiBaseUrl = String.fromEnvironment('API_URL', defaultValue: 'https://REPLACE_WITH_PROD_API_URL');
  ```
- When **building for production**, pass the backend endpoint:
  ```
  flutter build apk --release --dart-define=API_URL=https://<your-aws-backend-url>
  flutter build ios --release --dart-define=API_URL=https://<your-aws-backend-url>
  ```

*(If your API URL is currently hard-coded, refactor first to use the above technique!)*

---

## 2. Building the Production APK (Android)

- **Ensure you have the right signing keys** for Play Store (update `android/app/build.gradle.kts` or `key.properties` as needed).
- **Prod build**:
  ```
  flutter clean
  flutter pub get
  flutter build apk --release --dart-define=API_URL=https://<your-aws-backend-url>
  (output: `build/app/outputs/flutter-apk/app-release.apk`)
  ```
- **Optional:** Build App Bundle for Play Store:
  ```
  flutter build appbundle --release --dart-define=API_URL=https://<your-aws-backend-url>
  (output: `build/app/outputs/bundle/release/app-release.aab`)
  ```

---

## 3. Building the Production IPA (iOS)

- **First-time only:**  
  - Open `ios/` folder in Xcode.
  - Update bundle identifiers and signing certificates.
- **Command line build:**
  ```
  flutter clean
  flutter pub get
  flutter build ios --release --dart-define=API_URL=https://<your-aws-backend-url>
  ```
- **Archive and upload:**  
  - Open `ios/` in Xcode, archive the app, then upload to the App Store.

---

## 4. Distribution and Release

### A. **Distribute Android APK & AAB**

- **Via AWS S3 (internal/test):**
  1. Upload `app-release.apk` or `.aab` to your S3 bucket:
     ```
     aws s3 cp build/app/outputs/flutter-apk/app-release.apk s3://<your-bucket>/mobile/app-release.apk
     ```
  2. Make public or authenticated link for testers.
  3. (Optional) Use [Firebase App Distribution](https://firebase.google.com/products/app-distribution).
- **Production (Play Store):**
  1. Go to https://play.google.com/console
  2. Create app entry (if not yet done).
  3. Upload the `.aab` file as a release.
  4. Fill out app details, content rating, privacy, etc.
  5. Submit for review.

### B. **Distribute iOS IPA**

- **Via AWS S3/TestFlight (internal/test):**
  1. Archive IPA in Xcode, export for AD-HOC or Enterprise distribution.
  2. Upload to S3:
     ```
     aws s3 cp <path-to-exported.ipa> s3://<your-bucket>/mobile/app-release.ipa
     ```
  3. Use link or TestFlight for testers (recommended: https://appstoreconnect.apple.com/).
- **Production (App Store):**
  1. Go to https://appstoreconnect.apple.com/
  2. Create app entry.
  3. Upload via Xcode’s "Distribute App" or Transporter.
  4. Fill out metadata, privacy, review info.
  5. Submit for review.

---

## 5. Updating Backend URL After Deployment

- To re-target the production API endpoint in the app:
  - Change the value passed to `--dart-define=API_URL=...` in your build command.
  - For apps already released, a new build and store deployment is required to update the backend URL.

---

## 6. CI/CD Recommendations

- Automate Android/iOS builds with Github Actions or AWS CodeBuild.
- In CI, pass `--dart-define=API_URL=...` for each environment.
- Artifacts (`apk`, `.aab`, or `.ipa`) can be auto-uploaded to S3 and/or distributed to testers.

---

## 7. Useful Links

- [Flutter build & release docs](https://docs.flutter.dev/deployment)
- [Play Store entry setup](https://developer.android.com/distribute/console)
- [App Store Connect](https://developer.apple.com/app-store-connect/)
- [AWS S3 CLI](https://docs.aws.amazon.com/cli/latest/reference/s3/index.html)
- [Firebase App Distribution](https://firebase.google.com/products/app-distribution)

---

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
