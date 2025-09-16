sudo apt update
sudo apt install awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo ./aws/install
aws --version
rm -rf awscliv2.zip aws/
grep -n "aws\|/usr/local/bin" ~/.bashrc
echo '# AWS CLI Configuration' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
echo 'alias awscli="aws"' >> ~/.bashrc
echo 'complete -C "/usr/local/bin/aws_completer" aws' >> ~/.bashrc
ls -la ~/.bash_profile
cat << 'EOF' > ~/.bash_profile
# Load .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# AWS CLI Configuration
export PATH=$PATH:/usr/local/bin
EOF