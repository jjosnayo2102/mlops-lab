#!/bin/bash

# MLOps Lab - Docker Compose Helper Script
# Este script facilita la gestión de los servicios Docker

set -e

# Colors para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║     MLOps Lab - Docker Manager         ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Function to display help
show_help() {
    echo "Usage: ./docker-manager.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo -e "  ${GREEN}start${NC}      Build and start all services"
    echo -e "  ${GREEN}stop${NC}       Stop all services"
    echo -e "  ${GREEN}restart${NC}    Restart all services"
    echo -e "  ${GREEN}logs${NC}       Show logs from all services"
    echo -e "  ${GREEN}logs-api${NC}   Show logs from API service only"
    echo -e "  ${GREEN}logs-ui${NC}    Show logs from Streamlit service only"
    echo -e "  ${GREEN}status${NC}     Show status of all services"
    echo -e "  ${GREEN}clean${NC}      Stop and remove all containers, networks, and volumes"
    echo -e "  ${GREEN}rebuild${NC}    Clean and rebuild everything from scratch"
    echo -e "  ${GREEN}shell-api${NC}  Open bash shell in API container"
    echo -e "  ${GREEN}shell-ui${NC}   Open bash shell in Streamlit container"
    echo -e "  ${GREEN}test${NC}       Test API connectivity"
    echo -e "  ${GREEN}help${NC}       Show this help message"
    echo ""
}

# Function to start services
start_services() {
    echo -e "${YELLOW}🚀 Building and starting services...${NC}"
    docker-compose up --build -d
    echo ""
    echo -e "${GREEN}✅ Services started successfully!${NC}"
    echo ""
    show_urls
}

# Function to stop services
stop_services() {
    echo -e "${YELLOW}🛑 Stopping services...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Services stopped${NC}"
}

# Function to restart services
restart_services() {
    echo -e "${YELLOW}🔄 Restarting services...${NC}"
    docker-compose restart
    echo -e "${GREEN}✅ Services restarted${NC}"
    show_urls
}

# Function to show logs
show_logs() {
    echo -e "${YELLOW}📋 Showing logs (Ctrl+C to exit)...${NC}"
    docker-compose logs -f
}

# Function to show API logs
show_api_logs() {
    echo -e "${YELLOW}📋 Showing API logs (Ctrl+C to exit)...${NC}"
    docker-compose logs -f api
}

# Function to show Streamlit logs
show_streamlit_logs() {
    echo -e "${YELLOW}📋 Showing Streamlit logs (Ctrl+C to exit)...${NC}"
    docker-compose logs -f streamlit
}

# Function to show status
show_status() {
    echo -e "${YELLOW}📊 Service Status:${NC}"
    docker-compose ps
}

# Function to clean everything
clean_all() {
    echo -e "${RED}🧹 Cleaning all containers, networks, and volumes...${NC}"
    docker-compose down -v
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}

# Function to rebuild from scratch
rebuild_all() {
    echo -e "${RED}🔨 Rebuilding everything from scratch...${NC}"
    docker-compose down -v
    docker-compose build --no-cache
    docker-compose up -d
    echo ""
    echo -e "${GREEN}✅ Rebuild complete!${NC}"
    echo ""
    show_urls
}

# Function to open shell in API container
shell_api() {
    echo -e "${YELLOW}🐚 Opening shell in API container...${NC}"
    docker-compose exec api bash
}

# Function to open shell in Streamlit container
shell_streamlit() {
    echo -e "${YELLOW}🐚 Opening shell in Streamlit container...${NC}"
    docker-compose exec streamlit bash
}

# Function to test API
test_api() {
    echo -e "${YELLOW}🧪 Testing API connectivity...${NC}"
    echo ""
    
    # Test health endpoint
    echo -e "${BLUE}Testing health endpoint...${NC}"
    if curl -s http://localhost:8000/health > /dev/null; then
        echo -e "${GREEN}✅ API is healthy${NC}"
    else
        echo -e "${RED}❌ API is not responding${NC}"
        return 1
    fi
    
    # Test prediction endpoint
    echo ""
    echo -e "${BLUE}Testing prediction endpoint...${NC}"
    response=$(curl -s -X POST http://localhost:8000/predict \
        -H "Content-Type: application/json" \
        -d '{
            "sqft": 2000,
            "bedrooms": 3,
            "bathrooms": 2,
            "location": "Suburb",
            "year_built": 2010,
            "condition": "Good"
        }')
    
    if echo "$response" | grep -q "predicted_price"; then
        echo -e "${GREEN}✅ Prediction endpoint working${NC}"
        echo ""
        echo "Sample prediction response:"
        echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
    else
        echo -e "${RED}❌ Prediction endpoint failed${NC}"
        return 1
    fi
}

# Function to show URLs
show_urls() {
    echo -e "${BLUE}📍 Access your services at:${NC}"
    echo -e "  ${GREEN}API (FastAPI):${NC}     http://localhost:8000"
    echo -e "  ${GREEN}API Docs:${NC}          http://localhost:8000/docs"
    echo -e "  ${GREEN}Streamlit UI:${NC}      http://localhost:8501"
    echo ""
}

# Main script logic
case "${1:-help}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        show_logs
        ;;
    logs-api)
        show_api_logs
        ;;
    logs-ui)
        show_streamlit_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_all
        ;;
    rebuild)
        rebuild_all
        ;;
    shell-api)
        shell_api
        ;;
    shell-ui)
        shell_streamlit
        ;;
    test)
        test_api
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac