#!/bin/bash

LANGUAGE=$1

echo "Generating Dockerfile for: $LANGUAGE"

if [ "$LANGUAGE" == "node" ]; then
cat <<EOF > Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
EOF

elif [ "$LANGUAGE" == "python" ]; then
cat <<EOF > Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
CMD ["python", "app.py"]
EOF

elif [ "$LANGUAGE" == "java" ]; then
cat <<EOF > Dockerfile
# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
EOF

elif [ "$LANGUAGE" == "dotnet" ]; then
cat <<EOF > Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/out .
EXPOSE 80
ENTRYPOINT ["dotnet", "app.dll"]
EOF

else
echo "❌ Unknown project type"
exit 1
fi