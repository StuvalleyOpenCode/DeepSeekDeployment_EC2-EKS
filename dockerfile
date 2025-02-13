# First Stage: Build Dependencies
FROM python:3.10 AS builder

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y curl iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Debugging: Check network connectivity
RUN curl -Is https://ollama.com || echo "Ollama.com unreachable"

# Download and install Ollama
RUN curl -fsSL -o /tmp/install.sh https://ollama.com/install.sh \
    && chmod +x /tmp/install.sh && /tmp/install.sh \
    && rm /tmp/install.sh  # Clean up after installation

# Verify Ollama installation
RUN ollama --version || echo "Ollama installation failed"

# Copy dependencies file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Second Stage: Runtime Environment
FROM python:3.10-slim AS runtime

# Set working directory
WORKDIR /usr/src/app

# Install necessary system dependencies
RUN apt-get update && apt-get install -y curl iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Download and install Ollama in the final stage
RUN curl -fsSL -o /tmp/install.sh https://ollama.com/install.sh \
    && chmod +x /tmp/install.sh && /tmp/install.sh \
    && rm /tmp/install.sh

# Copy installed Python dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

# Expose Flask port
EXPOSE 5000

# Copy and set permissions for the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh  

# Use the startup script as the entrypoint
CMD ["/start.sh"]
