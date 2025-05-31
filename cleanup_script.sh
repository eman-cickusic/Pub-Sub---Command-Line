#!/bin/bash

# Google Cloud Pub/Sub Cleanup Script
# This script removes all resources created during the tutorial

set -e  # Exit on any error

echo "🧹 Cleaning up Google Cloud Pub/Sub Resources..."
echo "================================================"

# Function to delete resource with error handling
delete_resource() {
    local resource_type=$1
    local resource_name=$2
    local delete_command=$3
    
    echo "🗑️  Deleting $resource_type: $resource_name"
    if eval $delete_command &>/dev/null; then
        echo "✅ $resource_type '$resource_name' deleted successfully"
    else
        echo "ℹ️  $resource_type '$resource_name' may not exist or already deleted"
    fi
}

# Confirmation prompt
echo "⚠️  WARNING: This will delete all Pub/Sub resources created in this tutorial!"
echo ""
echo "Resources that will be deleted:"
echo "📬 Subscriptions: mySubscription, Test1, Test2"
echo "📝 Topics: myTopic, Test1, Test2"
echo ""

# Ask for confirmation unless in non-interactive mode
if [ -t 0 ] && [ "${FORCE_CLEANUP:-}" != "true" ]; then
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cleanup cancelled"
        exit 0
    fi
fi

echo ""
echo "🧹 Starting cleanup process..."
echo ""

# Delete subscriptions first (subscriptions must be deleted before topics)
echo "🔹 Step 1: Deleting subscriptions..."
echo ""

SUBSCRIPTIONS=("mySubscription" "Test1" "Test2")
for sub in "${SUBSCRIPTIONS[@]}"; do
    delete_resource "subscription" "$sub" "gcloud pubsub subscriptions delete $sub --quiet"
done

echo ""
echo "🔹 Step 2: Deleting topics..."
echo ""

TOPICS=("myTopic" "Test1" "Test2")
for topic in "${TOPICS[@]}"; do
    delete_resource "topic" "$topic" "gcloud pubsub topics delete $topic --quiet"
done

echo ""
echo "🔹 Step 3: Verification - Checking remaining resources..."
echo ""

echo "📊 Remaining topics in project:"
if gcloud pubsub topics list --format="value(name)" 2>/dev/null | grep -E "(myTopic|Test1|Test2)" >/dev/null; then
    echo "⚠️  Some tutorial topics still exist:"
    gcloud pubsub topics list --filter="name:(myTopic OR Test1 OR Test2)" --format="table(name.scope(topics):label=TOPIC_NAME)"
else
    echo "✅ No tutorial topics found - cleanup successful"
fi

echo ""
echo "📊 Remaining subscriptions in project:"
if gcloud pubsub subscriptions list --format="value(name)" 2>/dev/null | grep -E "(mySubscription|Test1|Test2)" >/dev/null; then
    echo "⚠️  Some tutorial subscriptions still exist:"
    gcloud pubsub subscriptions list --filter="name:(mySubscription OR Test1 OR Test2)" --format="table(name.scope(subscriptions):label=SUBSCRIPTION_NAME)"
else
    echo "✅ No tutorial subscriptions found - cleanup successful"
fi

echo ""
echo "🎉 Cleanup completed!"
echo "===================="
echo "📋 Summary:"
echo "   • Deleted all tutorial subscriptions"
echo "   • Deleted all tutorial topics"
echo "   • Verified resource removal"
echo ""
echo "💡 Note: Other Pub/Sub resources in your project were not affected"
echo ""
echo "🚀 What's next?"
echo "   • Run ./setup.sh to start the tutorial again"
echo "   • Explore the Google Cloud Console Pub/Sub section"
echo "   • Try creating your own topics and subscriptions"
echo "   • Check out the Pub/Sub documentation for advanced features"
echo ""
echo "📚 Additional Resources:"
echo "   • Pub/Sub Best Practices: https://cloud.google.com/pubsub/docs/publisher"
echo "   • Pub/Sub Pricing: https://cloud.google.com/pubsub/pricing"  
echo "   • Pub/Sub Client Libraries: https://cloud.google.com/pubsub/docs/reference/libraries"

# Optional: Show current billing estimate
if command -v gcloud >/dev/null 2>&1; then
    echo ""
    echo "💰 Billing Impact:"
    echo "   • Pub/Sub has a generous free tier"
    echo "   • Deleted topics and subscriptions stop incurring charges immediately"
    echo "   • Check your billing dashboard for current usage"
fi

echo ""
echo "✨ Thank you for completing the Pub/Sub tutorial!"
