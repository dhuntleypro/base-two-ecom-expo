#!/bin/bash

# Install project dependencies
echo "Installing dependencies..."
npm install

# Install Expo CLI globally if not installed
if ! command -v expo &> /dev/null
then
    echo "Expo CLI not found, installing..."
    npm install -g expo-cli
fi

# Load environment variables from .env
if [ -f .env ]; then
  echo "Loading environment variables from .env"
  set -o allexport
  source <(grep -v '^#' .env | xargs)
  set +o allexport
else
  echo ".env file not found! Make sure the environment variables are set correctly."
  exit 1
fi

# Expo login using environment variables or passed arguments
if [ -z "$EXPO_USERNAME" ] || [ -z "$EXPO_PASSWORD" ]; then
  echo "Expo login credentials missing! Set EXPO_USERNAME and EXPO_PASSWORD in the .env file."
  exit 1
fi

echo "Logging into Expo..."
expo login --username "$EXPO_USERNAME" --password "$EXPO_PASSWORD"

# Check if GitHub CLI is installed; if not, install it
if [ -z "$CI" ]; then
  # Check if GitHub CLI is installed; if not, install it
  if ! command -v gh &> /dev/null
  then
      echo "GitHub CLI (gh) not found, installing..."
      if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
      elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install gh
      else
        echo "Unsupported OS for automatic GitHub CLI installation."
        exit 1
      fi
  fi
else
  echo "Skipping GitHub CLI installation in CI environment..."
fi


# GitHub CLI Authentication (Make sure you have the GIT_TOKEN environment variable)
if [ -z "$GIT_TOKEN" ]; then
  echo "GIT_TOKEN is missing! Set it in the .env file."
  exit 1
fi

echo "Authenticating GitHub CLI..."
echo "$GIT_TOKEN" | gh auth login --with-token

# Set secrets using GitHub CLI
echo "Setting GitHub secrets..."
gh secret set FASTLANE_USER -b "$FASTLANE_USER" -R "$GITHUB_REPOSITORY"
gh secret set FASTLANE_PASSWORD -b "$FASTLANE_PASSWORD" -R "$GITHUB_REPOSITORY"
gh secret set MATCH_GIT_TOKEN -b "$MATCH_GIT_TOKEN" -R "$GITHUB_REPOSITORY"

echo "Project setup completed successfully!"
