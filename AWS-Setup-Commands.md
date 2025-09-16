# AWS CLI Setup Guide

## 🚀 Quick Setup (Recommended)

### Automated Setup Script
Use the provided shell script for a complete, automated setup:

```bash
# Make script executable and run
chmod +x setup-aws-cli.sh
./setup-aws-cli.sh
```

**Features of the setup script:**
- ✅ Automatically detects your operating system
- ✅ Installs the latest AWS CLI v2
- ✅ Sets up persistent environment configuration
- ✅ Configures shell profiles (bashrc, bash_profile, profile, zshrc)
- ✅ Includes tab completion
- ✅ Optional AWS CLI configuration
- ✅ Optional additional tools (CDK, SAM CLI)
- ✅ Comprehensive verification and testing

### Script Options
```bash
./setup-aws-cli.sh --help           # Show help
./setup-aws-cli.sh --skip-config    # Skip AWS configuration
./setup-aws-cli.sh --uninstall      # Uninstall AWS CLI
```

---

## 🔧 Manual Installation Options

### Option A: Official AWS CLI v2 Installer (Recommended)
```bash
# Download the AWS CLI installer
curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install required packages
sudo apt update && sudo apt install -y unzip

# Unzip and install
unzip awscliv2.zip
sudo ./aws/install --update

# Verify installation
aws --version

# Clean up
rm -rf awscliv2.zip aws/
```

### Option B: Using Package Manager (Ubuntu/Debian)
```bash
# Update package index
sudo apt update

# Install AWS CLI (may be older version)
sudo apt install awscli -y

# Verify installation
aws --version
```

### Option C: Using pip (Python)
```bash
# Install pip if not available
sudo apt install python3-pip -y

# Install AWS CLI
pip3 install awscli --user

# Add to PATH
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
aws --version
```

### Option D: macOS Installation
```bash
# Using Homebrew
brew install awscli

# Or download the official installer
curl -sL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

## ⚙️ AWS CLI Configuration

### Method 1: Interactive Configuration (Recommended)
```bash
# Basic configuration
aws configure

# Configure with a specific profile
aws configure --profile production
aws configure --profile development

# Set default profile
export AWS_PROFILE=production
```

**You'll be prompted for:**
- **AWS Access Key ID**: Your access key
- **AWS Secret Access Key**: Your secret key  
- **Default region**: e.g., `us-east-1`, `us-west-2`, `eu-west-1`
- **Default output format**: `json`, `yaml`, `text`, or `table`

### Method 2: Environment Variables
```bash
# Temporary (current session only)
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_DEFAULT_OUTPUT="json"

# Persistent (add to ~/.bashrc)
echo 'export AWS_ACCESS_KEY_ID="your-access-key-id"' >> ~/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY="your-secret-access-key"' >> ~/.bashrc
echo 'export AWS_DEFAULT_REGION="us-east-1"' >> ~/.bashrc
echo 'export AWS_DEFAULT_OUTPUT="json"' >> ~/.bashrc
source ~/.bashrc
```

### Method 3: Multiple Profiles
```bash
# Configure multiple profiles
aws configure --profile work
aws configure --profile personal

# Use specific profile
aws s3 ls --profile work
aws ec2 describe-instances --profile personal

# Set default profile
export AWS_PROFILE=work

# List all profiles
aws configure list-profiles
```

## ✅ Verify Installation & Configuration

### Quick Verification
```bash
# Check AWS CLI version
aws --version

# Check configuration
aws configure list

# Test connectivity and identity
aws sts get-caller-identity

# List all configured profiles
aws configure list-profiles
```

### Comprehensive Testing
```bash
# Test basic AWS services (if you have permissions)
aws s3 ls                           # List S3 buckets
aws ec2 describe-regions            # List EC2 regions
aws iam get-user                    # Get current user info
aws cloudformation list-stacks      # List CloudFormation stacks

# Test with specific profile
aws s3 ls --profile myprofile
```

## 📁 Configuration Files

### File Locations
```bash
# AWS credentials
~/.aws/credentials

# AWS configuration  
~/.aws/config

