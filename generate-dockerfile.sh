#!/bin/bash

LANGUAGE=$1

if [ "$LANGUAGE" == "node" ]; then
cat <<EOF > Dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["npm", "start"]
EOF

elif [ "$LANGUAGE" == "python" ]; then
cat <<EOF > Dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
EOF

elif [ "$LANGUAGE" == "java" ]; then
cat <<EOF > Dockerfile
FROM maven:3.8-openjdk-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM openjdk:17
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
EOF

else
echo "Unknown project type"
exit 1
fi
