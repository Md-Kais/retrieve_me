from flask import Flask, jsonify, request
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from flask_cors import CORS  # Import CORS

app = Flask(__name__)
CORS(app)
model = SentenceTransformer('paraphrase-MiniLM-L6-v2')

@app.route('/calculate_similarity', methods=['POST'])
def calculate_similarity():
    data = request.get_json()
    found_item_image_url = data['found_item_image_url']
    lost_items_data = data['lost_items_data']

    similarity_scores = []
    found_item_embedding = model.encode([found_item_image_url])[0]

    for item_data in lost_items_data:
        lost_item_image_url = item_data['lost_item_image_url']
        lost_item_embedding = model.encode([lost_item_image_url])[0]

        # Perform image similarity calculation using sentence_transformers
        # Append the similarity score to the list
        similarity_score = cosine_similarity([found_item_embedding], [lost_item_embedding])[0][0]
        print(similarity_score)

        similarity_score = float(similarity_score)

        similarity_scores.append({'similarity_score': pow(similarity_score, len(item_data)), 'itemName': item_data['lost_item_name'], 'itemImageURL': item_data['lost_item_image_url'] })

    return jsonify(similarity_scores)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')