# View configuration files
cat ~/.aws/credentials
cat ~/.aws/config
```

### Example ~/.aws/credentials
```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[production]
aws_access_key_id = AKIAI44QH8DHBEXAMPLE
aws_secret_access_key = je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY

[development]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### Example ~/.aws/config
```ini
[default]
region = us-east-1
output = json
cli_pager = 

[profile production]
region = us-west-2
output = yaml
cli_pager = 

[profile development]
region = us-east-1
output = table
cli_pager = less
```

## 🔒 Security Best Practices

### 1. IAM Roles (Recommended for EC2/ECS/Lambda)
```bash
# No credentials needed - AWS CLI automatically uses instance profile
# Configure region only
aws configure set region us-east-1

# Verify role-based access
aws sts get-caller-identity
```

### 2. AWS SSO (Single Sign-On)
```bash
# Configure AWS SSO
aws configure sso

# Configure SSO profile
aws configure sso --profile sso-production

# Login to AWS SSO
aws sso login --profile sso-production

# Use SSO profile
aws s3 ls --profile sso-production
```

### 3. Temporary Credentials & MFA
```bash
# Assume a role with MFA
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/MyRole \
  --role-session-name MySession \
  --serial-number arn:aws:iam::123456789012:mfa/user \
  --token-code 123456

# Get session token with MFA
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/user \
  --token-code 123456
```

### 4. Security Recommendations
```bash
# Enable MFA for your AWS account
# Use least privilege IAM policies
# Rotate access keys regularly
# Never commit credentials to version control
# Use AWS Secrets Manager for application secrets
# Enable CloudTrail for API logging

# Check for exposed credentials
git log --patch | grep -E "(aws_access_key_id|aws_secret_access_key)"
```

## 🛠️ Essential AWS CLI Commands

### Identity & Account Information
```bash
# Get current user/role information
aws sts get-caller-identity

# Get account ID
aws sts get-caller-identity --query Account --output text

# List available regions
aws ec2 describe-regions --output table

# Get current region
aws configure get region
```

### S3 Operations
```bash
# List all buckets
aws s3 ls

# List objects in a bucket
aws s3 ls s3://my-bucket/

# Copy files
aws s3 cp file.txt s3://my-bucket/
aws s3 cp s3://my-bucket/file.txt ./

# Sync directories
aws s3 sync ./local-folder s3://my-bucket/folder/
```

### EC2 Operations
```bash
# List instances
aws ec2 describe-instances --output table

# List running instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# List security groups
aws ec2 describe-security-groups --output table

# List key pairs
aws ec2 describe-key-pairs --output table
```

### CloudFormation Operations
```bash
# List stacks
aws cloudformation list-stacks --output table

# Describe stack
aws cloudformation describe-stacks --stack-name MyStack

# List stack resources
aws cloudformation describe-stack-resources --stack-name MyStack

# Get stack outputs
aws cloudformation describe-stacks --stack-name MyStack --query 'Stacks[0].Outputs'
```

## 🏗️ AWS CDK Specific Commands

### CDK Setup & Bootstrap
```bash
# Install CDK globally
npm install -g aws-cdk

# Verify CDK installation
cdk --version

# Bootstrap CDK (required once per account/region)
cdk bootstrap

# Bootstrap with specific profile
cdk bootstrap --profile production

# Bootstrap multiple regions
cdk bootstrap aws://123456789012/us-east-1 aws://123456789012/us-west-2
```

### CDK Project Commands
```bash
# Initialize new CDK project
cdk init app --language typescript
cdk init app --language python
cdk init app --language java

# List stacks
cdk list

# Synthesize CloudFormation template
cdk synth

# Deploy stack
cdk deploy
cdk deploy MyStack --profile production

# Destroy stack
cdk destroy
cdk destroy MyStack --profile production

# Compare deployed stack with current code
cdk diff
```

### CDK Context & Configuration
```bash
# Get CDK context
aws ssm get-parameters --names /cdk-bootstrap/hnb659fds/version

# Clear CDK context
cdk context --clear

# Show CDK configuration
cdk doctor

# Get bootstrap template
cdk bootstrap --show-template > bootstrap-template.yaml
```

## 🔧 Troubleshooting Guide

### Common Installation Issues

