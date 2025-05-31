#!/bin/bash

# Google Cloud Pub/Sub Message Pulling Script
# This script demonstrates different ways to pull messages from Pub/Sub subscriptions

set -e  # Exit on any error

echo "📥 Pulling Messages from Pub/Sub Subscriptions..."
echo "================================================="

# Check if mySubscription exists
if ! gcloud pubsub subscriptions describe mySubscription &>/dev/null; then
    echo "❌ Error: Subscription 'mySubscription' does not exist"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Function to create a separator
separator() {
    echo "----------------------------------------"
}

# Function to pull messages with description
pull_messages() {
    local subscription=$1
    local flags=$2
    local description=$3
    local max_attempts=$4
    
    echo "📥 $description"
    echo "Command: gcloud pubsub subscriptions pull $subscription $flags"
    separator
    
    local attempt=1
    while [ $attempt -le ${max_attempts:-1} ]; do
        echo "Attempt $attempt:"
        if gcloud pubsub subscriptions pull $subscription $flags 2>/dev/null; then
            echo "✅ Pull completed successfully"
        else
            echo "ℹ️  No messages available or pull completed"
        fi
        
        if [ $attempt -lt ${max_attempts:-1} ]; then
            echo ""
            sleep 2  # Wait between attempts
        fi
        
        ((attempt++))
    done
    
    separator
    echo ""
}

echo "🔹 Demonstration 1: Pull single message with auto-ack"
echo ""
pull_messages "mySubscription" "--auto-ack" "Pulling one message automatically acknowledged"

echo "🔹 Demonstration 2: Pull single message without auto-ack"
echo ""
echo "📥 Pulling one message without auto-acknowledgment"
echo "Command: gcloud pubsub subscriptions pull mySubscription"
separator
if gcloud pubsub subscriptions pull mySubscription --format="table(message.data,message.messageId,message.publishTime)" 2>/dev/null; then
    echo "✅ Message pulled (not acknowledged)"
    echo "ℹ️  Note: This message will be delivered again if not acknowledged"
else
    echo "ℹ️  No messages available"
fi
separator
echo ""

echo "🔹 Demonstration 3: Pull multiple messages at once"
echo ""
pull_messages "mySubscription" "--limit=3 --auto-ack" "Pulling up to 3 messages with auto-ack"

echo "🔹 Demonstration 4: Pull with custom format"
echo ""
echo "📥 Pulling messages with custom table format"
echo "Command: gcloud pubsub subscriptions pull mySubscription --limit=2 --auto-ack --format=table(...)"
separator
if gcloud pubsub subscriptions pull mySubscription --limit=2 --auto-ack \
    --format="table(message.data:label=MESSAGE,message.messageId:label=ID,message.publishTime:label=PUBLISHED)" 2>/dev/null; then
    echo "✅ Messages pulled with custom formatting"
else
    echo "ℹ️  No messages available"
fi
separator
echo ""

echo "🔹 Demonstration 5: Pull messages showing attributes"
echo ""
echo "📥 Pulling messages and displaying attributes"
echo "Command: gcloud pubsub subscriptions pull mySubscription --limit=2 --auto-ack --format=json"
separator
if gcloud pubsub subscriptions pull mySubscription --limit=2 --auto-ack --format=json 2>/dev/null | jq -r '.[] | "Message: " + .message.data + " | Attributes: " + (.message.attributes // {} | tostring)' 2>/dev/null; then
    echo "✅ Messages with attributes displayed"
elif gcloud pubsub subscriptions pull mySubscription --limit=2 --auto-ack 2>/dev/null; then
    echo "✅ Messages pulled (jq not available for attribute parsing)"
else
    echo "ℹ️  No messages available"
fi
separator
echo ""

echo "🔹 Demonstration 6: Continuous pulling simulation"
echo ""
echo "📥 Simulating continuous message pulling (3 attempts)"
pull_messages "mySubscription" "--auto-ack" "Continuous pulling simulation" 3

echo "🔹 Demonstration 7: Pull remaining messages"
echo ""
echo "📥 Pulling any remaining messages"
echo "Command: gcloud pubsub subscriptions pull mySubscription --limit=10 --auto-ack"
separator
if gcloud pubsub subscriptions pull mySubscription --limit=10 --auto-ack 2>/dev/null; then
    echo "✅ Remaining messages pulled"
else
    echo "ℹ️  No more messages available"
fi
separator
echo ""

echo "🔹 Demonstration 8: Verify no messages left"
echo ""
echo "📥 Checking if any messages remain"
echo "Command: gcloud pubsub subscriptions pull mySubscription --auto-ack"
separator
if gcloud pubsub subscriptions pull mySubscription --auto-ack 2>/dev/null; then
    echo "✅ Found additional messages"
else
    echo "ℹ️  No messages remaining - subscription is empty"
fi
separator
echo ""

echo "🎉 Message pulling demonstration completed!"
echo "==========================================="
echo "📊 Summary of demonstrations:"
echo "   1. ✅ Single message pull with auto-ack"
echo "   2. ✅ Single message pull without auto-ack"
echo "   3. ✅ Multiple messages pull (limit=3)"
echo "   4. ✅ Custom formatted output"
echo "   5. ✅ Messages with attributes"
echo "   6. ✅ Continuous pulling simulation"
echo "   7. ✅ Bulk remaining messages pull"
echo "   8. ✅ Verification of empty subscription"
echo ""
echo "🔧 Key Pull Command Flags:"
echo "   --auto-ack    : Automatically acknowledge messages"
echo "   --limit=N     : Pull maximum N messages"
echo "   --format=X    : Format output (table, json, yaml)"
echo ""
echo "💡 Important Notes:"
echo "   • Messages are removed from subscription after being pulled with --auto-ack"
echo "   • Without --auto-ack, messages will be redelivered"
echo "   • Use --limit to control batch size"
echo "   • Empty subscriptions return 'Listed 0 items'"
echo ""
echo "🚀 Next steps:"
echo "   1. Run ./publish_messages.sh again to add more messages"
echo "   2. Experiment with different pull commands"
echo "   3. Run ./cleanup.sh when finished to clean up resources"
