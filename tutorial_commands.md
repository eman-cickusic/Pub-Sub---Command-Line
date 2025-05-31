# Pub/Sub Tutorial Commands Reference

This document contains all the commands used in the Google Cloud Pub/Sub tutorial, organized by section for easy reference.

## Prerequisites Commands

### Authentication and Project Setup
```bash
# Check authentication
gcloud auth list

# Check current project
gcloud config list project

# Set project (if needed)
gcloud config set project YOUR_PROJECT_ID

# Enable Pub/Sub API
gcloud services enable pubsub.googleapis.com
```

## Task 1: Pub/Sub Topics

### Create Topics
```bash
# Create main topic
gcloud pubsub topics create myTopic

# Create test topics
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2
```

### List Topics
```bash
# List all topics
gcloud pubsub topics list
```

### Delete Topics
```bash
# Delete test topics
gcloud pubsub topics delete Test1
gcloud pubsub topics delete Test2
```

## Task 2: Pub/Sub Subscriptions

### Create Subscriptions
```bash
# Create main subscription
gcloud pubsub subscriptions create --topic myTopic mySubscription

# Create test subscriptions
gcloud pubsub subscriptions create --topic myTopic Test1
gcloud pubsub subscriptions create --topic myTopic Test2
```

### List Subscriptions
```bash
# List subscriptions for a specific topic
gcloud pubsub topics list-subscriptions myTopic

# List all subscriptions in project
gcloud pubsub subscriptions list
```

### Delete Subscriptions
```bash
# Delete test subscriptions
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2
```

## Task 3: Publishing Messages

### Basic Message Publishing
```bash
# Publish simple message
gcloud pubsub topics publish myTopic --message "Hello"

# Publish personalized messages
gcloud pubsub topics publish myTopic --message "Publisher's name is YOUR_NAME"
gcloud pubsub topics publish myTopic --message "Publisher likes to eat YOUR_FOOD"
gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"
```

### Advanced Message Publishing
```bash
# Publish message with attributes
gcloud pubsub topics publish myTopic \
  --message "Message with attributes" \
  --attribute "key1=value1,key2=value2"

# Publish JSON message
gcloud pubsub topics publish myTopic \
  --message '{"user":"john","action":"login","timestamp":"2024-01-01T12:00:00Z"}'
```

## Task 4: Pulling Messages

### Basic Message Pulling
```bash
# Pull single message with auto-acknowledgment
gcloud pubsub subscriptions pull mySubscription --auto-ack

# Pull single message without auto-acknowledgment
gcloud pubsub subscriptions pull mySubscription
```

### Advanced Message Pulling
```bash
# Pull multiple messages
gcloud pubsub subscriptions pull mySubscription --limit=3

# Pull multiple messages with auto-ack
gcloud pubsub subscriptions pull mySubscription --limit=3 --auto-ack

# Pull messages with custom format
gcloud pubsub subscriptions pull mySubscription --auto-ack \
  --format="table(message.data:label=MESSAGE,message.messageId:label=ID)"

# Pull messages in JSON format
gcloud pubsub subscriptions pull mySubscription --auto-ack --format=json
```

## Management Commands

### Topic Management
```bash
# Describe a topic
gcloud pubsub topics describe myTopic

# Get topic IAM policy
gcloud pubsub topics get-iam-policy myTopic

# Set topic IAM policy
gcloud pubsub topics set-iam-policy myTopic policy.json
```

### Subscription Management
```bash
# Describe a subscription
gcloud pubsub subscriptions describe mySubscription

# Get subscription IAM policy
gcloud pubsub subscriptions get-iam-policy mySubscription

# Set subscription IAM policy
gcloud pubsub subscriptions set-iam-policy mySubscription policy.json

# Modify subscription settings
gcloud pubsub subscriptions modify-ack-deadline mySubscription --ack-deadline=60

# Update subscription
gcloud pubsub subscriptions update mySubscription --push-endpoint=https://example.com/push
```

### Monitoring and Troubleshooting
```bash
# Check subscription details
gcloud pubsub subscriptions describe mySubscription

# Check topic details
gcloud pubsub topics describe myTopic

# List all resources
gcloud pubsub topics list
gcloud pubsub subscriptions list

# Check message count (approximate)
gcloud pubsub subscriptions describe mySubscription --format="value(messageRetentionDuration)"
```

## Batch Operations

