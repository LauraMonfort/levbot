# Setup

### 1. Create your own .env file
```
# .env
VERIFY_TOKEN=your_verify_token
ACCESS_TOKEN=your_page_access_token

# And if you want to see exceptions and errors in the chat
# window (useful for development, but remove this for production)
DEBUG=true
```

### 2. Install needed gems
```
bundle
```

### 3. Run the server.
Please notice that we're using port 5000 for this (this will allow you to run both the webapp and the bot in the same machice as well):
```
heroku local -p 5000
```

### 4. Open your server for the web

If you're using localtunnel:
```
/usr/local/bin/lt --port 5000
```

If you're using ngrok:
```
ngrok http 5000
```

Or depending on your ngrok instalation:
```
./ngrok http 5000
```

### 5. Point the webhook on facebook to to your server