#### 1. Command not found: aws
```bash
# Check if AWS CLI is installed
which aws
aws --version

# Check PATH
echo $PATH | grep -o '/usr/local/bin'

# Add to PATH temporarily
export PATH=$PATH:/usr/local/bin

# Add to PATH permanently
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc

# Restart terminal or run
exec bash
```

#### 2. Permission Denied Errors
```bash
# Check current credentials
aws configure list

# Check IAM user permissions
aws iam get-user
aws iam list-attached-user-policies --user-name $(aws sts get-caller-identity --query User.UserName --output text)

# Check assumed role permissions
aws sts get-caller-identity

# Reset credentials
aws configure
```

#### 3. Region Not Set Error
```bash
# Check current region
aws configure get region

# Set region temporarily
aws configure set region us-east-1

# Set region with profile
aws configure set region us-west-2 --profile myprofile

# Use region in command
aws s3 ls --region us-east-1
```

#### 4. SSL Certificate Errors
```bash
# Update certificates (Ubuntu/Debian)
sudo apt update && sudo apt install ca-certificates -y

# For specific SSL issues
aws configure set ca_bundle /etc/ssl/certs/ca-certificates.crt

# Disable SSL verification (NOT recommended for production)
aws configure set cli_verify_ssl false
```

### Configuration Issues

#### 5. Profile Not Found
```bash
# List all profiles
aws configure list-profiles

# Check specific profile
aws configure list --profile myprofile

# Create new profile
aws configure --profile newprofile

# Use profile in commands
aws s3 ls --profile myprofile
```

#### 6. Token Expired (for temporary credentials)
```bash
# Check token expiration
aws sts get-caller-identity

# Refresh SSO token
aws sso login --profile sso-profile

# Get new session token
aws sts get-session-token
```

### Network and Connectivity Issues

#### 7. Connection Timeout
```bash
# Test connectivity
curl -I https://s3.amazonaws.com

# Use different endpoint
aws s3 ls --endpoint-url https://s3.us-east-1.amazonaws.com

# Configure proxy (if needed)
aws configure set http_proxy http://proxy.example.com:8080
aws configure set https_proxy https://proxy.example.com:8080
```

#### 8. Rate Limiting / Throttling
```bash
# Configure retry settings
aws configure set max_attempts 10
aws configure set retry_mode adaptive

# Add delays between commands
sleep 1 && aws s3 ls
```

### Reset and Clean Installation

#### 9. Complete Reset
```bash
# Remove AWS configuration
rm -rf ~/.aws

# Remove AWS CLI
sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws /usr/local/bin/aws_completer

# Reinstall using script
./setup-aws-cli.sh

# Or reinstall manually
curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install --update
```

### Debug Commands

#### 10. Debug Information
```bash
# Enable debug mode
aws s3 ls --debug

# Check configuration files
cat ~/.aws/config
cat ~/.aws/credentials

# Environment variables
env | grep AWS

# System information
aws --version
python3 --version
curl --version
```

## 7. Making AWS CLI Persistent Across Terminal Sessions

To ensure AWS CLI remains available even after closing and reopening terminals, add it to your shell configuration files:

### For Bash (Ubuntu/Linux)

1. **Add to .bashrc**:
   ```bash
   echo '' >> ~/.bashrc
   echo '# AWS CLI Configuration' >> ~/.bashrc
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
   echo 'alias awscli="aws"' >> ~/.bashrc
   echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.bashrc
   ```

