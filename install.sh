#!/bin/bash

# Feed.Fi Installation Script
# Automates the setup process for development environment

set -e

echo "🚀 Feed.Fi Installation Script"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

# Check if Xcode is installed
print_step "Checking for Xcode..."
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi
print_success "Xcode found"

# Check if Git is available
print_step "Checking for Git..."
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi
print_success "Git found"

# Setup environment variables
print_step "Setting up environment configuration..."

if [ ! -f ".env" ]; then
    cp .env.example .env
    print_success "Created .env file from template"
    print_warning "Please edit .env file and add your GEMINI_API_KEY"
else
    print_warning ".env file already exists, skipping..."
fi

# Setup Xcode configuration
print_step "Setting up Xcode developer settings..."

SHARED_SETTINGS_DIR="../SharedXcodeSettings"
DEVELOPER_SETTINGS="$SHARED_SETTINGS_DIR/DeveloperSettings.xcconfig"

if [ ! -d "$SHARED_SETTINGS_DIR" ]; then
    mkdir -p "$SHARED_SETTINGS_DIR"
    print_success "Created SharedXcodeSettings directory"
fi

if [ ! -f "$DEVELOPER_SETTINGS" ]; then
    read -p "Enter your Apple Developer Team ID (optional, press Enter to skip): " TEAM_ID
    read -p "Enter your organization identifier (default: com.feedfi.dev): " ORG_ID
    ORG_ID=${ORG_ID:-com.feedfi.dev}
    
    cat > "$DEVELOPER_SETTINGS" << EOF
CODE_SIGN_IDENTITY = Mac Developer
DEVELOPMENT_TEAM = ${TEAM_ID}
CODE_SIGN_STYLE = Automatic
ORGANIZATION_IDENTIFIER = ${ORG_ID}
DEVELOPER_ENTITLEMENTS = -dev
PROVISIONING_PROFILE_SPECIFIER =
EOF
    
    print_success "Created DeveloperSettings.xcconfig"
else
    print_warning "DeveloperSettings.xcconfig already exists, skipping..."
fi

# Check for Python (optional)
print_step "Checking for Python (optional for AI scripts)..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_success "Python $PYTHON_VERSION found"
    
    read -p "Do you want to set up Python virtual environment for AI scripts? (y/N): " setup_python
    if [[ $setup_python == "y" || $setup_python == "Y" ]]; then
        print_step "Setting up Python virtual environment..."
        
        if [ ! -d ".venv" ]; then
            python3 -m venv .venv
            print_success "Created Python virtual environment"
        fi
        
        source .venv/bin/activate
        
        if [ -f "requirements_Version2.txt" ]; then
            pip install -r requirements_Version2.txt
            print_success "Installed Python dependencies"
        fi
        
        deactivate
    fi
else
    print_warning "Python not found. AI script features will be limited."
fi

# Verify project structure
print_step "Verifying project structure..."

REQUIRED_DIRS=(
    "Mac"
    "Shared"
    "Modules"
    "Widget"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "Found $dir directory"
    else
        print_error "Missing $dir directory. Project structure may be corrupted."
        exit 1
    fi
done

# Check for key files
REQUIRED_FILES=(
    "Feed.Fi.xcodeproj"
    "README.md"
    ".env.example"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Found $file"
    else
        print_error "Missing $file. Project may be incomplete."
        exit 1
    fi
done

# Final instructions
echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Edit the .env file and add your GEMINI_API_KEY"
echo "2. Open Feed.Fi.xcodeproj in Xcode"
echo "3. Build and run the project"
echo ""
echo "For AI features:"
echo "• Get your Gemini API key from: https://makersuite.google.com/app/apikey"
echo "• Add it to your .env file as: GEMINI_API_KEY=your_key_here"
echo ""
echo "For more information, check the README.md file."
echo ""
echo "Happy coding! 🚀"