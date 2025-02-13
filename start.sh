#!/bin/bash

# Start Ollama in the background
ollama serve &  
echo "Waiting for Ollama to start..."
sleep 10  # Increase sleep time if needed

# Pull the model (retry if it fails)
echo "Pulling DeepSeek model..."
until ollama pull deepseek-r1:1.5b; do
    echo "Retrying in 5 seconds..."
    sleep 10
done

# Start Flask app
echo "Starting Flask app..."
export FLASK_APP=flask-backend/app.py
flask run --host=0.0.0.0 --port=5000