# WebRTC Object Detection Demo 🎯

Real-time object detection using WebRTC for video streaming and TensorFlow.js for AI inference.

## Features ✨

- 📱 **Mobile Camera Streaming** - Stream from phone camera to computer
- 🔒 **HTTPS Support** - Required for mobile camera access
- 🎯 **Real-time Object Detection** - Uses TensorFlow.js COCO-SSD model
- 📊 **Live Performance Metrics** - FPS, latency, detection count
- 📱 **QR Code Generation** - Easy phone connection via QR code
- 🎨 **Modern UI** - Beautiful, responsive interface

## Quick Start 🚀

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Server with HTTPS
```bash
npm run start-https
```

This will:
- Generate SSL certificates automatically
- Start HTTPS server on port 3443
- Show network IP for mobile access

### 3. Open on Computer
Visit: **https://192.168.1.18:3443** (use your actual IP)

### 4. Connect Phone
- Scan the QR code displayed on the webpage, OR
- Manually visit the sender URL on your phone
- Accept the SSL certificate warning
- Allow camera access when prompted

### 5. Start Detection
Click "🚀 Start WASM Inference" on the computer to begin real-time object detection!

## Network IP Detection 🌐

Check your network IP addresses:
```bash
npm run network-ip
```

## Mobile Camera Requirements 📱

Modern browsers require **HTTPS** for camera access on mobile devices. This demo automatically:

1. ✅ Generates self-signed SSL certificates
2. ✅ Runs HTTPS server on port 3443
3. ✅ Creates mobile-accessible QR codes
4. ✅ Handles camera permission requests properly

## Troubleshooting 🔧

### Camera Not Working on Mobile?
1. **Check HTTPS**: Ensure you're using `https://` not `http://`
2. **Accept Certificate**: You'll need to accept the self-signed certificate warning
3. **Same Network**: Phone and computer must be on same WiFi
4. **Browser Support**: Use Chrome/Safari on mobile for best compatibility

### Connection Issues?
1. **Firewall**: Check if ports 3443 is blocked
2. **Network**: Ensure devices are on same network
3. **IP Address**: Verify the network IP is correct

### Performance Tips 💡
- Use good lighting for better object detection
- Point camera at objects (people, furniture, etc.)
- The AI model detects 80+ common objects from COCO dataset

## Development 👨‍💻

### File Structure
```
webrtc-vlm-demo/
├── server.js              # Main server with HTTPS support
├── public/
│   ├── receiver.html       # Computer interface (AI detection)
│   ├── sender.html         # Phone interface (camera stream)
│   └── js/
│       ├── detector_wasm.js # WASM detector placeholder
│       └── overlay.js      # Drawing utilities
├── bench/                  # Performance benchmarking
├── cert.pem & key.pem     # SSL certificates (auto-generated)
└── start-servers.sh       # HTTPS startup script
```

### Available Scripts
- `npm start` - Start HTTP server (port 3000)
- `npm run start-https` - Start HTTPS server (port 3443)
- `npm run network-ip` - Show network IP addresses
- `npm run bench` - Run performance benchmarks

## Tech Stack 🛠️

- **Backend**: Node.js, Express, Socket.IO
- **Frontend**: Vanilla JS, WebRTC, TensorFlow.js
- **AI Model**: COCO-SSD object detection
- **Security**: HTTPS with self-signed certificates
- **Real-time**: WebRTC for low-latency video streaming

## Browser Support 🌐

### Desktop (Receiver)
- ✅ Chrome 80+
- ✅ Firefox 75+
- ✅ Safari 14+
- ✅ Edge 80+

### Mobile (Sender)
- ✅ Chrome Mobile 80+
- ✅ Safari iOS 14+
- ⚠️ Firefox Mobile (limited WebRTC support)

---

**Happy detecting!** 🎯✨
