#!/bin/bash

# Google Cloud Pub/Sub Message Publishing Script
# This script demonstrates different ways to publish messages to Pub/Sub topics

set -e  # Exit on any error

echo "📤 Publishing Messages to Pub/Sub Topics..."
echo "============================================="

# Check if myTopic exists
if ! gcloud pubsub topics describe myTopic &>/dev/null; then
    echo "❌ Error: Topic 'myTopic' does not exist"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Function to publish a message with status feedback
publish_message() {
    local topic=$1
    local message=$2
    local description=$3
    
    echo "📤 $description"
    if gcloud pubsub topics publish $topic --message "$message" --quiet; then
        echo "✅ Message published: \"$message\""
    else
        echo "❌ Failed to publish message"
        return 1
    fi
    echo ""
}

# Basic messages
echo "🔹 Publishing basic messages..."
echo ""

publish_message "myTopic" "Hello" "Publishing greeting message"
publish_message "myTopic" "Welcome to Pub/Sub tutorial!" "Publishing welcome message"
publish_message "myTopic" "This is a test message" "Publishing test message"

# Personalized messages (you can customize these)
echo "🔹 Publishing personalized messages..."
echo ""

# Get user input for personalization (optional)
if [ -t 0 ]; then  # Check if running interactively
    read -p "Enter your name (or press Enter to use 'Developer'): " USER_NAME
    read -p "Enter your favorite food (or press Enter to use 'Pizza'): " FAVORITE_FOOD
fi

# Set defaults if not provided
USER_NAME=${USER_NAME:-"Developer"}
FAVORITE_FOOD=${FAVORITE_FOOD:-"Pizza"}

publish_message "myTopic" "Publisher's name is $USER_NAME" "Publishing name message"
publish_message "myTopic" "Publisher likes to eat $FAVORITE_FOOD" "Publishing food preference"
publish_message "myTopic" "Publisher thinks Pub/Sub is awesome" "Publishing opinion message"

# Technical messages
echo "🔹 Publishing technical messages..."
echo ""

publish_message "myTopic" "Message with timestamp: $(date)" "Publishing timestamped message"
publish_message "myTopic" "Publisher is starting to get the hang of Pub/Sub" "Publishing progress message"
publish_message "myTopic" "Publisher wonders if all messages will be pulled" "Publishing question message"
publish_message "myTopic" "Publisher will have to test to find out" "Publishing test message"

# JSON formatted message
echo "🔹 Publishing JSON formatted message..."
echo ""

JSON_MESSAGE='{"user":"'$USER_NAME'","action":"completed_tutorial","timestamp":"'$(date -Iseconds)'","status":"success"}'
publish_message "myTopic" "$JSON_MESSAGE" "Publishing JSON message"

# Messages with attributes (demonstration)
echo "🔹 Publishing message with attributes..."
echo ""

echo "📤 Publishing message with custom attributes..."
if gcloud pubsub topics publish myTopic \
    --message "Message with attributes" \
    --attribute "source=tutorial,type=demo,priority=normal" \
    --quiet; then
    echo "✅ Message with attributes published successfully"
else
    echo "❌ Failed to publish message with attributes"
fi
echo ""

# Batch publishing simulation
echo "🔹 Publishing batch of messages..."
echo ""

for i in {1..5}; do
    publish_message "myTopic" "Batch message #$i" "Publishing batch message $i/5"
    sleep 0.5  # Small delay between messages
done

echo "🎉 Message publishing completed!"
echo "================================"
echo "📊 Summary:"
echo "   • Published multiple types of messages"
echo "   • Included personalized content"
echo "   • Demonstrated JSON formatting"
echo "   • Showed attribute usage"
echo "   • Created batch messages"
echo ""
echo "🚀 Next steps:"
echo "   1. Run ./pull_messages.sh to retrieve and view these messages"
echo "   2. Check the Google Cloud Console to see message metrics"
echo "   3. Experiment with different message formats"
echo ""
echo "💡 Tip: Messages are now queued in the topic and waiting for subscribers!"
