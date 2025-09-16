#!/bin/bash

# AWS CLI Quick Setup Script
# This script installs and configures AWS CLI with persistent environment setup
# Compatible with Ubuntu/Debian systems

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$NAME
            VERSION=$VERSION_ID
        else
            OS="Unknown Linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    else
        OS="Unknown"
    fi
    log_info "Detected OS: $OS"
}

# Function to install AWS CLI
install_aws_cli() {
    log_info "Installing AWS CLI..."
    
    # Check if AWS CLI is already installed
    if command_exists aws; then
        CURRENT_VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
        log_warning "AWS CLI is already installed (version: $CURRENT_VERSION)"
        read -p "Do you want to reinstall/update? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Skipping AWS CLI installation"
            return 0
        fi
    fi

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_info "Installing AWS CLI for Linux..."
        
        # Install required packages
        log_info "Installing required packages..."
        sudo apt update
        sudo apt install -y curl unzip
        
        # Download AWS CLI
        log_info "Downloading AWS CLI v2..."
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        
        # Unzip and install
        log_info "Installing AWS CLI..."
        unzip -q awscliv2.zip
        sudo ./aws/install --update
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Installing AWS CLI for macOS..."
        
        # Check if Homebrew is available
        if command_exists brew; then
            brew install awscli
        else
            # Download and install manually
            curl -sL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg AWSCLIV2.pkg -target /
        fi
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    # Verify installation
    if command_exists aws; then
        VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
        log_success "AWS CLI v$VERSION installed successfully"
    else
        log_error "AWS CLI installation failed"
        exit 1
    fi
}

# Function to setup persistent environment
setup_persistent_env() {
    log_info "Setting up persistent environment configuration..."
    
    # Backup existing files
    for file in ~/.bashrc ~/.bash_profile ~/.profile ~/.zshrc; do
        if [ -f "$file" ]; then
            cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        fi
    done
    
    # AWS CLI configuration block
    AWS_CONFIG="
# AWS CLI Configuration - Added by setup script
export PATH=\$PATH:/usr/local/bin
alias awscli=\"aws\"
complete -C \"/usr/local/bin/aws_completer\" aws 2>/dev/null || true
"
    
    # Add to .bashrc
    if [ -f ~/.bashrc ]; then
        if ! grep -q "AWS CLI Configuration" ~/.bashrc; then
            echo "$AWS_CONFIG" >> ~/.bashrc
            log_success "Added AWS CLI configuration to ~/.bashrc"
        else
            log_warning "AWS CLI configuration already exists in ~/.bashrc"
        fi
    fi
    
    # Create or update .bash_profile
    if [ ! -f ~/.bash_profile ]; then
        cat << 'EOF' > ~/.bash_profile
# Load .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# AWS CLI Configuration
export PATH=$PATH:/usr/local/bin
EOF
        log_success "Created ~/.bash_profile with AWS CLI configuration"
    else
        if ! grep -q "AWS CLI Configuration" ~/.bash_profile; then
            echo "$AWS_CONFIG" >> ~/.bash_profile
            log_success "Added AWS CLI configuration to ~/.bash_profile"
        fi
    fi
    
    # Add to .profile
    if [ -f ~/.profile ]; then
        if ! grep -q "AWS CLI Configuration" ~/.profile; then
            echo "$AWS_CONFIG" >> ~/.profile
            log_success "Added AWS CLI configuration to ~/.profile"
        else
            log_warning "AWS CLI configuration already exists in ~/.profile"
        fi
    fi
    
    # Add to .zshrc if it exists (for zsh users)
    if [ -f ~/.zshrc ]; then
        if ! grep -q "AWS CLI Configuration" ~/.zshrc; then
            echo "$AWS_CONFIG" >> ~/.zshrc
            log_success "Added AWS CLI configuration to ~/.zshrc"
        else
            log_warning "AWS CLI configuration already exists in ~/.zshrc"
        fi
    fi
}

# Function to configure AWS CLI
configure_aws_cli() {
    log_info "AWS CLI Configuration Options:"
    echo "1. Interactive configuration (aws configure)"
    echo "2. Skip configuration (configure manually later)"
    echo "3. Setup with environment variables"
    
    read -p "Choose an option (1-3): " -n 1 -r
    echo
    
    case $REPLY in
        1)
            log_info "Starting interactive AWS CLI configuration..."
            aws configure
            ;;
        2)
            log_info "Skipping AWS CLI configuration"
            log_info "You can configure it later using: aws configure"
            ;;
        3)
            log_info "Setting up environment variables..."
            read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
            read -s -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
            echo
            read -p "Enter Default Region (e.g., us-east-1): " AWS_DEFAULT_REGION
            read -p "Enter Default Output Format (json/yaml/text/table) [json]: " AWS_DEFAULT_OUTPUT
            AWS_DEFAULT_OUTPUT=${AWS_DEFAULT_OUTPUT:-json}
            
            # Add to shell configuration
            ENV_CONFIG="
