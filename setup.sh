#!/bin/bash

# Vision Transformer Demo Setup Script
# Creates virtual environment and installs dependencies

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=============================================="
echo "Vision Transformer Demo - Setup"
echo "=============================================="
echo ""

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 not found. Please install Python 3.8+${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo -e "${GREEN}✓${NC} Found Python $PYTHON_VERSION"

# Create virtual environment
VENV_DIR="venv"

if [ -d "$VENV_DIR" ]; then
    echo -e "${YELLOW}Virtual environment already exists.${NC}"
    read -p "Recreate it? (y/N): " recreate
    if [[ $recreate =~ ^[Yy]$ ]]; then
        echo "Removing existing venv..."
        rm -rf "$VENV_DIR"
    else
        echo "Using existing venv..."
    fi
fi

if [ ! -d "$VENV_DIR" ]; then
    echo ""
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create virtual environment.${NC}"
        echo "Try: sudo apt install python3-venv"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to activate virtual environment.${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Virtual environment activated"

# Upgrade pip
echo ""
echo "Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1
echo -e "${GREEN}✓${NC} pip upgraded"

# Install dependencies
echo ""
echo "Installing dependencies..."
echo "  - torch"
echo "  - transformers"
echo "  - pillow"
echo ""
echo "This may take a few minutes..."

pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install dependencies.${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Dependencies installed"

# Check for GPU
echo ""
echo "Checking for GPU support..."
python3 -c "import torch; print('GPU Available:', torch.cuda.is_available()); print('GPU Name:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'N/A')" 2>/dev/null

# Create a test download script
echo ""
echo "Creating test image download script..."
cat > download_test_image.sh << 'EOF'
#!/bin/bash
# Download a sample image for testing

if [ ! -f "dog.jpg" ]; then
    echo "Downloading sample test image..."
    wget -q https://raw.githubusercontent.com/pytorch/hub/master/images/dog.jpg
    if [ $? -eq 0 ]; then
        echo "✓ Downloaded dog.jpg"
    else
        curl -s -o dog.jpg https://raw.githubusercontent.com/pytorch/hub/master/images/dog.jpg
        if [ $? -eq 0 ]; then
            echo "✓ Downloaded dog.jpg"
        else
            echo "Failed to download test image. You can use your own image."
        fi
    fi
else
    echo "✓ dog.jpg already exists"
fi
EOF

chmod +x download_test_image.sh
echo -e "${GREEN}✓${NC} Created download_test_image.sh"

# Create run script
echo ""
echo "Creating run script..."
cat > run.sh << 'EOF'
#!/bin/bash
# Convenience script to run the demo

if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found. Run ./setup.sh first"
    exit 1
fi

source venv/bin/activate

if [ $# -eq 0 ]; then
    echo "Usage: ./run.sh <image_path> [top_k]"
    echo ""
    echo "Examples:"
    echo "  ./run.sh dog.jpg"
    echo "  ./run.sh dog.jpg 10"
    exit 1
fi

EOF

chmod +x run.sh
echo -e "${GREEN}✓${NC} Created run.sh"

# Summary
echo ""
echo "=============================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=============================================="
echo ""
echo "Quick Start:"
echo ""
echo "1. Download a test image:"
echo "   ${YELLOW}./download_test_image.sh${NC}"
echo ""
echo "2. Run the demo:"
echo "   ${YELLOW}./run.sh dog.jpg${NC}"
echo ""
echo "   Or manually:"
echo "   ${YELLOW}source venv/bin/activate${NC}"
echo "   ${YELLOW}python test.py dog.jpg${NC}"
echo ""
echo "3. Use your own images:"
echo "   ${YELLOW}./run.sh /path/to/your/image.jpg${NC}"
echo ""
echo "Note: First run will download the model (~350MB)"
echo "      This happens once, then it's cached locally."
echo ""
echo "=============================================="

