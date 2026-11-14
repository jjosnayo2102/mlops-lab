#!/bin/bash

# API Test Examples
# Ejemplos de cómo usar la API de predicción de precios

echo "🏠 House Price Prediction API - Test Examples"
echo "=============================================="
echo ""

# Base URL
API_URL="${API_URL:-http://localhost:8000}"

echo "📍 API URL: $API_URL"
echo ""

# Test 1: Health Check
echo "1️⃣  Health Check"
echo "   Command: curl $API_URL/health"
echo ""
curl -s $API_URL/health | python3 -m json.tool 2>/dev/null || curl -s $API_URL/health
echo ""
echo ""

# Test 2: Basic Prediction - Suburban House
echo "2️⃣  Prediction: Suburban Family Home"
echo "   (2000 sqft, 3 bed, 2 bath, built 2010)"
echo ""
curl -s -X POST "$API_URL/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 2000,
    "bedrooms": 3,
    "bathrooms": 2,
    "location": "Suburb",
    "year_built": 2010,
    "condition": "Good"
  }' | python3 -m json.tool 2>/dev/null
echo ""
echo ""

# Test 3: Luxury Downtown Condo
echo "3️⃣  Prediction: Luxury Downtown Condo"
echo "   (1500 sqft, 2 bed, 2.5 bath, built 2020)"
echo ""
curl -s -X POST "$API_URL/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 1500,
    "bedrooms": 2,
    "bathrooms": 2.5,
    "location": "Downtown",
    "year_built": 2020,
    "condition": "Excellent"
  }' | python3 -m json.tool 2>/dev/null
echo ""
echo ""

# Test 4: Rural Property
echo "4️⃣  Prediction: Rural Property"
echo "   (2500 sqft, 4 bed, 3 bath, built 1995)"
echo ""
curl -s -X POST "$API_URL/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 2500,
    "bedrooms": 4,
    "bathrooms": 3,
    "location": "Rural",
    "year_built": 1995,
    "condition": "Fair"
  }' | python3 -m json.tool 2>/dev/null
echo ""
echo ""

# Test 5: Waterfront Estate
echo "5️⃣  Prediction: Waterfront Estate"
echo "   (4000 sqft, 5 bed, 4 bath, built 2015)"
echo ""
curl -s -X POST "$API_URL/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 4000,
    "bedrooms": 5,
    "bathrooms": 4,
    "location": "Waterfront",
    "year_built": 2015,
    "condition": "Excellent"
  }' | python3 -m json.tool 2>/dev/null
echo ""
echo ""

# Test 6: Small Urban Apartment
echo "6️⃣  Prediction: Small Urban Apartment"
echo "   (800 sqft, 1 bed, 1 bath, built 2018)"
echo ""
curl -s -X POST "$API_URL/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 800,
    "bedrooms": 1,
    "bathrooms": 1,
    "location": "Urban",
    "year_built": 2018,
    "condition": "Good"
  }' | python3 -m json.tool 2>/dev/null
echo ""
echo ""

echo "✅ All test examples completed!"
echo ""
echo "💡 Tips:"
echo "   - Modify the JSON data to test different scenarios"
echo "   - Check the API docs at $API_URL/docs for more details"
echo "   - Use the Streamlit UI at http://localhost:8501 for interactive testing"