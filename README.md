# Evergreen Gallery – Capacitor setup

1. Put these files in a folder: `www/` (index.html, manifest.json, sw.js, icon.png), `capacitor.config.json`, `package.json`.
2. `npm install`
3. `npx cap add android`
4. `npx cap sync android`
5. In `android/app/src/main/AndroidManifest.xml` add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
```
and add `android:requestLegacyExternalStorage="true"` to the `<application>` tag.
6. Run `npx cap open android`, build the APK, install it, then turn on "All files access" for Evergreen Gallery in App Settings. This is needed to move, rename and delete photos in MyAlbums and DCIM.
7. After editing index.html, run `npx cap sync android` and rebuild.

Tailwind and Font Awesome load from a CDN, like your audio player. For fully offline use, download them into www/ and change the two tags.

Vault: tap the paw logo 3 times. First time you create a PIN. The gear on the PIN screen changes the PIN. Nothing about the vault appears in Settings. Hidden photos are AES-256-GCM encrypted into the app's private storage and removed from the gallery. The PIN wraps a random master key, so changing the PIN is instant. A forgotten PIN cannot be recovered.

## Fully offline (recommended for the APK)
The app loads Tailwind and Font Awesome from the internet by default, so styling and icons are missing without a connection. On your computer, run `./build-offline.sh` once in this folder. It downloads both, builds `www/tailwind.css`, copies the icon fonts to `www/fa/`, and rewrites `www/index.html` to use them. Then run `npx cap sync android` and rebuild. Keep editing `www/index.src.html` and re-run the script after changes.

## All files access prompt (needed for delete / move / rename / hide)
Copy `android-plugin/GalleryToolsPlugin.java` and `android-plugin/MainActivity.java` into `android/app/src/main/java/com/reaper357/grizzlygallery/` (replace the generated MainActivity), then `npx cap sync android` and rebuild. The app then shows an "Allow" button that opens the right Android screen. Without it, turn on All files access for Evergreen Gallery manually: Settings > Apps > Evergreen Gallery > Permissions > Files and media / All files access.

## Updating (important)
Unzip the new zip over your project folder (allow overwrite), then run `./build-offline.sh`. It always rebuilds from `www/index.src.html`, copies the Android plugin files, and runs `npx cap sync android`. Then rebuild the APK in Android Studio.

## Renamed to Evergreen Gallery
The in-app name, page title and manifest are updated. The Android launcher name lives in `android/app/src/main/res/values/strings.xml`: change `app_name` and `title_activity_main` to `Evergreen Gallery`, then rebuild. The app ID (`com.reaper357.grizzlygallery`) is unchanged on purpose, so the new build installs over your current one and keeps your vault and settings.