2. **Create .bash_profile** (if it doesn't exist):
   ```bash
   cat << 'EOF' > ~/.bash_profile
   # Load .bashrc if it exists
   if [ -f ~/.bashrc ]; then
       source ~/.bashrc
   fi
   
   # AWS CLI Configuration
   export PATH=$PATH:/usr/local/bin
   EOF
   ```

3. **Add to .profile**:
   ```bash
   echo '' >> ~/.profile
   echo '# AWS CLI Configuration' >> ~/.profile
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.profile
   ```

4. **Reload shell configuration**:
   ```bash
   source ~/.bashrc
   # or
   source ~/.bash_profile
   # or
   source ~/.profile
   ```

### Verification

After configuration, verify AWS CLI is persistent:
```bash
# Test AWS CLI
aws --version

# Test in a new terminal session
exec bash
aws --version

# Test tab completion
aws s3 <TAB>
```

### Environment Variables for AWS Configuration

You can also add AWS configuration environment variables to make them persistent:

```bash
# Add to ~/.bashrc or ~/.bash_profile
export AWS_DEFAULT_REGION=us-east-1
export AWS_DEFAULT_OUTPUT=json
export AWS_PROFILE=default

# For specific credentials (not recommended for security)
# export AWS_ACCESS_KEY_ID=your-access-key-id
# export AWS_SECRET_ACCESS_KEY=your-secret-access-key
```

**Note**: It's recommended to use `aws configure` or AWS profiles instead of hardcoding credentials in shell files for security reasons.

---

## 💡 Pro Tips & Best Practices

### Performance Optimization
```bash
# Disable pager for better scripting
aws configure set cli_pager ""

# Use output filters to reduce data transfer
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]'

# Use --no-cli-pager for individual commands
aws s3 ls --no-cli-pager

# Enable parallel transfers for S3
aws configure set s3.max_concurrent_requests 20
aws configure set s3.multipart_threshold 64MB
```

### Useful Aliases
```bash
# Add to ~/.bashrc or ~/.bash_profile
alias awsl='aws configure list'
alias awsid='aws sts get-caller-identity'
alias awsregions='aws ec2 describe-regions --output table'
alias s3ls='aws s3 ls'
alias cfls='aws cloudformation list-stacks --output table'

# CDK specific aliases
alias cdkls='cdk list'
alias cdks='cdk synth'
alias cdkd='cdk deploy'
alias cdkdiff='cdk diff'
```

### Environment Setup for Development
```bash
# Create development environment script
cat << 'EOF' > ~/aws-dev-env.sh
#!/bin/bash
export AWS_PROFILE=development
export AWS_DEFAULT_REGION=us-east-1
export CDK_DEFAULT_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export CDK_DEFAULT_REGION=$AWS_DEFAULT_REGION
echo "AWS Development Environment Loaded"
echo "Profile: $AWS_PROFILE"
echo "Region: $AWS_DEFAULT_REGION"
echo "Account: $CDK_DEFAULT_ACCOUNT"
EOF

chmod +x ~/aws-dev-env.sh
source ~/aws-dev-env.sh
```

---

## 📚 Additional Resources

### Official Documentation
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS CDK Developer Guide](https://docs.aws.amazon.com/cdk/v2/guide/)
- [AWS Security Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)

### Useful Tools & Extensions
```bash
# Install AWS CLI Session Manager plugin
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb

# Install AWS Vault for credential management
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
sudo chmod +x /usr/local/bin/aws-vault

# Install AWS CLI completion for zsh (if using zsh)
echo 'autoload bashcompinit && bashcompinit' >> ~/.zshrc
echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.zshrc
```

### VS Code Extensions
- AWS Toolkit for Visual Studio Code
- AWS CloudFormation Linter
- YAML Support by Red Hat

### Quick Reference Commands
```bash
# Most frequently used commands
aws sts get-caller-identity              # Who am I?
aws configure list                       # Current configuration
aws s3 ls                               # List S3 buckets
aws ec2 describe-instances               # List EC2 instances
aws cloudformation list-stacks          # List CloudFormation stacks
aws logs describe-log-groups             # List CloudWatch log groups
aws iam list-users                       # List IAM users
aws rds describe-db-instances            # List RDS instances
```

---

## 🆘 Getting Help

### Built-in Help
```bash
# General help
aws help

# Service-specific help
aws s3 help
aws ec2 help

# Command-specific help
aws s3 cp help
aws ec2 describe-instances help

# Quick reference
aws <service> <command> --cli-input-json
aws <service> <command> --generate-cli-skeleton
```

### Community Resources
- [AWS CLI GitHub Repository](https://github.com/aws/aws-cli)
- [AWS Developer Forums](https://forums.aws.amazon.com/)
- [Stack Overflow AWS CLI Tag](https://stackoverflow.com/questions/tagged/aws-cli)
- [AWS re:Post](https://repost.aws/)

---

**📄 Generated by:** AWS CLI Quick Setup Script  
**🗓️ Last Updated:** September 2025  
**📋 Version:** 2.0