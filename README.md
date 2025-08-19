# 🚀 WebRTC Multi-Object Detection Demo

Real-time multi-object detection using WebRTC for live camera streaming and TensorFlow.js for client-side AI inference. Features live metrics collection and 30-second benchmarking capabilities.

## 🎯 Features

- **Real-time WebRTC Video Streaming** - Direct browser-to-browser communication
- **Live Object Detection** - TensorFlow.js COCO-SSD model for 80+ object classes
- **Dual Mode Support** - Server-side or WASM-only client-side processing
- **Performance Metrics** - Live tracking and 30-second benchmark export
- **Mobile Camera Support** - QR code for easy mobile device connection
- **Docker Ready** - Complete containerization with one-command deployment

## 🚀 Quick Start

### Option 1: One-Command Start (Recommended)

```bash
# Clone the repository
git clone https://github.com/Rohitk0102/webrtc-vlm-demo.git
cd webrtc-vlm-demo

# Start with server mode (default)
./start.sh

# Or specify mode and environment
./start.sh server dev    # Development with Node.js
./start.sh server prod   # Production with Docker
./start.sh wasm dev      # WASM-only mode
```

### Option 2: Manual Setup

```bash
# Install dependencies
npm install

# Generate SSL certificates (required for camera access)
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes \
  -subj "/C=US/ST=CA/L=San Francisco/O=WebRTC Demo/CN=localhost"

# Start the server
node server.js
```

### Option 3: Docker Compose

```bash
# Start with Docker (production-ready)
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## � Device Setup

### 🖥️ **Receiver (Detection Display)**
Open in your laptop/desktop browser:
- **Local**: `https://localhost:3443`
- **Network**: `https://[YOUR_IP]:3443`

### 📱 **Sender (Mobile Camera)**
Option 1: Scan QR code displayed on the receiver page
Option 2: Direct URL: `https://[YOUR_IP]:3443/sender.html?room=room1`

⚠️ **SSL Certificate**: Accept the self-signed certificate warning in your browser

## 🔧 Mode Switching

### Server Mode (Default)
- **Command**: `./start.sh server`
- **Features**: Full WebRTC signaling server + object detection
- **Best for**: Complete functionality, mobile camera support
- **Port**: `3443` (HTTPS)

### WASM Mode  
- **Command**: `./start.sh wasm`
- **Features**: Client-side only, no server dependency
- **Best for**: Local development, offline usage
- **Port**: `8080` (HTTP)

## 📊 Metrics & Benchmarking

### Live Metrics
- **Objects Count**: Real-time detection count display
- **Background Collection**: Latency, FPS, bandwidth data

### 30-Second Benchmark
1. Click **"📈 Start 30s Benchmark"** button
2. Wait for 30-second collection period
3. Click **"💾 Download metrics.json"** to get results

### Sample Metrics Output
```json
{
  "benchmark_duration_seconds": 30,
  "end_to_end_latency": {
    "median_ms": 100,
    "p95_ms": 173,
    "samples": 770
  },
  "processed_fps": {
    "average": 5,
    "samples": 770
  },
  "network_throughput": {
    "uplink_kbps": 0,
    "downlink_kbps": 0
  },
  "detection_stats": {
    "total_frames_processed": 770,
    "total_objects_detected": 471
  },
  "timestamp": {
    "start": "2025-08-19T18:34:30.739Z",
    "end": "2025-08-19T18:35:00.742Z"
  }
}
```

## 🏗️ Architecture

### Server Mode Architecture
```
Mobile Camera (Sender) ←→ WebRTC Server ←→ Browser (Receiver)
                                ↓
                        TensorFlow.js Detection
                                ↓
                         Metrics Collection
```

### WASM Mode Architecture
```
Camera Input → Browser → TensorFlow.js/WASM → Display + Metrics
```

## 🐳 Docker Configuration

### Services
- **webrtc-server**: Main application container
- **nginx**: Reverse proxy (production profile)

### Volumes
- `./logs`: Application logs
- `./certs`: SSL certificates (optional override)

### Networks
- **webrtc-network**: Isolated bridge network (172.20.0.0/16)

## 🔧 Development

### Project Structure
```
webrtc-vlm-demo/
├── server.js              # Main server file
├── public/
│   ├── receiver.html       # Detection display interface
│   └── sender.html         # Camera interface
├── backend/                # Alternative backend structure
├── start.sh               # Convenience startup script
├── Dockerfile             # Container definition
├── docker-compose.yml     # Multi-service orchestration
├── nginx.conf             # Reverse proxy configuration
└── README.md              # This file
```

### Environment Variables
- `NODE_ENV`: production/development
- `PORT`: Server port (default: 3443)
- `HTTPS`: Enable HTTPS (default: true)

### SSL Certificates
- **Auto-generated**: Self-signed certificates created automatically
- **Custom**: Replace `cert.pem` and `key.pem` with your certificates
- **Production**: Use Let's Encrypt or proper CA certificates

## 🛠️ Troubleshooting

### Common Issues

**Port Already in Use**
```bash
# Check what's using the port
lsof -i :3443
# Kill the process
kill -9 <PID>
```

**SSL Certificate Errors**
- Accept the browser warning for self-signed certificates
- For production, use proper SSL certificates

**Camera Access Denied**
- Ensure HTTPS is enabled (required for camera access)
- Check browser permissions
- Try a different browser

**Docker Issues**
```bash
# Reset Docker state
docker-compose down -v
docker system prune -f
./start.sh server prod
```

### Performance Optimization
- **Hardware**: Use devices with GPU acceleration
- **Network**: Ensure stable WiFi connection
- **Browser**: Chrome/Edge recommended for best WebRTC support

## 📋 Requirements

### System Requirements
- **Node.js** 16+ (for server mode)
- **Docker** & **Docker Compose** (for containerized deployment)
- **OpenSSL** (for certificate generation)

### Browser Support
- **Chrome** 80+ (recommended)
- **Firefox** 75+
- **Safari** 14+
- **Edge** 80+

### Network Requirements
- **HTTPS** required for camera access
- **Same network** for mobile camera connection
- **Firewall** allow port 3443

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🎉 Quick Demo

1. **Start**: `./start.sh`
2. **Open**: `https://localhost:3443` (accept SSL warning)
3. **Connect**: Scan QR code with mobile device
4. **Detect**: Point camera at objects
5. **Benchmark**: Click "Start 30s Benchmark" button
6. **Download**: Get metrics.json file

---

**Repository**: [github.com/Rohitk0102/webrtc-vlm-demo](https://github.com/Rohitk0102/webrtc-vlm-demo)
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
