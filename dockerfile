FROM maven:3.9.9-eclipse-temurin-17

WORKDIR /app

# Install Google Chrome dependencies

RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    ca-certificates \
    fonts-liberation \
    libglib2.0-0 \
    libnss3 \
    libfontconfig1 \
    libgbm1 \
    libasound2 \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
       | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Copy Maven project

COPY pom.xml .

COPY testng.xml .

COPY src ./src

# Chrome configuration

ENV CHROME_BIN=/usr/bin/google-chrome

# Execute Selenium TestNG tests

CMD ["mvn", "clean", "test", "-Dheadless=true"]