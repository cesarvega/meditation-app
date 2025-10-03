# How to Add Background Audio to Xcode Project

## Problem
The "Dream of Light.mp3" file exists in the file system but is not being found by the app because it's not included in the Xcode project bundle.

## Solution

### Step 1: Add the File to Xcode Project
1. Open your project in **Xcode**
2. In the **Project Navigator** (left sidebar), find the `Meditation` folder
3. **Right-click** on the `Meditation` folder → Select **"Add Files to Meditation..."**
4. Navigate to: `Meditation/audio/background-sound/Dream of Light.mp3`
5. Select the file and click **"Add"**

### Step 2: Verify Target Membership
1. Select `Dream of Light.mp3` in the Project Navigator
2. Open the **File Inspector** (right sidebar, first tab - file icon)
3. In the **Target Membership** section, make sure **"Meditation"** is checked ✅
4. If it's not checked, check it now

### Step 3: Verify Folder Structure (Optional but Recommended)
You can also add the entire `audio` folder structure:
1. Right-click on `Meditation` folder → **"Add Files to Meditation..."**
2. Navigate to the `audio` folder
3. Select the `audio` folder
4. **Important**: Choose **"Create folder references"** (NOT "Create groups")
5. Make sure **"Add to targets: Meditation"** is checked
6. Click **"Add"**

### Step 4: Clean Build Folder
1. In Xcode menu: **Product** → **Clean Build Folder** (⇧⌘K)
2. Build and run the project again

## Verification
After adding the file:
- Run the app
- Go to the audio player
- Tap the **"Background Music"** button
- Check the **Xcode console** for this message:
  ```
  ✅ Background audio loaded from: [path]
  ```

If you still see errors, check:
- File name is exactly "Dream of Light.mp3" (with spaces)
- File extension is .mp3
- Target membership is checked
- File is not in .gitignore

## File Location
```
Meditation/
└── audio/
    └── background-sound/
        └── Dream of Light.mp3
```

## Alternative: Rename File (If Issues Persist)
If the file with spaces in the name causes issues:
1. Rename `Dream of Light.mp3` to `dream-of-light.mp3` (no spaces)
2. Update the code in `AudioPlayerManager.swift` line 206 to use the new name
3. Add the renamed file to Xcode project

The code now tries multiple name variations, so either format should work once the file is added to the bundle.
