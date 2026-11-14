#!/bin/bash

# Quick Test Script for MLOps Lab Docker Setup
# Este script verifica que los servicios estén funcionando correctamente

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  MLOps Lab - Quick Test Suite            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Check if services are running
echo -e "${YELLOW}📊 Checking if services are running...${NC}"
if ! docker-compose ps | grep -q "Up"; then
    echo -e "${RED}❌ Services are not running. Please run './docker-manager.sh start' first${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Services are running${NC}"
echo ""

# Test API Health
echo -e "${YELLOW}🏥 Testing API health endpoint...${NC}"
if response=$(curl -s -f http://localhost:8000/health); then
    echo -e "${GREEN}✅ API health check passed${NC}"
    echo "   Response: $response"
else
    echo -e "${RED}❌ API health check failed${NC}"
    exit 1
fi
echo ""

# Test API Docs
echo -e "${YELLOW}📚 Testing API documentation endpoint...${NC}"
if curl -s -f http://localhost:8000/docs > /dev/null; then
    echo -e "${GREEN}✅ API docs are accessible at http://localhost:8000/docs${NC}"
else
    echo -e "${RED}❌ API docs are not accessible${NC}"
    exit 1
fi
echo ""

# Test Prediction Endpoint
echo -e "${YELLOW}🔮 Testing prediction endpoint...${NC}"
prediction=$(curl -s -X POST http://localhost:8000/predict \
    -H "Content-Type: application/json" \
    -d '{
        "sqft": 2000,
        "bedrooms": 3,
        "bathrooms": 2,
        "location": "Suburb",
        "year_built": 2010,
        "condition": "Good"
    }')

if echo "$prediction" | grep -q "predicted_price"; then
    echo -e "${GREEN}✅ Prediction endpoint working${NC}"
    
    # Extract and display predicted price
    if command -v python3 &> /dev/null; then
        price=$(echo "$prediction" | python3 -c "import sys, json; data=json.load(sys.stdin); print(f\"\${data['predicted_price']:,.2f}\")" 2>/dev/null || echo "N/A")
        echo "   Predicted Price: $price"
    fi
    
    echo "   Full response:"
    echo "$prediction" | python3 -m json.tool 2>/dev/null || echo "$prediction"
else
    echo -e "${RED}❌ Prediction endpoint failed${NC}"
    echo "   Response: $prediction"
    exit 1
fi
echo ""

# Test Streamlit
echo -e "${YELLOW}🎨 Testing Streamlit frontend...${NC}"
if curl -s -f http://localhost:8501/_stcore/health > /dev/null; then
    echo -e "${GREEN}✅ Streamlit is accessible at http://localhost:8501${NC}"
else
    echo -e "${RED}❌ Streamlit is not accessible${NC}"
    exit 1
fi
echo ""

# Test Network Connectivity (Streamlit -> API)
echo -e "${YELLOW}🌐 Testing network connectivity between services...${NC}"
if docker-compose exec -T streamlit curl -s -f http://api:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Streamlit can reach API backend${NC}"
else
    echo -e "${RED}❌ Network connectivity issue between services${NC}"
    exit 1
fi
echo ""

# Summary
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ All Tests Passed Successfully!       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Access your applications:${NC}"
echo -e "  • API Backend:     ${GREEN}http://localhost:8000${NC}"
echo -e "  • API Docs:        ${GREEN}http://localhost:8000/docs${NC}"
echo -e "  • Streamlit UI:    ${GREEN}http://localhost:8501${NC}"
echo ""