### Batch Topic Operations
```bash
# Create multiple topics
for topic in topic1 topic2 topic3; do
  gcloud pubsub topics create $topic
done

# Delete multiple topics
for topic in topic1 topic2 topic3; do
  gcloud pubsub topics delete $topic
done
```

### Batch Subscription Operations
```bash
# Create multiple subscriptions for one topic
for sub in sub1 sub2 sub3; do
  gcloud pubsub subscriptions create --topic myTopic $sub
done

# Delete multiple subscriptions
for sub in sub1 sub2 sub3; do
  gcloud pubsub subscriptions delete $sub
done
```

### Batch Message Publishing
```bash
# Publish multiple messages in sequence
for i in {1..10}; do
  gcloud pubsub topics publish myTopic --message "Message number $i"
done

# Publish messages with different attributes
gcloud pubsub topics publish myTopic --message "High priority" --attribute "priority=high"
gcloud pubsub topics publish myTopic --message "Normal priority" --attribute "priority=normal"
gcloud pubsub topics publish myTopic --message "Low priority" --attribute "priority=low"
```

## Useful Flags and Options

### Common Flags
- `--quiet`: Suppress interactive prompts
- `--format`: Specify output format (json, yaml, table, csv)
- `--filter`: Filter results based on criteria
- `--limit`: Limit number of results
- `--sort-by`: Sort results by specified field

### Publishing Flags
- `--message`: Message content
- `--attribute`: Message attributes (key=value pairs)
- `--ordering-key`: Message ordering key

### Pulling Flags
- `--auto-ack`: Automatically acknowledge messages
- `--limit`: Maximum number of messages to pull
- `--max-messages`: Alias for --limit

### Format Examples
```bash
# Table format with custom columns
--format="table(message.data:label=MESSAGE,message.publishTime:label=PUBLISHED)"

# JSON format
--format="json"

# YAML format  
--format="yaml"

# CSV format
--format="csv(message.data,message.messageId)"

# Value format (for scripting)
--format="value(message.data)"
```

## Error Handling and Debugging

### Common Error Commands
```bash
# Check if topic exists
gcloud pubsub topics describe myTopic >/dev/null 2>&1 && echo "exists" || echo "not found"

# Check if subscription exists
gcloud pubsub subscriptions describe mySubscription >/dev/null 2>&1 && echo "exists" || echo "not found"

# Verbose output for debugging
gcloud pubsub topics create myTopic --verbosity=debug

# Check quotas and limits
gcloud compute project-info describe --format="yaml(quotas)"
```

### Cleanup Commands
```bash
# Delete all test resources
gcloud pubsub subscriptions delete mySubscription Test1 Test2
gcloud pubsub topics delete myTopic Test1 Test2

# Force delete (skip confirmation)
gcloud pubsub topics delete myTopic --quiet
```

## Advanced Use Cases

### Dead Letter Topics
```bash
# Create dead letter topic
gcloud pubsub topics create myTopic-deadletter

# Create subscription with dead letter policy
gcloud pubsub subscriptions create mySubscription \
  --topic=myTopic \
  --dead-letter-topic=myTopic-deadletter \
  --max-delivery-attempts=5
```

### Message Filtering
```bash
# Create subscription with filter
gcloud pubsub subscriptions create filtered-sub \
  --topic=myTopic \
  --message-filter='attributes.priority="high"'
```

### Push Subscriptions
```bash
# Create push subscription
gcloud pubsub subscriptions create push-sub \
  --topic=myTopic \
  --push-endpoint=https://example.com/webhook
```

### Exactly-Once Delivery
```bash
# Create subscription with exactly-once delivery
gcloud pubsub subscriptions create exactly-once-sub \
  --topic=myTopic \
  --enable-exactly-once-delivery
```

## Performance and Monitoring

### Performance Testing
```bash
# Publish messages in parallel (using background processes)
for i in {1..100}; do
  gcloud pubsub topics publish myTopic --message "Message $i" &
done
wait  # Wait for all background processes to complete

# Pull messages with high throughput
gcloud pubsub subscriptions pull mySubscription --limit=1000 --auto-ack
```

### Monitoring Commands
```bash
# Get subscription metrics
gcloud pubsub subscriptions describe mySubscription \
  --format="yaml(name,messageRetentionDuration,ackDeadlineSeconds)"

# Check topic configuration
gcloud pubsub topics describe myTopic \
  --format="yaml(name,messageStoragePolicy,schemaSettings)"
```

This reference guide covers all the essential commands for working with Google Cloud Pub/Sub from the command line. Use it as a quick reference while working through the tutorial or building your own Pub/Sub applications.