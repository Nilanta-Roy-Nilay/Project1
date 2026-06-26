# 🚀 Fit Axis - Web Setup Guide

This is the **web-optimized version** of the Fit Axis Flutter fitness app. All platform-specific code has been modified to run smoothly on **Chrome Web** without requiring an emulator.

---

## ⚡ What's Changed for Web

### Removed/Modified Dependencies
- ❌ **Pedometer** - Removed (motion sensors don't work on web)
- ❌ **Flutter Local Notifications** - Converted to graceful fallback
- ❌ **Permission Handler** - Not needed for web
- ✅ **Firebase** - Fully web compatible!
- ✅ **Firestore** - Fully web compatible!
- ✅ **All UI/UX code** - Works on web

### Key Modifications

#### 1. **Step Tracking (Enhanced)**
- **Mobile**: Still uses device pedometer for automatic step counting
- **Web**: Manual step entry or automatic sync from Firestore
- Added `updateStepsManually()` method for web input
- Added `getTodaysSteps()` to fetch from database

#### 2. **Notifications (Graceful Fallback)**
- **Mobile**: Native Android/iOS notifications
- **Web**: Logs to console + ready for browser notifications API integration

#### 3. **pubspec.yaml Updates**
- Platform-specific dependencies only load on mobile
- No errors on web platform

---

## 📋 Prerequisites

Before you start, make sure you have:

```bash
# Check Flutter version (should be 3.8+)
flutter --version

# Check that web is enabled
flutter config --enable-web

# Verify Chrome/Chromium is installed
which google-chrome  # Linux
which chromium       # Linux  
```

---

## 🔧 Setup Instructions

### Step 1: Install Dependencies

```bash
cd fit_axis_web

# Clean previous builds
flutter clean

# Get all dependencies (web-compatible versions)
flutter pub get

# Check web platform is available
flutter devices  # Should show 'Chrome (web)' in the list
```

### Step 2: Configure Firebase for Web

Your Firebase project needs to be configured for web. If you haven't already:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click "Add App" → "Web"
4. Copy the config
5. The config will be used automatically in your web build

**For local testing without Firebase:**
- The app will still load but won't sync data
- Use Firestore Emulator for local development (see below)

### Step 3: Run on Chrome Web

```bash
# Run on Chrome with hot reload enabled
flutter run -d chrome

# Or run in release mode (faster)
flutter run -d chrome --release

# Or run with web server on custom port
flutter run -d chrome --web-port=8080
```

**What you should see:**
- Chrome opens automatically
- Fit Axis app loads with all features
- Hot reload works (changes appear instantly)
- No emulator needed! ⚡

---

## 🌐 Running on Different Devices

### Local Network Access (Dev Machine → Other Device)

```bash
# Get your machine's IP
ipconfig getifaddr en0  # macOS
hostname -I             # Linux
ipconfig                # Windows (look for IPv4 Address)

# Run on specified port and address
flutter run -d chrome --web-port=8000

# Access from other device at: http://YOUR_IP:8000
```

### Web Server (Production-like Testing)

```bash
# Build for web
flutter build web

# Start a simple HTTP server
cd build/web
python -m http.server 8000

# Open http://localhost:8000
```

---

## 🎯 Feature Guide for Web

### ✅ Fully Working on Web

| Feature | Status | Notes |
|---------|--------|-------|
| **Authentication** | ✅ Complete | Email/password login & registration |
| **Dashboard** | ✅ Complete | All stats and charts |
| **Food Tracking** | ✅ Complete | Add & view food logs |
| **Workout Logging** | ✅ Complete | Manual workout entry |
| **Water Intake** | ✅ Complete | Hydration tracking |
| **BMI Calculator** | ✅ Complete | Calculate & track BMI |
| **User Profile** | ✅ Complete | Edit user details |
| **Chatbot (Gemini AI)** | ✅ Complete | Get fitness advice |
| **Chat History** | ✅ Complete | View previous chats |
| **Admin Dashboard** | ✅ Complete | Admin controls |
| **Dark Mode** | ✅ Complete | Theme switching |
| **Responsive Design** | ✅ Complete | Works on all screen sizes |

### 📊 Step Tracking on Web

**Automatic (if synced):**
- Steps sync from mobile if you have the mobile app
- Shows real-time updates in web dashboard

**Manual Entry:**
- Use "Add Steps" button to log steps manually
- Perfect for workouts without pedometer (gym, swimming, cycling)
- Data syncs to Firestore immediately

---

## 🔍 Troubleshooting

### Problem: "Chrome not found"
```bash
# On Ubuntu
sudo apt-get install google-chrome-stable

# On macOS
brew install --cask google-chrome

# On Windows
# Download from https://www.google.com/chrome/
```

### Problem: "Web not enabled"
```bash
# Enable web support
flutter config --enable-web

# Verify
flutter devices  # Should show Chrome
```

### Problem: Hot reload not working
```bash
# Try hard refresh in Chrome
Ctrl+Shift+R (Windows/Linux)
Cmd+Shift+R (macOS)

# Or restart the dev server
# Press 'q' in terminal, then run flutter run again
```

### Problem: Firebase errors in console
**If you see "Missing or invalid API keys":**
1. Make sure you've added your web app in Firebase console
2. Check that Firestore is accessible (disable security rules for testing)
3. Or use [Firestore Emulator](#firestore-local-emulator) for development

### Problem: CORS errors
**If you see "CORS policy" errors:**
- This usually means Firebase isn't properly configured
- Check your web app credentials in Firebase console
- Enable CORS in your Firestore rules:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if true;  // For testing only!
      }
    }
  }
  ```

---

## 🛠️ Development Workflow

### Hot Reload Development

```bash
flutter run -d chrome

