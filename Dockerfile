# Dockerfile

FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container
COPY . "/app"

# Run flutter doctor to ensure dependencies are installed
RUN flutter doctor

# Enable Flutter web
RUN flutter config --enable-web

# Install dependencies
RUN flutter pub get

# Build the Flutter web project
CMD ["flutter", "build", "web"]