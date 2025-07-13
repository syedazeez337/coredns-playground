#!/bin/bash

echo "🔧 Installing dependencies..."
apt update -y && apt install -y golang make dnsutils curl unzip

echo "📥 Cloning CoreDNS..."
git clone https://github.com/coredns/coredns.git
cd coredns || exit

echo "⚙️ Building CoreDNS..."
make

echo "📂 Copying Corefile and zone files..."
cp ../assets/Corefile .
cp ../assets/db.hello.dev .
cp ../assets/db.svc.cluster.local .

echo "✅ Setup complete. You can now run ./coredns -dns.port=1053"