# In the terminal, you can:
# - Press 'r' to hot reload
# - Press 'R' for full app restart
# - Press 'h' for help
# - Press 'q' to quit
```

### Enable DevTools Debugging

```bash
# Run with additional debugging
flutter run -d chrome --enable-software-performance

# Open DevTools
flutter pub global run devtools

# Or access directly at: http://localhost:9100
```

### Check Device List

```bash
# See all connected devices and emulators
flutter devices

# Should show something like:
# Chrome (web) • chrome • web-javascript • Google Chrome 120.0.6099.115
```

---

## 📱 Responsive Design Testing

The app is fully responsive! Test on different screen sizes:

### In Chrome DevTools:
1. **F12** → Device toolbar
2. Select different devices:
   - **Mobile**: iPhone 12 (390×844)
   - **Tablet**: iPad (768×1024)
   - **Desktop**: Standard desktop (1920×1080)

### Or use keyboard shortcuts:
```
Ctrl+Shift+I → Toggle DevTools
Ctrl+Shift+M → Toggle Device Mode
```

---

## 🚀 Building for Production

### Build Web App

```bash
# Build optimized release
flutter build web --release

# Output location: build/web/

# The build includes:
# - Optimized JavaScript/WASM
# - Minified assets
# - All necessary dependencies
```

### Deploy to Hosting

#### **Option 1: Firebase Hosting** (Recommended)
```bash
npm install -g firebase-tools

firebase login
firebase init hosting

firebase deploy
```

#### **Option 2: Netlify**
```bash
# Install netlify CLI
npm install -g netlify-cli

# Deploy
netlify deploy --prod --dir build/web
```

#### **Option 3: GitHub Pages**
```bash
# Build for GitHub Pages path
flutter build web --base-href="/fit-axis/"

# Push build/web to gh-pages branch
```

---

## 🗄️ Firestore Local Emulator (Development)

For offline development without needing Firebase credentials:

### Setup Emulator

```bash
# Install Firebase CLI
curl -sL https://firebase.tools | bash

# Start emulator suite
firebase emulators:start

# This runs emulators on:
# - Firestore: localhost:8080
# - Auth: localhost:9099
```

### Connect Flutter App to Emulator

Add to `main.dart` before Firebase initialization:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Connect to local Firestore emulator
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  } else {
    await Firebase.initializeApp();
  }
  
  // ... rest of initialization
}
```

---

## 🐛 Enable Debug Logging

To see what's happening under the hood:

### Flutter Logging
```bash
flutter run -d chrome -v  # Verbose mode
```

### Browser Console
```javascript
// In Chrome DevTools console
// View Firebase logs
firebase.firestore.setLogLevel('debug');
```

---

## 📚 Additional Resources

- **Flutter Web Documentation**: https://flutter.dev/docs/development/platform-integration/web
- **Firebase Web Setup**: https://firebase.flutter.dev/docs/overview
- **Firestore Web Guide**: https://cloud.google.com/firestore/docs/client/libraries#web
- **Flutter Hot Reload**: https://flutter.dev/docs/development/tools/hot-reload

---

## ✨ Performance Tips

### For Smooth Web Experience:

1. **Use Release Mode for Testing**
   ```bash
   flutter run -d chrome --release
   ```

2. **Enable Hardware Acceleration in Chrome**
   - Chrome Settings → Advanced → System
   - Toggle "Use hardware acceleration"

3. **Cache Management**
   ```bash
   flutter clean  # Clear build cache
   flutter pub get --offline  # Use cached packages
   ```

4. **Monitor Performance**
   - DevTools → Performance tab
   - Watch for Jank (smooth 60 FPS is ideal)

---

## 🎓 Learning Resources for Web Development

### Quick Start
- Run `flutter run -d chrome` - That's it!
- No emulator setup needed
- Instant hot reload on every save

### Project Structure
```
lib/
├── main.dart              # Entry point (web-optimized)
├── features/              # Feature screens (all responsive)
├── services/              # Backend services (web-compatible)
│   ├── auth_service.dart  # ✅ Firebase Auth
│   ├── firestore_service.dart # ✅ Firestore
│   ├── step_service.dart  # 🔄 Web-compatible
│   └── notification_service.dart # 🔄 Web-compatible
├── models/                # Data models
├── core/                  # Theme and utilities
└── assets/                # Images and static files
```

---

## 🎉 You're Ready!

```bash
# One command to get started:
flutter run -d chrome

# That's all! No emulator, no complex setup.
# Your app is now running in Chrome with hot reload enabled.
```

**Happy coding! 🚀**

---

## Need Help?

If you encounter issues:

1. **Check Flutter Setup**: `flutter doctor`
2. **Clear Everything**: `flutter clean && flutter pub get`
3. **Check Logs**: Run with `-v` flag for verbose output
4. **Restart Chrome**: Sometimes a fresh browser helps
5. **Check Firebase**: Ensure your web app is configured in Firebase console

