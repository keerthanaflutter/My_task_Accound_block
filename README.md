# My Task — account deletion website

Public page where users delete their My Task account without the app
(required by Google Play). One static file, no build step.

- `index.html` — sign in, confirm, then `DELETE /api/auth/account`.
  Backend URL is the `API` constant at the bottom of the file.

## Run locally

    python3 -m http.server 8080
    # open http://localhost:8080

## Deploy (Render static site)

New → Static Site → this repo → build command: empty → publish directory: `.`

Then put the URL in Play Console (Data safety → account deletion) and in the
app's PRIVACY_POLICY.md section 7.1.
