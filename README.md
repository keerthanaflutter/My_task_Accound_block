# My Task — account deletion website

Flutter web app where users delete their My Task account without installing
the app (required by Google Play). Signs in, confirms, then calls
`DELETE /api/auth/account`.

- `lib/main.dart` — the page
- `lib/account_api.dart` — the two backend calls
- `lib/theme/app_theme.dart`, `lib/widgets/password_field.dart` — copied from
  `my_task_flutter`; keep them in sync if the app's theme changes.

## Run locally

    flutter run -d chrome
    # against a dev backend:
    flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3002/api

## Build

    flutter build web --release
    # output: build/web

## Deploy (Render static site)

- Build command: `git clone https://github.com/flutter/flutter.git -b stable --depth 1 && ./flutter/bin/flutter build web --release`
- Publish directory: `build/web`

Or build locally and drag `build/web` onto https://app.netlify.com/drop.

Then put the URL in Play Console (Data safety → account deletion) and in the
app's PRIVACY_POLICY.md section 7.1.
