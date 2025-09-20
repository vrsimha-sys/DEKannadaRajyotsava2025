# Multi-stage Docker build for Flutter Web
FROM ubuntu:20.04 as build

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    libgconf-2-4 \
    gdb \
    libstdc++6 \
    libglu1-mesa \
    fonts-droid-fallback \
    lib32stdc++6 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter doctor
RUN flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Build Flutter web app
WORKDIR /app/flutter_web
RUN flutter pub get
RUN flutter build web --release --web-renderer html

# Production stage
FROM nginx:alpine

# Copy built web files to nginx
COPY --from=build /app/flutter_web/build/web /usr/share/nginx/html

# Copy nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]