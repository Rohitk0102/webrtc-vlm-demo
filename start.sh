#!/bin/bash

# WebRTC Multi-Object Detection - Start Script
# Usage: ./start.sh [server|wasm] [dev|prod]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
MODE=${1:-server}
ENV=${2:-dev}

echo -e "${BLUE}🚀 WebRTC Multi-Object Detection Startup${NC}"
echo -e "${BLUE}=========================================${NC}"

# Validate mode
if [[ "$MODE" != "server" && "$MODE" != "wasm" ]]; then
    echo -e "${RED}❌ Invalid mode: $MODE${NC}"
    echo -e "${YELLOW}Usage: ./start.sh [server|wasm] [dev|prod]${NC}"
    echo -e "${YELLOW}Modes:${NC}"
    echo -e "${YELLOW}  server - Run with Node.js backend (default)${NC}"
    echo -e "${YELLOW}  wasm   - Run with WASM-only frontend${NC}"
    exit 1
fi

# Function to get local IP
get_local_ip() {
    if command -v ifconfig >/dev/null 2>&1; then
        # macOS/Linux with ifconfig
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n1
    elif command -v ip >/dev/null 2>&1; then
        # Linux with ip command
        ip route get 1.1.1.1 | awk '{print $7}' | head -n1
    else
        echo "localhost"
    fi
}

# Function to check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        echo -e "${RED}❌ Port $port is already in use${NC}"
        echo -e "${YELLOW}Please stop the existing service or use a different port${NC}"
        exit 1
    fi
}

# Function to wait for service
wait_for_service() {
    local url=$1
    local max_attempts=30
    local attempt=0
    
    echo -e "${YELLOW}⏳ Waiting for service to start...${NC}"
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -k -s "$url" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Service is ready!${NC}"
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 2
        echo -n "."
    done
    
    echo -e "${RED}❌ Service failed to start within $(($max_attempts * 2)) seconds${NC}"
    return 1
}

# Function to generate QR code URL
generate_qr_url() {
    local base_url=$1
    local qr_url="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${base_url}/sender.html?room=room1"
    echo $qr_url
}

# Function to display connection info
show_connection_info() {
    local protocol=$1
    local port=$2
    local local_ip=$(get_local_ip)
    
    echo -e "${GREEN}🌐 Connection Information${NC}"
    echo -e "${GREEN}========================${NC}"
    echo -e "${GREEN}Local URL:    ${protocol}://localhost:${port}${NC}"
    echo -e "${GREEN}Network URL:  ${protocol}://${local_ip}:${port}${NC}"
    echo ""
    echo -e "${BLUE}📱 Mobile Camera Setup:${NC}"
    echo -e "${BLUE}  1. Open: ${protocol}://${local_ip}:${port}/sender.html?room=room1${NC}"
    echo -e "${BLUE}  2. Or scan QR code on the main page${NC}"
    echo ""
    echo -e "${YELLOW}🖥️  Receiver (Detection Display):${NC}"
    echo -e "${YELLOW}  Open: ${protocol}://localhost:${port}${NC}"
    echo ""
    
    if [[ "$protocol" == "https" ]]; then
        echo -e "${YELLOW}⚠️  SSL Certificate Warning:${NC}"
        echo -e "${YELLOW}  Accept the self-signed certificate warning in your browser${NC}"
        echo ""
    fi
    
    # Generate QR code URL
    local qr_url=$(generate_qr_url "${protocol}://${local_ip}:${port}")
    echo -e "${BLUE}📸 QR Code: ${qr_url}${NC}"
}

# Main execution
echo -e "${YELLOW}Mode: $MODE${NC}"
echo -e "${YELLOW}Environment: $ENV${NC}"
echo ""

