# Google Photos — Tray Launcher

[日本語](README.ja.md)

A small toolkit that keeps the Google Photos web app (PWA) **pinned in the
Windows system tray** and **auto-starts it at login**. No external tools
required — it runs entirely on standard Windows PowerShell + .NET (NotifyIcon).

## Why keep it running in the tray

Since the **desktop Google Drive app's "back up to Google Photos" feature is
being discontinued on 2026-08-10** (and no new folders could be added to it
after 2026-06-15), Google's recommended replacement is the **"Back up a
folder" feature in the Google Photos web app itself**. That feature only
works **while the web app is running**, so keeping it alive in the tray from
login onward keeps "drop photos in a folder and they auto-upload to Google
Photos" working continuously.

## How it works

- Launches Chrome in "app mode" (`--app`) under a dedicated profile, for reliable window management.
- On startup, the window is hidden and only the tray icon is shown.
- **Tray icon**: left-click toggles show/hide. Right-click gives "Show/Hide, Reopen, Quit".

## Usage

### First-time setup (one time only)

1. Double-click `photos_tray_hidden.vbs`.
2. Since it uses a dedicated profile, **sign in to your Google account** in the window that opens.
3. In Google Photos, go to **Settings → "Back up a folder"** and choose the
   folder(s) on your PC you want auto-uploaded (this replaces the old Google Drive backup feature).
4. Once set up, **left-click the tray icon to hide the window** — it will keep running in the tray from then on.

> From the second launch onward, the app starts quietly into the tray without showing a window.
> Left-click the tray icon any time you want to check backup status.

### Auto-start at login

Run the following in PowerShell (no admin rights needed):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install_startup.ps1
```

This creates a shortcut in Startup:
`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Google Photos Tray.lnk`

### Removing auto-start

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install_startup.ps1 -Uninstall
```

## Files

| File | Role |
|---|---|
| `photos_tray.ps1` | Main script (launches Chrome + manages the tray icon) |
| `photos_tray_hidden.vbs` | Launcher that starts the main script without showing a console window |
| `install_startup.ps1` | Registers / removes the startup entry (`-Uninstall`) |

## Notes

- The icon is taken from the Chrome executable (so it looks like the Chrome
  icon). If you want a Google Photos–style icon instead, change the
  `ExtractAssociatedIcon` part of `photos_tray.ps1` to point to an `.ico` file.
- To use a different account or URL, change the default value of `-Url` in `photos_tray.ps1`.
- The dedicated profile is created at `%LOCALAPPDATA%\GooglePhotosTray\profile`.
