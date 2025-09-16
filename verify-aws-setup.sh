#!/bin/bash

# AWS CLI Verification Script
# Quick script to verify AWS CLI installation and configuration

set -e

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
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

echo "=================================================================="
echo "                    AWS CLI Verification Script"
echo "=================================================================="
echo

# Check if AWS CLI is installed
log_info "Checking AWS CLI installation..."
if command -v aws >/dev/null 2>&1; then
    VERSION=$(aws --version 2>&1)
    log_success "AWS CLI is installed: $VERSION"
else
    log_error "AWS CLI is not installed or not in PATH"
    echo "Run ./setup-aws-cli.sh to install AWS CLI"
    exit 1
fi

# Check AWS CLI configuration
log_info "Checking AWS CLI configuration..."
if aws configure list >/dev/null 2>&1; then
    log_success "AWS CLI is configured"
    echo
    aws configure list
    echo
else
    log_warning "AWS CLI is not configured"
    echo "Run 'aws configure' to set up your credentials"
fi

# Test AWS connectivity and identity
log_info "Testing AWS connectivity..."
if aws sts get-caller-identity >/dev/null 2>&1; then
    log_success "Successfully connected to AWS"
    echo
    echo "Current AWS Identity:"
    aws sts get-caller-identity
    echo
else
    log_warning "Cannot connect to AWS or credentials not configured"
    echo "This might be normal if you haven't configured credentials yet"
fi

# Check available profiles
log_info "Checking configured profiles..."
PROFILES=$(aws configure list-profiles 2>/dev/null || echo "")
if [ -n "$PROFILES" ]; then
    log_success "Configured profiles:"
    echo "$PROFILES" | sed 's/^/  • /'
else
    log_info "No named profiles configured (using default)"
fi
echo

# Check AWS configuration files
log_info "Checking AWS configuration files..."
if [ -f ~/.aws/credentials ]; then
    log_success "Credentials file exists: ~/.aws/credentials"
else
    log_warning "Credentials file not found: ~/.aws/credentials"
fi

if [ -f ~/.aws/config ]; then
    log_success "Config file exists: ~/.aws/config"
else
    log_warning "Config file not found: ~/.aws/config"
fi
echo

# Test S3 access (if configured)
log_info "Testing S3 access..."
if aws s3 ls >/dev/null 2>&1; then
    log_success "S3 access working"
    S3_BUCKETS=$(aws s3 ls | wc -l)
    echo "  • Found $S3_BUCKETS S3 buckets"
else
    log_warning "Cannot access S3 (normal if no S3 permissions or not configured)"
fi

# Check CDK if available
log_info "Checking AWS CDK..."
if command -v cdk >/dev/null 2>&1; then
    CDK_VERSION=$(cdk --version)
    log_success "AWS CDK is installed: $CDK_VERSION"
    
    # Check if CDK is bootstrapped
    if aws cloudformation describe-stacks --stack-name CDKToolkit >/dev/null 2>&1; then
        log_success "CDK is bootstrapped in current account/region"
    else
        log_warning "CDK is not bootstrapped. Run 'cdk bootstrap' to set it up"
    fi
else
    log_warning "AWS CDK is not installed"
    echo "Install with: npm install -g aws-cdk"
fi
echo

# Summary
echo "=================================================================="
echo "                         VERIFICATION SUMMARY"
echo "=================================================================="

# Overall status
if command -v aws >/dev/null 2>&1 && aws configure list >/dev/null 2>&1; then
    if aws sts get-caller-identity >/dev/null 2>&1; then
        log_success "AWS CLI is fully functional and configured"
        echo
        echo "🎉 You're ready to use AWS CLI and CDK!"
        echo
        echo "Next steps:"
        echo "  • For CDK projects: cdk bootstrap (if not done)"
        echo "  • Test commands: aws s3 ls, aws ec2 describe-regions"
        echo "  • Deploy infrastructure: cdk deploy"
    else
        log_warning "AWS CLI is installed but cannot connect to AWS"
        echo
        echo "📋 To fix this:"
        echo "  • Run: aws configure"
        echo "  • Or check your credentials and network connection"
    fi
else
    log_error "AWS CLI setup is incomplete"
    echo
    echo "📋 To fix this:"
    echo "  • Run: ./setup-aws-cli.sh"
    echo "  • Or follow the manual setup guide in AWS-Setup-Commands.md"
fi

echo "=================================================================="