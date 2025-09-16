# AWS CDK TypeScript Setup Guide - Windows

A comprehensive guide to set up AWS CDK (Cloud Development Kit) with TypeScript on Windows systems.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Install AWS CLI](#install-aws-cli)
3. [Set up AWS credentials](#set-up-aws-credentials)
4. [Install AWS CDK](#install-aws-cdk)
5. [Bootstrap your CDK environment](#bootstrap-your-cdk-environment)
6. [Create a new CDK project](#create-a-new-cdk-project)
7. [Write and deploy your first stack](#write-and-deploy-your-first-stack)
8. [Environment management](#environment-management)
9. [Testing and cleanup](#testing-and-cleanup)

---

## 🔧 Prerequisites

### 1. System Requirements

- **Operating System**: Windows 10 or Windows 11
- **PowerShell**: Windows PowerShell 5.1 or PowerShell 7+
- **Internet Connection**: Required for downloading packages and deploying to AWS
- **Administrator Access**: Needed for some installations

### 2. Package Manager (Recommended)

Install Chocolatey for easier package management:

```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Verify installation
choco --version
```

### 3. Install Node.js and npm

#### Option 1: Using Chocolatey (Recommended)
```powershell
# Install Node.js LTS
choco install nodejs-lts -y

# Verify installation
node --version    # Should show v20.x.x or later
npm --version     # Should show 10.x.x or later
```

#### Option 2: Direct Download
1. Visit [nodejs.org](https://nodejs.org/)
2. Download the Windows Installer (.msi) for LTS version
3. Run the installer with default settings
4. Restart your command prompt

#### Option 3: Using winget (Windows 11)
```powershell
# Install Node.js
winget install OpenJS.NodeJS.LTS

# Verify installation
node --version
npm --version
```

### 4. Install TypeScript

```powershell
# Install TypeScript globally
npm install -g typescript

# Verify installation
tsc --version     # Should show version 5.x.x or later
```

### 5. Install Git

#### Using Chocolatey
```powershell
choco install git -y
```

#### Using winget
```powershell
winget install Git.Git
```

#### Manual Installation
1. Download from [git-scm.com](https://git-scm.com/download/win)
2. Run the installer with recommended settings

#### Configure Git
```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 6. Code Editor (Recommended)

#### Visual Studio Code
```powershell
# Using Chocolatey
choco install vscode -y

# Using winget
winget install Microsoft.VisualStudioCode
```

**Recommended VS Code Extensions:**
- AWS Toolkit
- TypeScript and JavaScript Language Features
- GitLens
- Prettier - Code formatter
- ESLint

---

## 🔑 Install AWS CLI

### Method 1: Using Windows Installer (Recommended)

```powershell
# Download and install AWS CLI v2
$url = "https://awscli.amazonaws.com/AWSCLIV2.msi"
$output = "$env:TEMP\AWSCLIV2.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -Wait -ArgumentList '/I', $output, '/quiet'
Remove-Item $output

# Restart PowerShell and verify
aws --version
```

### Method 2: Using Chocolatey

```powershell
choco install awscli -y

# Verify installation
aws --version
```

### Method 3: Using winget

```powershell
winget install Amazon.AWSCLI

# Verify installation
aws --version
```

---

## 🔐 Set up AWS credentials

### Method 1: Interactive Configuration (Recommended for Beginners)

```powershell
aws configure
```

You'll be prompted for:
- **AWS Access Key ID**: Your access key (starts with AKIA...)  
- **AWS Secret Access Key**: Your secret key
- **Default region**: e.g., `us-east-1`, `us-west-2`, `eu-west-1`
- **Default output format**: `json` (recommended)

### Method 2: Multiple Profiles

```powershell
# Configure development profile
aws configure --profile dev

# Configure production profile  
aws configure --profile prod

# Set environment variable for default profile
$env:AWS_PROFILE = "dev"

# Make it persistent (add to PowerShell profile)
Add-Content $PROFILE "`n`$env:AWS_PROFILE = 'dev'"
```

### Method 3: Environment Variables

```powershell
# Temporary (current session only)
$env:AWS_ACCESS_KEY_ID = "your-access-key-id"
$env:AWS_SECRET_ACCESS_KEY = "your-secret-access-key"  
$env:AWS_DEFAULT_REGION = "us-east-1"

# Persistent (add to system environment variables)
[Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", "your-access-key-id", "User")
[Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", "your-secret-access-key", "User")
[Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION", "us-east-1", "User")
```

### Verify Configuration

```powershell
# Check current configuration
aws configure list

# Test connectivity
aws sts get-caller-identity

# List S3 buckets (if you have permissions)
aws s3 ls
```

---

## 📦 Install AWS CDK

### Install CDK CLI

```powershell
# Install globally using npm
npm install -g aws-cdk

# Verify installation
cdk --version
# Should output: 2.100.x (build xxxxxxx)

# Check CDK doctor (diagnose common issues)
cdk doctor
```

---

## 🚀 Bootstrap your CDK environment

CDK bootstrapping creates the necessary AWS resources for CDK deployments.

```powershell
# Bootstrap default region/account
cdk bootstrap

# Bootstrap specific region
cdk bootstrap aws://123456789012/us-west-2

# Verify bootstrap
aws cloudformation describe-stacks --stack-name CDKToolkit
```

---

## 🏗️ Create a new CDK project  

### 1. Create Project Directory

```powershell
# Create and navigate to project directory
mkdir my-cdk-app
cd my-cdk-app
```

### 2. Initialize CDK Project

```powershell
# Initialize new TypeScript CDK project
cdk init app --language=typescript

# Install dependencies
npm install
```

### 3. Project Structure

After initialization:
```
my-cdk-app\
├── bin\
│   └── my-cdk-app.ts          # App entry point
├── lib\
│   └── my-cdk-app-stack.ts    # Stack definition
├── test\
│   └── my-cdk-app.test.ts     # Unit tests
├── cdk.json                   # CDK configuration
├── package.json               # Node.js dependencies
├── tsconfig.json              # TypeScript configuration
└── README.md                  # Project documentation
```

---

## 💻 Write and deploy your first stack

### 1. Update Stack Code

Replace content in `lib\my-cdk-app-stack.ts`:

```typescript
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';

export class MyCdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create an S3 bucket
    const bucket = new s3.Bucket(this, 'MyFirstBucket', {
      bucketName: `my-cdk-bucket-${cdk.Aws.ACCOUNT_ID}`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY, // For learning
      autoDeleteObjects: true, // For learning
    });

    // Create a Lambda function
    const lambdaFunction = new lambda.Function(this, 'MyLambdaFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromInline(`
        exports.handler = async (event) => {
          console.log('Event:', JSON.stringify(event, null, 2));
          return {
            statusCode: 200,
            body: JSON.stringify({
              message: 'Hello from Windows CDK Lambda!',
              timestamp: new Date().toISOString(),
            }),
          };
        };
      `),
      environment: {
        BUCKET_NAME: bucket.bucketName,
      },
    });

    // Grant Lambda permission to read/write to the bucket
    bucket.grantReadWrite(lambdaFunction);

    // Outputs
    new cdk.CfnOutput(this, 'BucketName', {
      value: bucket.bucketName,
      description: 'S3 Bucket Name',
    });

    new cdk.CfnOutput(this, 'LambdaFunctionName', {
      value: lambdaFunction.functionName,
      description: 'Lambda Function Name',
    });
  }
}
```

### 2. Build and Deploy

```powershell
# Build the project
npm run build

# Synthesize CloudFormation template
cdk synth

# Deploy the stack
cdk deploy

# Test Lambda function
aws lambda invoke --function-name YourLambdaFunctionName response.json
Get-Content response.json
```

---

## 🎯 Environment management

### Create environment configuration

Create `config\environments.ts`:

```typescript
export interface EnvironmentConfig {
  bucketName: string;
  lambdaMemory: number;
  enableLogging: boolean;
  tags: { [key: string]: string };
}

export const environments: { [key: string]: EnvironmentConfig } = {
  dev: {
    bucketName: 'my-app-dev',
    lambdaMemory: 128,
    enableLogging: true,
    tags: {
      Environment: 'Development',
      Platform: 'Windows',
    },
  },
  prod: {
    bucketName: 'my-app-prod', 
    lambdaMemory: 512,
    enableLogging: false,
    tags: {
      Environment: 'Production',
      Platform: 'Windows',
    },
  },
};
```

### Deploy to different environments

```powershell
# Deploy to development
cdk deploy --context environment=dev

# Deploy to production  
cdk deploy --context environment=prod
```

---

## 🧪 Testing and cleanup

### Run Tests

```powershell
# Run unit tests
npm test

# Run tests with coverage
npm run test -- --coverage
```

### Clean Up Resources

```powershell
# Destroy the stack
cdk destroy

# Destroy without confirmation
cdk destroy --force

# Clean up node modules and build artifacts
Remove-Item -Recurse -Force node_modules, cdk.out
```

---

## 🛠️ Windows-Specific Tips

### 1. PowerShell Execution Policy

If you encounter execution policy errors:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. Long Path Support

Enable long path support for npm:

```powershell
# Run as Administrator
npm config set cache C:\npm-cache --global
npm config set prefix C:\npm-global --global

# Add to PATH environment variable
$env:PATH += ";C:\npm-global"
```

### 3. Windows Defender

Add exclusions for:
- Node.js installation directory
- npm global directory  
- Your CDK project directories

### 4. Using Windows Terminal

Install Windows Terminal for better command-line experience:

```powershell
winget install Microsoft.WindowsTerminal
```

---

## 🚨 Troubleshooting

### Common Windows Issues

1. **PowerShell execution policy errors**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **npm permission errors**
   ```powershell
   # Configure npm to use different directory
   mkdir "$env:APPDATA\npm"
   npm config set prefix "$env:APPDATA\npm"
   ```

3. **Path too long errors**
   ```powershell
   # Enable long paths in Windows
   git config --system core.longpaths true
   ```

4. **CDK synthesis fails**
   ```powershell
   # Clear CDK cache
   Remove-Item -Recurse -Force cdk.out
   cdk synth
   ```

---

## 🎉 Next Steps

Now that you have CDK set up on Windows:

1. **Explore AWS services** - Add DynamoDB, API Gateway, etc.
2. **Set up CI/CD** - Use GitHub Actions or Azure DevOps
3. **Learn CDK patterns** - Custom constructs, aspects
4. **Security hardening** - IAM roles, VPC configurations

## 🔗 Resources

- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/)
- [CDK API Reference](https://docs.aws.amazon.com/cdk/api/v2/)
- [CDK Examples Repository](https://github.com/aws-samples/aws-cdk-examples)
- [Windows PowerShell Documentation](https://docs.microsoft.com/powershell/)

Happy building with AWS CDK on Windows! 🚀