from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/prompt', methods=['POST'])
def handle_prompt():
    # Parse JSON input
    data = request.get_json()
    prompt = data.get('prompt')
    print(prompt)

    if not prompt:
        return jsonify({"error": "Prompt is required"}), 400

    try:
        # Execute the ollama command
        result = subprocess.run(
            ['ollama', 'run', 'deepseek-r1:1.5b'],
            input=prompt,
            text=True,
            capture_output=True
        )

        # Check for errors in the subprocess call
        if result.returncode != 0:
            return jsonify({"error": result.stderr.strip()}), 500

        # Return the response from the subprocess
        return jsonify({"response": result.stdout.strip()}), 200
    except Exception as e:
        # Catch and return any unexpected errors
        return jsonify({"error": str(e)}), 500
    
@app.route('/prompt2', methods=['POST'])
def handle_prompt2():
    # Parse JSON input
    data = request.get_json()
    prompt = data.get('prompt')

    # Validate the presence of the 'prompt' key
    if not prompt:
        return jsonify({"error": "Prompt is required"}), 400

    # Return a static response
    static_response = {
        "response": "This is a static response to your prompt."
    }
    return jsonify(static_response), 200


# if __name__ == '__main__':
    # app.run(debug=True, port=5000)  # Flask will run on port 5000

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)  # Change host to 0.0.0.0

