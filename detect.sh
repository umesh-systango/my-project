#!/bin/bash

if [ -f "package.json" ]; then
  echo "node"
elif [ -f "requirements.txt" ]; then
  echo "python"
elif [ -f "pom.xml" ]; then
  echo "java"
elif [ -f "*.csproj" ]; then
  echo "dotnet"
else
  echo "unknown"
fi
