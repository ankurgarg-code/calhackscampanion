from flask import Flask, request, jsonify
from model_setup import get_answer  # Import the get_answer function from setup.py

# Initialize Flask app
app = Flask(__name__)

@app.route('/ask', methods=['POST'])
def ask_question():
    data = request.json
    question = data.get('question')

    if not question:
        return jsonify({"error": "Question is required"}), 400

    answer = get_answer(question)
    return jsonify({"answer": answer})

if __name__ == '__main__':
    app.run(debug=True)
