# AWS CDK TypeScript Complete Setup Guide

A comprehensive guide to set up AWS CDK (Cloud Development Kit) with TypeScript from scratch. This guide covers everything from prerequisites to deploying your first stack.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Install AWS CLI](#install-aws-cli)
3. [Set up AWS credentials](#set-up-aws-credentials)
4. [Install AWS CDK](#install-aws-cdk)
5. [Bootstrap your CDK environment](#bootstrap-your-cdk-environment)
6. [Create a new CDK project](#create-a-new-cdk-project)
7. [Install necessary dependencies](#install-necessary-dependencies)
8. [Write your CDK stack](#write-your-cdk-stack)
9. [Deploy your CDK stack](#deploy-your-cdk-stack)
10. [How to parameterize your stack with multiple environments](#how-to-parameterize-your-stack-with-multiple-environments)
11. [How to add more resources to your stack](#how-to-add-more-resources-to-your-stack)
12. [How to test your CDK stack](#how-to-test-your-cdk-stack)
13. [Clean up resources](#clean-up-resources)

---

## 🔧 Prerequisites

Before starting with AWS CDK, ensure you have the following installed and configured:

### 1. System Requirements

- **Operating System**: Linux, macOS, or Windows
- **Terminal**: Command line interface with bash/zsh/PowerShell
- **Internet Connection**: Required for downloading packages and deploying to AWS

### 2. Node.js and npm

AWS CDK requires Node.js (version 14.15.0 or later). TypeScript applications work best with Node.js LTS versions.

#### Install Node.js (Ubuntu/Debian)
```bash
# Option 1: Using NodeSource repository (Recommended)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Option 2: Using snap
sudo snap install node --classic

# Option 3: Using package manager (may be older version)
sudo apt update
sudo apt install nodejs npm -y
```

#### Install Node.js (macOS)
```bash
# Using Homebrew (Recommended)
brew install node

# Or download from https://nodejs.org/
```

#### Install Node.js (Windows)
```powershell
# Using Chocolatey
choco install nodejs

# Or download from https://nodejs.org/
```

#### Verify Installation
```bash
node --version    # Should show v18.x.x or later
npm --version     # Should show 8.x.x or later
```

### 3. TypeScript

Install TypeScript globally for better development experience:

```bash
# Install TypeScript globally
npm install -g typescript

# Verify installation
tsc --version     # Should show version 4.x.x or later
```

### 4. Git (Optional but Recommended)

```bash
# Ubuntu/Debian
sudo apt install git -y

# macOS
brew install git

# Windows
# Download from https://git-scm.com/

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 5. Code Editor (Recommended)

- **VS Code** with TypeScript extensions
- **IntelliJ IDEA** or **WebStorm**
- Any editor with TypeScript support

---

## 🔑 Install AWS CLI

AWS CLI is required to interact with AWS services and configure credentials.

### Quick Installation (Automated)

If you're in this repository, use the provided script:

```bash
# Make script executable and run
chmod +x setup-aws-cli.sh
./setup-aws-cli.sh
```

### Manual Installation

#### Linux (Ubuntu/Debian)
```bash
# Download and install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install --update

# Clean up
rm -rf awscliv2.zip aws/
```

#### macOS
```bash
# Using Homebrew
brew install awscli

# Or download the installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### Verify Installation
```bash
aws --version
# Should output: aws-cli/2.x.x Python/3.x.x Linux/x.x.x source/x86_64.x
```

---

## 🔐 Set up AWS credentials

You need AWS credentials to deploy resources. There are several ways to configure them:

### Method 1: Interactive Configuration (Recommended for Beginners)

```bash
aws configure
```

You'll be prompted for:
- **AWS Access Key ID**: Your access key (starts with AKIA...)
- **AWS Secret Access Key**: Your secret key
- **Default region**: e.g., `us-east-1`, `us-west-2`, `eu-west-1`
- **Default output format**: `json` (recommended)

### Method 2: Multiple Profiles

For different environments (dev, staging, prod):

```bash
# Configure development profile
aws configure --profile dev

# Configure production profile  
aws configure --profile prod

# Use specific profile
export AWS_PROFILE=dev
```

### Method 3: Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Verify Configuration

```bash
# Check current configuration
aws configure list

# Test connectivity
aws sts get-caller-identity

# List S3 buckets (if you have permissions)
aws s3 ls
```

### 🔒 Security Best Practices

- **Never commit credentials to version control**
- **Use IAM roles when possible** (especially for EC2, Lambda)
- **Enable MFA** for your AWS account
- **Use least privilege principle** - only grant necessary permissions
- **Rotate access keys regularly**

---

## 📦 Install AWS CDK

The AWS CDK CLI is the command-line tool for working with CDK applications.

### Install CDK CLI

```bash
# Install globally using npm
npm install -g aws-cdk

# Verify installation
cdk --version
# Should output: 2.x.x (build xxxxxxx)
```

### Alternative Installation Methods

```bash
# Using yarn
yarn global add aws-cdk

# Using pip (Python)
pip install aws-cdk

# Using Homebrew (macOS)
brew install aws-cdk
```

### Verify CDK Installation

```bash
# Check CDK version
cdk --version

# List available CDK commands
cdk --help

# Check CDK doctor (diagnose common issues)
cdk doctor
```

---

## 🚀 Bootstrap your CDK environment

CDK bootstrapping creates the necessary AWS resources in your account to support CDK deployments.

### What is CDK Bootstrap?

Bootstrapping creates:
- **S3 bucket** for storing CDK assets (large Lambda functions, Docker images)
- **IAM roles** for CDK deployments
- **CloudFormation templates** for managing bootstrap resources

### Bootstrap Commands

```bash
# Bootstrap default region/account
cdk bootstrap

# Bootstrap specific region
cdk bootstrap aws://123456789012/us-west-2

# Bootstrap multiple regions
cdk bootstrap aws://123456789012/us-east-1 aws://123456789012/us-west-2

# Bootstrap with custom bucket name
cdk bootstrap --bootstrap-bucket-name my-cdk-assets-bucket
```

### Verify Bootstrap

```bash
# Check if environment is bootstrapped
aws cloudformation describe-stacks --stack-name CDKToolkit

# List bootstrap resources
aws s3 ls | grep cdk
```

### ⚠️ Important Notes

- **Run once per AWS account/region combination**
- **Requires administrative permissions** initially
- **Creates AWS resources** (small cost for S3 storage)
- **Safe to run multiple times** (idempotent operation)

---

## 🏗️ Create a new CDK project

Now let's create your first CDK TypeScript project.

### 1. Create Project Directory

```bash
# Create and navigate to project directory
mkdir my-cdk-app
cd my-cdk-app
```

### 2. Initialize CDK Project

```bash
# Initialize new TypeScript CDK project
cdk init app --language=typescript

# Alternative: Initialize with sample code
cdk init sample-app --language=typescript
```

### 3. Project Structure Overview

After initialization, you'll see:

```
my-cdk-app/
├── bin/
│   └── my-cdk-app.ts          # App entry point
├── lib/
│   └── my-cdk-app-stack.ts    # Stack definition
├── test/
│   └── my-cdk-app.test.ts     # Unit tests
├── cdk.json                   # CDK configuration
├── package.json               # Node.js dependencies
├── tsconfig.json              # TypeScript configuration
├── jest.config.js             # Testing configuration
└── README.md                  # Project documentation
```

### 4. Understand Key Files

#### `cdk.json` - CDK Configuration
```json
{
  "app": "npx ts-node --prefer-ts-exts bin/my-cdk-app.ts",
  "watch": {
    "include": ["**"],
    "exclude": ["README.md", "cdk*.json", "**/*.d.ts", "**/*.js", "tsconfig.json", "package*.json", "yarn.lock", "node_modules", "test"]
  },
  "context": {
    "@aws-cdk/aws-lambda:recognizeLayerVersion": true,
    "@aws-cdk/core:checkSecretUsage": true
  }
}
```

#### `package.json` - Dependencies
```json
{
  "name": "my-cdk-app",
  "version": "0.1.0",
  "bin": {
    "my-cdk-app": "bin/my-cdk-app.js"
  },
  "scripts": {
    "build": "tsc",
    "watch": "tsc -w",
    "test": "jest",
    "cdk": "cdk"
  },
  "devDependencies": {
    "@types/jest": "^29.4.0",
    "@types/node": "18.14.6",
    "jest": "^29.5.0",
    "ts-jest": "^29.0.5",
    "aws-cdk": "2.87.0",
    "ts-node": "^10.9.1",
    "typescript": "~4.9.5"
  },
  "dependencies": {
    "aws-cdk-lib": "2.87.0",
    "constructs": "^10.0.0"
  }
}
```

---

## 📋 Install necessary dependencies

The CDK project template includes basic dependencies, but you might need additional ones.

### 1. Install Base Dependencies

```bash
# Install all dependencies (already in package.json)
npm install

# Or using yarn
yarn install
```

### 2. Common Additional Dependencies

```bash
# AWS service-specific libraries (if needed)
npm install @aws-cdk/aws-lambda @aws-cdk/aws-apigateway @aws-cdk/aws-dynamodb

# Development dependencies
npm install --save-dev @types/aws-lambda eslint @typescript-eslint/eslint-plugin

# Utility libraries  
npm install dotenv aws-sdk
```

### 3. Update Dependencies

```bash
# Check for outdated packages
npm outdated

# Update CDK to latest version
npm update aws-cdk aws-cdk-lib

# Update all dependencies
npm update
```

### 4. Verify Installation

```bash
# Build the project
npm run build

# Run tests
npm test

# List available CDK commands for this project
npx cdk --help
```

---

## 💻 Write your CDK stack

Let's create a simple but practical CDK stack with common AWS resources.

### 1. Basic Stack Structure

Here's the default stack in `lib/my-cdk-app-stack.ts`:

```typescript
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class MyCdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Your resources will go here
  }
}
```

### 2. Add S3 Bucket Example

Replace the stack content with:

```typescript
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';
import { Construct } from 'constructs';

export class MyCdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create an S3 bucket
    const bucket = new s3.Bucket(this, 'MyFirstBucket', {
      bucketName: `my-cdk-bucket-${cdk.Aws.ACCOUNT_ID}-${cdk.Aws.REGION}`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY, // For learning - allows deletion
      autoDeleteObjects: true, // For learning - allows deletion
    });

    // Output the bucket name
    new cdk.CfnOutput(this, 'BucketName', {
      value: bucket.bucketName,
      description: 'Name of the S3 bucket',
    });

    // Output the bucket ARN
    new cdk.CfnOutput(this, 'BucketArn', {
      value: bucket.bucketArn,
      description: 'ARN of the S3 bucket',
    });
  }
}
```

### 3. More Complex Example with Lambda

```typescript
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as iam from 'aws-cdk-lib/aws-iam';
import { Construct } from 'constructs';

export class MyCdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3 Bucket
    const bucket = new s3.Bucket(this, 'MyFirstBucket', {
      bucketName: `my-cdk-bucket-${cdk.Aws.ACCOUNT_ID}`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
    });

    // Lambda Function
    const lambdaFunction = new lambda.Function(this, 'MyLambdaFunction', {
      runtime: lambda.Runtime.NODEJS_18_X,
      handler: 'index.handler',
      code: lambda.Code.fromInline(`
        exports.handler = async (event) => {
          console.log('Event:', JSON.stringify(event, null, 2));
          return {
            statusCode: 200,
            body: JSON.stringify({
              message: 'Hello from Lambda!',
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

### 4. Build and Validate

```bash
# Compile TypeScript
npm run build

# Validate CDK code
cdk synth

# Check for differences (if already deployed)
cdk diff
```

---

## 🚢 Deploy your CDK stack

Now let's deploy your CDK stack to AWS.

### 1. Pre-deployment Checks

```bash
# Ensure you're in the project directory
cd my-cdk-app

# Build the project
npm run build

# Synthesize CloudFormation template (generates cdk.out/)
cdk synth

# Check what will be deployed
cdk diff

# List available stacks
cdk list
```

### 2. Deploy the Stack

```bash
# Deploy with confirmation prompts
cdk deploy

# Deploy without confirmation (auto-approve)
cdk deploy --require-approval never

# Deploy with specific profile
cdk deploy --profile dev

# Deploy to specific region
cdk deploy --region us-west-2
```

### 3. Monitor Deployment

During deployment, you'll see:
- **CloudFormation events** in real-time
- **Resource creation progress**
- **Output values** when deployment completes

Example output:
```
MyCdkAppStack: deploying...
MyCdkAppStack: creating CloudFormation changeset...
 ✅  MyCdkAppStack

✨  Deployment time: 45.67s

Outputs:
MyCdkAppStack.BucketName = my-cdk-bucket-123456789012
MyCdkAppStack.LambdaFunctionName = MyCdkAppStack-MyLambdaFunction12345678

Stack ARN:
arn:aws:cloudformation:us-east-1:123456789012:stack/MyCdkAppStack/12345678-1234-1234-1234-123456789012
```

### 4. Verify Deployment

```bash
# Check stack status
aws cloudformation describe-stacks --stack-name MyCdkAppStack

# List stack resources
aws cloudformation list-stack-resources --stack-name MyCdkAppStack

# Test Lambda function (if created)
aws lambda invoke --function-name MyCdkAppStack-MyLambdaFunction12345678 response.json
cat response.json
```

---

## 🎯 How to parameterize your stack with multiple environments

Learn to deploy the same stack to different environments (dev, staging, prod).

### 1. Environment-Specific Configuration

Create `config/environments.ts`:

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
      Team: 'DevTeam',
    },
  },
  staging: {
    bucketName: 'my-app-staging',
    lambdaMemory: 256,
    enableLogging: true,
    tags: {
      Environment: 'Staging',
      Team: 'DevTeam',
    },
  },
  prod: {
    bucketName: 'my-app-prod',
    lambdaMemory: 512,
    enableLogging: false,
    tags: {
      Environment: 'Production',
      Team: 'DevTeam',
    },
  },
};
```

### 2. Update Stack to Use Configuration

Modify `lib/my-cdk-app-stack.ts`:

```typescript
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';
import { EnvironmentConfig } from '../config/environments';

interface MyCdkAppStackProps extends cdk.StackProps {
  config: EnvironmentConfig;
}

export class MyCdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: MyCdkAppStackProps) {
    super(scope, id, props);

    const { config } = props;

    // S3 Bucket with environment-specific settings
    const bucket = new s3.Bucket(this, 'MyBucket', {
      bucketName: `${config.bucketName}-${cdk.Aws.ACCOUNT_ID}`,
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // Lambda with environment-specific memory
    const lambdaFunction = new lambda.Function(this, 'MyLambda', {
      runtime: lambda.Runtime.NODEJS_18_X,
      handler: 'index.handler',
      memorySize: config.lambdaMemory,
      code: lambda.Code.fromInline(`
        exports.handler = async (event) => {
          return {
            statusCode: 200,
            body: JSON.stringify({
              message: 'Hello from ${id}!',
              environment: '${id}',
            }),
          };
        };
      `),
      environment: {
        BUCKET_NAME: bucket.bucketName,
        LOG_LEVEL: config.enableLogging ? 'DEBUG' : 'ERROR',
      },
    });

    // Apply tags
    Object.entries(config.tags).forEach(([key, value]) => {
      cdk.Tags.of(this).add(key, value);
    });

    bucket.grantReadWrite(lambdaFunction);
  }
}
```

### 3. Update App Entry Point

Modify `bin/my-cdk-app.ts`:

```typescript
#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { MyCdkAppStack } from '../lib/my-cdk-app-stack';
import { environments } from '../config/environments';

const app = new cdk.App();

// Get environment from context or default to 'dev'
const envName = app.node.tryGetContext('environment') || 'dev';
const config = environments[envName];

if (!config) {
  throw new Error(`Unknown environment: ${envName}`);
}

new MyCdkAppStack(app, `MyCdkApp-${envName}`, {
  config,
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
});
```

### 4. Deploy to Different Environments

```bash
# Deploy to development
cdk deploy --context environment=dev

# Deploy to staging
cdk deploy --context environment=staging

# Deploy to production
cdk deploy --context environment=prod

# List all stacks
cdk list --context environment=dev
```

---

## ➕ How to add more resources to your stack

Let's expand your stack with additional AWS services.

### 1. Add DynamoDB Table

```typescript
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';

// Add to your stack constructor
const table = new dynamodb.Table(this, 'MyTable', {
  tableName: `my-table-${envName}`,
  partitionKey: {
    name: 'id',
    type: dynamodb.AttributeType.STRING,
  },
  billingMode: dynamodb.BillingMode.PAY_PER_REQUEST,
  removalPolicy: cdk.RemovalPolicy.DESTROY,
});

// Grant Lambda permissions
table.grantReadWriteData(lambdaFunction);

// Add table name to Lambda environment
lambdaFunction.addEnvironment('TABLE_NAME', table.tableName);
```

### 2. Add API Gateway

```typescript
import * as apigateway from 'aws-cdk-lib/aws-apigateway';

// Add REST API
const api = new apigateway.RestApi(this, 'MyApi', {
  restApiName: `my-api-${envName}`,
  description: 'My CDK API',
  defaultCorsPreflightOptions: {
    allowOrigins: apigateway.Cors.ALL_ORIGINS,
    allowMethods: apigateway.Cors.ALL_METHODS,
  },
});

// Add Lambda integration
const lambdaIntegration = new apigateway.LambdaIntegration(lambdaFunction);

// Add API endpoints
api.root.addMethod('GET', lambdaIntegration);
const itemsResource = api.root.addResource('items');
itemsResource.addMethod('GET', lambdaIntegration);
itemsResource.addMethod('POST', lambdaIntegration);

// Output API URL
new cdk.CfnOutput(this, 'ApiUrl', {
  value: api.url,
  description: 'API Gateway URL',
});
```

### 3. Add CloudWatch Alarms

```typescript
import * as cloudwatch from 'aws-cdk-lib/aws-cloudwatch';
import * as sns from 'aws-cdk-lib/aws-sns';

// SNS Topic for alerts
const alertTopic = new sns.Topic(this, 'AlertTopic', {
  displayName: 'My App Alerts',
});

// Lambda Error Alarm
new cloudwatch.Alarm(this, 'LambdaErrorAlarm', {
  metric: lambdaFunction.metricErrors(),
  threshold: 1,
  evaluationPeriods: 2,
  alarmDescription: 'Lambda function errors',
});

// API Gateway Alarm
new cloudwatch.Alarm(this, 'ApiErrorAlarm', {
  metric: api.metricServerError(),
  threshold: 5,
  evaluationPeriods: 2,
  alarmDescription: 'API Gateway server errors',
});
```

---

## 🧪 How to test your CDK stack

Implement proper testing for your CDK infrastructure.

### 1. Unit Tests

Update `test/my-cdk-app.test.ts`:

```typescript
import * as cdk from 'aws-cdk-lib';
import { Template } from 'aws-cdk-lib/assertions';
import { MyCdkAppStack } from '../lib/my-cdk-app-stack';
import { environments } from '../config/environments';

describe('MyCdkAppStack', () => {
  test('creates S3 bucket', () => {
    const app = new cdk.App();
    const stack = new MyCdkAppStack(app, 'TestStack', {
      config: environments.dev,
    });

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::S3::Bucket', {
      VersioningConfiguration: {
        Status: 'Enabled',
      },
    });
  });

  test('creates Lambda function', () => {
    const app = new cdk.App();
    const stack = new MyCdkAppStack(app, 'TestStack', {
      config: environments.dev,
    });

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::Lambda::Function', {
      Runtime: 'nodejs18.x',
      Handler: 'index.handler',
    });
  });

  test('Lambda has correct memory for prod', () => {
    const app = new cdk.App();
    const stack = new MyCdkAppStack(app, 'TestStack', {
      config: environments.prod,
    });

    const template = Template.fromStack(stack);

    template.hasResourceProperties('AWS::Lambda::Function', {
      MemorySize: 512,
    });
  });
});
```

### 2. Run Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test -- --watch

# Run tests with coverage
npm run test -- --coverage

# Run specific test file
npm run test -- my-cdk-app.test.ts
```

### 3. Integration Testing

Create `test/integration.test.ts`:

```typescript
import { execSync } from 'child_process';

describe('Integration Tests', () => {
  test('CDK synthesizes without errors', () => {
    expect(() => {
      execSync('cdk synth --context environment=dev', { stdio: 'pipe' });
    }).not.toThrow();
  });

  test('CDK diff works', () => {
    expect(() => {
      execSync('cdk diff --context environment=dev', { stdio: 'pipe' });
    }).not.toThrow();
  });
});
```

---

## 🧹 Clean up resources

Important: Always clean up resources to avoid unnecessary AWS charges.

### 1. Destroy Individual Stack

```bash
# Destroy specific environment
cdk destroy --context environment=dev

# Destroy without confirmation
cdk destroy --context environment=dev --force

# Destroy all stacks
cdk destroy --all
```

### 2. Manual Cleanup (if needed)

```bash
# List CloudFormation stacks
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE

# Delete stack manually
aws cloudformation delete-stack --stack-name MyCdkApp-dev

# Empty S3 buckets (if deployment fails)
aws s3 rm s3://my-bucket-name --recursive
aws s3 rb s3://my-bucket-name
```

### 3. Cleanup Scripts

Create `scripts/cleanup.sh`:

```bash
#!/bin/bash

echo "Cleaning up CDK resources..."

# Destroy all environments
for env in dev staging prod; do
  echo "Destroying $env environment..."
  cdk destroy --context environment=$env --force
done

# Clean up CDK bootstrap (optional - be careful!)
# aws cloudformation delete-stack --stack-name CDKToolkit

echo "Cleanup complete!"
```

### 4. Cost Monitoring

```bash
# Check current month costs
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost

# Set up billing alerts (optional)
aws budgets create-budget \
  --account-id 123456789012 \
  --budget file://budget.json
```

---

## 🎉 Congratulations!

You've successfully set up AWS CDK with TypeScript and learned:

- ✅ **Complete environment setup** from prerequisites to deployment
- ✅ **CDK project structure** and best practices
- ✅ **Multi-environment configuration** for dev/staging/prod
- ✅ **Adding multiple AWS resources** to your stack
- ✅ **Testing infrastructure code** with unit tests
- ✅ **Proper resource cleanup** to avoid charges

## 📚 Next Steps

1. **Explore more AWS services** - RDS, ECS, API Gateway, etc.
2. **Learn CDK Patterns** - Common architectural patterns
3. **Implement CI/CD** - GitHub Actions or AWS CodePipeline
4. **Security best practices** - IAM roles, encryption, VPC
5. **Advanced CDK features** - Custom constructs, aspects, feature flags

## 🔗 Useful Resources

- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/)
- [CDK API Reference](https://docs.aws.amazon.com/cdk/api/v2/)
- [CDK Examples](https://github.com/aws-samples/aws-cdk-examples)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [CDK Workshop](https://cdkworkshop.com/)

Happy building with AWS CDK! 🚀