# AWS CLI Environment Variables
export AWS_ACCESS_KEY_ID=\"$AWS_ACCESS_KEY_ID\"
export AWS_SECRET_ACCESS_KEY=\"$AWS_SECRET_ACCESS_KEY\"
export AWS_DEFAULT_REGION=\"$AWS_DEFAULT_REGION\"
export AWS_DEFAULT_OUTPUT=\"$AWS_DEFAULT_OUTPUT\"
"
            echo "$ENV_CONFIG" >> ~/.bashrc
            [ -f ~/.zshrc ] && echo "$ENV_CONFIG" >> ~/.zshrc
            
            log_success "Environment variables configured"
            log_warning "Note: Credentials are stored in shell config files. Consider using 'aws configure' for better security."
            ;;
        *)
            log_warning "Invalid option. Skipping configuration."
            ;;
    esac
}

# Function to verify installation
verify_installation() {
    log_info "Verifying AWS CLI installation..."
    
    # Source the shell configuration
    source ~/.bashrc 2>/dev/null || true
    
    # Check AWS CLI version
    if command_exists aws; then
        VERSION=$(aws --version)
        log_success "AWS CLI is working: $VERSION"
    else
        log_error "AWS CLI command not found"
        return 1
    fi
    
    # Check AWS configuration
    log_info "Checking AWS configuration..."
    if aws configure list >/dev/null 2>&1; then
        log_success "AWS CLI is configured"
        aws configure list
    else
        log_warning "AWS CLI is not configured yet"
        log_info "Run 'aws configure' to set up your credentials"
    fi
    
    # Test connectivity (if configured)
    if aws sts get-caller-identity >/dev/null 2>&1; then
        log_success "AWS connectivity test passed"
        aws sts get-caller-identity
    else
        log_info "AWS connectivity test skipped (not configured or no internet)"
    fi
}

# Function to install additional tools
install_additional_tools() {
    log_info "Installing additional AWS tools..."
    
    # Install AWS CDK if Node.js is available
    if command_exists npm; then
        read -p "Install AWS CDK? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            npm install -g aws-cdk
            log_success "AWS CDK installed"
        fi
    fi
    
    # Install AWS SAM CLI
    read -p "Install AWS SAM CLI? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            wget -q https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
            unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation
            sudo ./sam-installation/install --update
            rm -rf aws-sam-cli-linux-x86_64.zip sam-installation
            log_success "AWS SAM CLI installed"
        else
            log_info "Please install AWS SAM CLI manually for your OS"
        fi
    fi
}

# Function to show post-installation info
show_post_install_info() {
    log_success "AWS CLI setup completed!"
    echo
    echo "=================================================================="
    echo "                    POST-INSTALLATION INFORMATION"
    echo "=================================================================="
    echo
    echo "✅ AWS CLI installed and configured for persistent use"
    echo "✅ Shell configuration updated (bashrc, profile, etc.)"
    echo
    echo "📝 NEXT STEPS:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. If not configured, run: aws configure"
    echo "3. Test with: aws sts get-caller-identity"
    echo "4. For CDK projects, run: npx cdk bootstrap"
    echo
    echo "🔧 USEFUL COMMANDS:"
    echo "• aws configure                    # Configure credentials"
    echo "• aws configure list               # Show current configuration"
    echo "• aws sts get-caller-identity      # Test connectivity"
    echo "• aws s3 ls                        # List S3 buckets"
    echo "• aws --version                    # Show AWS CLI version"
    echo
    echo "📚 DOCUMENTATION:"
    echo "• AWS CLI Guide: https://docs.aws.amazon.com/cli/"
    echo "• AWS CDK Guide: https://docs.aws.amazon.com/cdk/"
    echo
    echo "🆘 TROUBLESHOOTING:"
    echo "• Check configuration: aws configure list"
    echo "• Check credentials: cat ~/.aws/credentials"
    echo "• Reset configuration: rm -rf ~/.aws && aws configure"
    echo
    echo "=================================================================="
}

# Main execution
main() {
    echo "=================================================================="
    echo "                    AWS CLI Quick Setup Script"
    echo "=================================================================="
    echo
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_warning "Running as root. This script should be run as a regular user."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    detect_os
    install_aws_cli
    setup_persistent_env
    
    # Ask if user wants to configure now
    read -p "Configure AWS CLI now? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        configure_aws_cli
    fi
    
    verify_installation
    
    # Ask for additional tools
    read -p "Install additional AWS tools? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_additional_tools
    fi
    
    show_post_install_info
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "AWS CLI Quick Setup Script"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  -h, --help     Show this help message"
            echo "  --skip-config  Skip AWS CLI configuration"
            echo "  --uninstall    Uninstall AWS CLI"
            echo
            exit 0
            ;;
        --skip-config)
            SKIP_CONFIG=true
            shift
            ;;
        --uninstall)
            log_info "Uninstalling AWS CLI..."
            sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws /usr/local/bin/aws_completer
            log_success "AWS CLI uninstalled"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Run main function
main

# Source the updated shell configuration
exec bash