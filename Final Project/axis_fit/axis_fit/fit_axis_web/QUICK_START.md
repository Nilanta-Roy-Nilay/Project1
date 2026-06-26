# ⚡ Quick Start - Fit Axis Web

**Get your app running on Chrome in 30 seconds!**

---

## 🚀 One Command to Start

```bash
cd fit_axis_web
flutter run -d chrome
```

**That's it!** Chrome will open automatically with your app running. ✨

---

## 📋 Before You Run (One-time Setup)

### Requirement Check
```bash
# Check Flutter is installed
flutter --version

# Check Chrome is available
flutter devices

# Should show: Chrome (web) • chrome • web-javascript
```

### Install Dependencies
```bash
cd fit_axis_web

# Clean any old builds
flutter clean

# Get dependencies
flutter pub get
```

---

## 🎮 While Running

Once `flutter run -d chrome` is active in your terminal:

| Key | Action |
|-----|--------|
| `r` | **Hot Reload** - See changes instantly! |
| `R` | Full app restart |
| `h` | Help menu |
| `q` | Quit / Stop running |

---

## 🌐 View on Another Device

1. Find your computer's IP:
   ```bash
   # macOS/Linux
   hostname -I
   
   # Windows: Look for IPv4 Address in ipconfig output
   ```

2. Run with explicit port:
   ```bash
   flutter run -d chrome --web-port=8000
   ```

3. On other device, open browser and go to:
   ```
   http://YOUR_COMPUTER_IP:8000
   ```

---

## 🔧 Common Issues & Solutions

### Chrome Won't Open
```bash
# Update Chrome
# https://www.google.com/chrome/

# Or restart flutter
# Press 'q' in terminal and run again
```

### Changes Not Showing (Hot Reload Not Working)
```bash
# Hard refresh in Chrome
Ctrl+Shift+R  # Windows/Linux
Cmd+Shift+R   # macOS

# Or restart: press 'q' then run again
```

### "Flutter devices" Shows No Chrome
```bash
# Enable web support
flutter config --enable-web

# Or upgrade Flutter
flutter upgrade
```

### Firebase Errors in Console
- ✅ This is normal - just means it's connecting
- If app doesn't load at all, check:
  - Internet connection
  - Firebase web config in Firebase console
  - Browser console for specific errors

---

## 💾 Build for Production

Once ready to deploy:

```bash
# Build optimized version
flutter build web --release

# Output: build/web/

# Deploy to any web host:
# - Firebase Hosting: firebase deploy
# - Netlify: netlify deploy --prod --dir build/web
# - GitHub Pages: Push build/web to gh-pages branch
```

---

## 📱 Test on Different Screen Sizes

Open Chrome DevTools (F12) and:

1. Click device toggle icon (top-left)
2. Select device or custom size
3. See app respond instantly!

**Fully responsive** - works on phones, tablets, and desktops. 📱💻🖥️

---

## ✨ Features Working on Web

✅ Sign up / Login  
✅ Track food, workouts, water  
✅ View charts & stats  
✅ BMI calculator  
✅ AI Chatbot  
✅ User profile  
✅ Dark mode  
✅ And more!

---

## 🆘 Still Having Issues?

```bash
# Nuclear option - start completely fresh
flutter clean
flutter pub get
flutter run -d chrome -v  # -v shows detailed logs
```

Check `/lib/services/` files - they're modified for web compatibility.

---

## 📚 Next Steps

- **Learn**: Read `WEB_SETUP_GUIDE.md` for detailed info
- **Customize**: Modify pages in `/lib/features/`
- **Deploy**: Follow "Build for Production" section above
- **Share**: Show friends your web app! 🎉

---

**You're all set! 🚀**

Questions? Check the full WEB_SETUP_GUIDE.md file.
