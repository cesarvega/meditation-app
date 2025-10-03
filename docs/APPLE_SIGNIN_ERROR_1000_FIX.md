# 🚨 ERROR 1000 - Sign in with Apple Capability Missing

## ❌ Current Issue:
```
ASAuthorizationController credential request failed with error: 
Error Domain=com.apple.AuthenticationServices.AuthorizationError Code=1000
```

**This means: Sign in with Apple capability is NOT properly configured**

---

## 🔍 DEBUG: Check if Capability is Added

### Step 1: Verify in Xcode
1. **Open Xcode** → `Meditation.xcodeproj`
2. **Click on project "Meditation"** (blue icon, top of navigator)
3. **Select TARGET "Meditation"** (not the project, the target underneath)
4. **Click "Signing & Capabilities" tab**
5. **Look for "Sign in with Apple"** in the capabilities list

### What you should see:
```
✅ CORRECT:
┌─────────────────────────────────┐
│ Automatically manage signing    │
│ Team: Your Developer Team       │
├─────────────────────────────────┤
│ Sign in with Apple             │  ← This MUST be here
└─────────────────────────────────┘

❌ MISSING (causes error 1000):
┌─────────────────────────────────┐
│ Automatically manage signing    │
│ Team: Your Developer Team       │
└─────────────────────────────────┘
(No "Sign in with Apple" section)
```

---

## 🚀 SOLUTION: Add the Capability

### Method 1: Through Xcode UI
1. **In "Signing & Capabilities" tab**
2. **Click "+ Capability"** (button in top-left corner)
3. **Type "Sign in with Apple"** in search box
4. **Double-click on "Sign in with Apple"** to add it
5. **Verify it appears** in the capabilities list

### Method 2: If UI method fails
Sometimes Xcode UI has issues. Try this:
1. **Close Xcode completely**
2. **Delete derived data:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/Meditation-*
   ```
3. **Reopen Xcode**
4. **Try Method 1 again**

### Method 3: Manual entitlements (if needed)
If both methods fail, I can help you add it manually to the entitlements file.

---

## 🔧 After Adding Capability:

1. **Clean Build Folder:**
   - Product menu → Clean Build Folder
   - OR: `Cmd + Shift + K`

2. **Build:**
   - `Cmd + B`
   - **Check for build errors**

3. **Run:**
   - `Cmd + R`

4. **Test Apple Sign-In button again**

---

## 🎯 Expected Result:

**BEFORE (Error 1000):**
- Button appears but crashes with error 1000
- Console shows "ASAuthorizationController credential request failed"

**AFTER (Working):**
- Button opens Apple's native sign-in sheet
- Face ID/Touch ID/Password prompt appears
- User can complete authentication
- App receives user data successfully

---

## 🚨 Common Issues:

### Issue 1: Wrong Target Selected
- Make sure you select **TARGET "Meditation"**, not the **PROJECT "Meditation"**
- The target has a different icon (app icon vs folder icon)

### Issue 2: Developer Account Issues
- Sign in with Apple requires a **paid Apple Developer account**
- Free accounts cannot use this capability on physical devices
- Simulator should work with any Apple ID

### Issue 3: Team/Provisioning Issues
- Make sure **"Automatically manage signing"** is checked
- Select correct **Team** in signing section
- Let Xcode handle provisioning profiles

---

## 📱 Quick Test:

After adding the capability, the sign-in flow should be:
1. **Tap "Sign in with Apple"**
2. **Apple's sheet appears** (not an error)
3. **Choose "Continue with Password" or use Face ID/Touch ID**
4. **App receives user data**
5. **User is signed in successfully**

---

## 🆘 If Still Not Working:

Let me know:
1. **Did you see the capability appear** in Signing & Capabilities?
2. **Any build errors** after adding it?
3. **What happens now** when you tap the button?
4. **Are you testing on simulator or physical device?**

The capability addition is the critical missing step! 🚀