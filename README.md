# AWS CDK TypeScript Project

This repository contains AWS CDK (Cloud Development Kit) infrastructure code written in TypeScript.

## 🚀 Quick Start

### 1. Setup AWS CLI
Run the automated setup script to install and configure AWS CLI:

```bash
chmod +x setup-aws-cli.sh
./setup-aws-cli.sh
```

Or follow the manual instructions in [AWS-Setup-Commands.md](./AWS-Setup-Commands.md)

### 2. Install Dependencies
```bash
npm install
```

### 3. Bootstrap CDK (First Time Only)
```bash
cdk bootstrap
```

### 4. Deploy Infrastructure
```bash
# Synthesize CloudFormation template
cdk synth

# Deploy stack
cdk deploy

# Destroy stack (when needed)
cdk destroy
```

## 📁 Project Structure

```
├── setup-aws-cli.sh           # Automated AWS CLI setup script
├── AWS-Setup-Commands.md       # Comprehensive AWS CLI setup guide
├── bin/                        # CDK app entry points
├── lib/                        # CDK stack definitions
├── test/                       # Unit tests
├── cdk.json                    # CDK configuration
└── package.json                # Node.js dependencies
```

## 🛠️ Available Scripts

- `./setup-aws-cli.sh` - Install and configure AWS CLI
- `cdk list` - List all stacks
- `cdk synth` - Synthesize CloudFormation templates
- `cdk deploy` - Deploy infrastructure
- `cdk destroy` - Remove infrastructure
- `npm test` - Run unit tests

## 📚 Documentation

- [AWS CLI Setup Guide](./AWS-Setup-Commands.md) - Complete AWS CLI installation and configuration guide
- [AWS CDK Documentation](https://docs.aws.amazon.com/cdk/)
- [TypeScript CDK Reference](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib-readme.html)

## 🔒 Security Notes

- Never commit AWS credentials to version control
- Use IAM roles when possible
- Enable MFA for your AWS account
- Follow the principle of least privilege
- Regularly rotate access keys

## 🆘 Troubleshooting

If you encounter issues:

1. Check AWS CLI configuration: `aws configure list`
2. Verify credentials: `aws sts get-caller-identity`
3. Ensure CDK is bootstrapped: `cdk bootstrap`
4. See [AWS-Setup-Commands.md](./AWS-Setup-Commands.md) for detailed troubleshooting

## aws-cdk-typescript
AWS Configure
