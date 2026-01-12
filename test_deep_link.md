# Test Deep Link

## Method 1: ADB Command (Recommended)
Run this command while the app is installed on your device:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "uniquest://uniquest.com/email-confirm"
```

This will:
- Open the UniQuest app
- Navigate to the email confirmation page
- Show the success animation

## Method 2: HTML Test File
Create a test HTML file and open it in your phone's browser:

```html
<!DOCTYPE html>
<html>
<body>
<h1>Test UniQuest Deep Link</h1>
<a href="uniquest://uniquest.com/email-confirm">Click to test email confirmation</a>
</body>
</html>
```

## Method 3: Terminal Command (Use in VS Code)
```powershell
adb shell am start -W -a android.intent.action.VIEW -d "uniquest://uniquest.com/email-confirm"
```

## What Should Happen:
1. ✅ App opens automatically
2. ✅ Shows email confirmation page with confetti
3. ✅ Displays "🎉 Email Confirmed!"
4. ✅ Auto-redirects after 3 seconds

## If It Doesn't Work:
- Make sure app is installed on device
- Check ADB is connected: `adb devices`
- Rebuild the app to include AndroidManifest changes