case $MODE in
    "server")
        echo -e "${GREEN}🔧 Starting Server Mode...${NC}"
        
        if [[ "$ENV" == "prod" ]]; then
            echo -e "${YELLOW}🐳 Using Docker Compose (Production)${NC}"
            
            # Check if Docker is running
            if ! docker info >/dev/null 2>&1; then
                echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
                exit 1
            fi
            
            # Check if docker-compose exists
            if ! command -v docker-compose >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
                echo -e "${RED}❌ Docker Compose not found. Please install Docker Compose.${NC}"
                exit 1
            fi
            
            # Create logs directory
            mkdir -p logs
            
            # Stop any existing containers
            echo -e "${YELLOW}🧹 Stopping existing containers...${NC}"
            docker-compose down >/dev/null 2>&1 || true
            
            # Build and start
            echo -e "${YELLOW}🔨 Building and starting containers...${NC}"
            docker-compose up --build -d
            
            # Wait for service
            if wait_for_service "https://localhost:3443"; then
                show_connection_info "https" "3443"
                echo -e "${GREEN}🎉 Server mode started successfully with Docker!${NC}"
                echo -e "${YELLOW}📊 View logs: docker-compose logs -f${NC}"
                echo -e "${YELLOW}🛑 Stop: docker-compose down${NC}"
            fi
            
        else
            echo -e "${YELLOW}📦 Using Node.js (Development)${NC}"
            
            # Check port
            check_port 3443
            
            # Check if node_modules exists
            if [ ! -d "node_modules" ]; then
                echo -e "${YELLOW}📦 Installing dependencies...${NC}"
                npm install
            fi
            
            # Generate SSL certificates if needed
            if [ ! -f "cert.pem" ] || [ ! -f "key.pem" ]; then
                echo -e "${YELLOW}🔐 Generating SSL certificates...${NC}"
                openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes \
                    -subj "/C=US/ST=CA/L=San Francisco/O=WebRTC Demo/CN=localhost" \
                    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1,IP:0.0.0.0" 2>/dev/null
            fi
            
            # Start server
            echo -e "${YELLOW}🚀 Starting Node.js server...${NC}"
            node server.js &
            SERVER_PID=$!
            
            # Wait for service
            if wait_for_service "https://localhost:3443"; then
                show_connection_info "https" "3443"
                echo -e "${GREEN}🎉 Server mode started successfully!${NC}"
                echo -e "${YELLOW}🛑 Press Ctrl+C to stop${NC}"
                
                # Handle cleanup
                trap "echo -e '\n${YELLOW}🛑 Stopping server...${NC}'; kill $SERVER_PID 2>/dev/null || true; exit 0" INT TERM
                wait $SERVER_PID
            else
                kill $SERVER_PID 2>/dev/null || true
                exit 1
            fi
        fi
        ;;
        
    "wasm")
        echo -e "${GREEN}🔧 Starting WASM Mode...${NC}"
        echo -e "${YELLOW}📦 Using simple HTTP server for WASM-only mode${NC}"
        
        # Check port
        check_port 8080
        
        # Create a simple HTTP server for WASM mode
        echo -e "${YELLOW}🚀 Starting HTTP server on port 8080...${NC}"
        
        # Use Python or Node.js built-in server
        if command -v python3 >/dev/null 2>&1; then
            cd public
            python3 -m http.server 8080 &
            SERVER_PID=$!
            cd ..
        elif command -v python >/dev/null 2>&1; then
            cd public
            python -m SimpleHTTPServer 8080 &
            SERVER_PID=$!
            cd ..
        elif command -v node >/dev/null 2>&1; then
            npx http-server public -p 8080 -c-1 &
            SERVER_PID=$!
        else
            echo -e "${RED}❌ No suitable HTTP server found. Please install Python or Node.js.${NC}"
            exit 1
        fi
        
        # Wait for service
        if wait_for_service "http://localhost:8080"; then
            show_connection_info "http" "8080"
            echo -e "${GREEN}🎉 WASM mode started successfully!${NC}"
            echo -e "${YELLOW}⚠️  Note: WASM mode runs detection locally in browser${NC}"
            echo -e "${YELLOW}🛑 Press Ctrl+C to stop${NC}"
            
            # Handle cleanup
            trap "echo -e '\n${YELLOW}🛑 Stopping server...${NC}'; kill $SERVER_PID 2>/dev/null || true; exit 0" INT TERM
            wait $SERVER_PID
        else
            kill $SERVER_PID 2>/dev/null || true
            exit 1
        fi
        ;;
esac
