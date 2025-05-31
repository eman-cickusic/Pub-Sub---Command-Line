#!/bin/bash

# Google Cloud Pub/Sub Setup Script
# This script sets up the initial Pub/Sub environment for the tutorial

set -e  # Exit on any error

echo "🚀 Setting up Google Cloud Pub/Sub Environment..."
echo "=================================================="

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI is not installed or not in PATH"
    echo "Please install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
echo "📋 Checking authentication..."
if ! gcloud auth list --filter=status=ACTIVE --format="value(account)" | head -n1 > /dev/null; then
    echo "❌ Error: No active gcloud authentication found"
    echo "Please run: gcloud auth login"
    exit 1
fi

# Get current project
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo "❌ Error: No project is set"
    echo "Please run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "✅ Project ID: $PROJECT_ID"

# Enable Pub/Sub API
echo "🔧 Enabling Pub/Sub API..."
gcloud services enable pubsub.googleapis.com --quiet

# Create main topic
echo "📝 Creating main topic: myTopic..."
if gcloud pubsub topics create myTopic --quiet; then
    echo "✅ Topic 'myTopic' created successfully"
else
    echo "ℹ️  Topic 'myTopic' may already exist"
fi

# Create main subscription
echo "📬 Creating main subscription: mySubscription..."
if gcloud pubsub subscriptions create --topic myTopic mySubscription --quiet; then
    echo "✅ Subscription 'mySubscription' created successfully"
else
    echo "ℹ️  Subscription 'mySubscription' may already exist"
fi

# Create test topics for demonstration
echo "📝 Creating test topics..."
for topic in Test1 Test2; do
    if gcloud pubsub topics create $topic --quiet 2>/dev/null; then
        echo "✅ Topic '$topic' created"
    else
        echo "ℹ️  Topic '$topic' may already exist"
    fi
done

# Create test subscriptions
echo "📬 Creating test subscriptions..."
for sub in Test1 Test2; do
    if gcloud pubsub subscriptions create --topic myTopic $sub --quiet 2>/dev/null; then
        echo "✅ Subscription '$sub' created"
    else
        echo "ℹ️  Subscription '$sub' may already exist"
    fi
done

echo ""
echo "🎉 Setup completed successfully!"
echo "=================================================="
echo "📊 Current Pub/Sub Resources:"
echo ""
echo "Topics:"
gcloud pubsub topics list --format="table(name.scope(topics):label=TOPIC_NAME)"
echo ""
echo "Subscriptions for myTopic:"
gcloud pubsub topics list-subscriptions myTopic --format="table(name.scope(subscriptions):label=SUBSCRIPTION_NAME)"
echo ""
echo "🚀 You're ready to start publishing and pulling messages!"
echo "   Next steps:"
echo "   1. Run ./publish_messages.sh to publish sample messages"
echo "   2. Run ./pull_messages.sh to pull and view messages"
echo "   3. Run ./cleanup.sh when you're done to clean up resources"
