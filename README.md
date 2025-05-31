# Pub Sub - Command Line

This repository contains a comprehensive guide and scripts for working with Google Cloud Pub/Sub from the command line. This project demonstrates the fundamentals of Pub/Sub messaging service including creating topics, managing subscriptions, publishing messages, and pulling messages.

## Video

https://youtu.be/dD5Mx-V2dWo

## Overview

Pub/Sub is a messaging service for exchanging event data among applications and services. By decoupling senders and receivers, it allows for secure and highly available communication between independently written applications. Pub/Sub delivers low-latency/durable messaging, and is commonly used by developers in implementing asynchronous workflows, distributing event notifications, and streaming data from various processes or devices.

## What you'll learn

- Create, delete, and list Pub/Sub topics and subscriptions
- Publish messages to a topic
- How to use a pull subscriber
- Best practices for Pub/Sub messaging

## Prerequisites

- Google Cloud Platform account
- Google Cloud SDK (gcloud) installed and configured
- Basic understanding of command line operations
- Access to Google Cloud Shell (recommended)

## Setup and Requirements

### Authentication
Make sure you're authenticated with Google Cloud:
```bash
gcloud auth list
gcloud config list project
```

### Enable Pub/Sub API
If not already enabled, enable the Pub/Sub API:
```bash
gcloud services enable pubsub.googleapis.com
```

## Pub/Sub Basics

There are three key terms in Pub/Sub:
- **Topic**: A shared string that allows applications to connect with one another through a common thread
- **Publisher**: Pushes (or publishes) a message to a Cloud Pub/Sub topic
- **Subscriber**: Makes a "subscription" to a topic to receive messages via pull or push

## Tutorial Steps

### 1. Working with Topics

#### Create Topics
```bash
# Create a main topic
gcloud pubsub topics create myTopic

# Create additional test topics
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2
```

#### List Topics
```bash
gcloud pubsub topics list
```

#### Delete Topics
```bash
gcloud pubsub topics delete Test1
gcloud pubsub topics delete Test2
```

### 2. Working with Subscriptions

#### Create Subscriptions
```bash
# Create main subscription
gcloud pubsub subscriptions create --topic myTopic mySubscription

# Create additional test subscriptions
gcloud pubsub subscriptions create --topic myTopic Test1
gcloud pubsub subscriptions create --topic myTopic Test2
```

#### List Subscriptions
```bash
gcloud pubsub topics list-subscriptions myTopic
```

#### Delete Subscriptions
```bash
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2
```

### 3. Publishing Messages

#### Publish Single Messages
```bash
# Basic message
gcloud pubsub topics publish myTopic --message "Hello"

# Custom messages (replace placeholders with your information)
gcloud pubsub topics publish myTopic --message "Publisher's name is YOUR_NAME"
gcloud pubsub topics publish myTopic --message "Publisher likes to eat YOUR_FOOD"
gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"
```

### 4. Pulling Messages

#### Pull Single Message
```bash
gcloud pubsub subscriptions pull mySubscription --auto-ack
```

#### Pull Multiple Messages
```bash
# Pull up to 3 messages at once
gcloud pubsub subscriptions pull mySubscription --limit=3
```

#### Pull All Available Messages
```bash
# Pull without limit (use with caution)
gcloud pubsub subscriptions pull mySubscription --auto-ack --limit=100
```

## Important Notes

- **Message Consumption**: Using the pull command without flags outputs only one message at a time
- **Message Acknowledgment**: Once a message is pulled and acknowledged, it cannot be accessed again from that subscription
- **Auto-ack Flag**: The `--auto-ack` flag automatically acknowledges messages after pulling them
- **Limit Flag**: Use `--limit` to specify the maximum number of messages to pull in one request

## Scripts Included

This repository includes the following helper scripts:

- `setup.sh`: Sets up the initial Pub/Sub environment
- `publish_messages.sh`: Publishes sample messages to topics
- `pull_messages.sh`: Demonstrates different ways to pull messages
- `cleanup.sh`: Cleans up all created resources

## Usage Examples

### Quick Start
```bash
# Clone this repository
git clone https://github.com/yourusername/pubsub-cli-tutorial.git
cd pubsub-cli-tutorial

# Make scripts executable
chmod +x *.sh

# Run the complete tutorial
./setup.sh
./publish_messages.sh
./pull_messages.sh
./cleanup.sh
```

### Manual Step-by-Step
Follow the commands in the tutorial sections above, or use the individual scripts for specific operations.

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure you have the necessary IAM permissions for Pub/Sub
2. **Project Not Set**: Make sure your gcloud project is properly configured
3. **API Not Enabled**: Verify that the Pub/Sub API is enabled for your project

### Useful Commands
```bash
# Check current project
gcloud config get-value project

# List all topics in project
gcloud pubsub topics list

# List all subscriptions in project
gcloud pubsub subscriptions list
```

## Best Practices

1. **Naming Conventions**: Use descriptive names for topics and subscriptions
2. **Message Acknowledgment**: Always handle message acknowledgment properly
3. **Error Handling**: Implement proper error handling in production applications
4. **Resource Cleanup**: Clean up unused topics and subscriptions to avoid charges
5. **Security**: Use IAM roles to control access to Pub/Sub resources

## Next Steps

After completing this tutorial, consider exploring:
- Pub/Sub with different programming languages (Python, Java, Go)
- Push subscriptions and webhooks
- Dead letter queues
- Message ordering and filtering
- Integration with other Google Cloud services

## Resources

- [Google Cloud Pub/Sub Documentation](https://cloud.google.com/pubsub/docs)
- [gcloud pubsub Command Reference](https://cloud.google.com/sdk/gcloud/reference/pubsub)
- [Pub/Sub Best Practices](https://cloud.google.com/pubsub/docs/publisher)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.
