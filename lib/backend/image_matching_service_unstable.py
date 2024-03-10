import urllib.request
import io
import torch
from flask import Flask, jsonify, request
from torchvision import transforms
from torchvision.models import resnet18
from PIL import Image

app = Flask(__name__)
model = resnet18(pretrained=True)
model.eval()

def preprocess_image(image_url):
    transform = transforms.Compose([
        transforms.ToTensor(),
        # transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    response = urllib.request.urlopen(image_url)
    image_file = io.BytesIO(response.read())
    img = Image.open(image_file)
    print('----image opened---')
    img_tensor = transform(img)
    img_tensor = img_tensor.unsqueeze(0)  # Add batch dimension
    print('----image tensor-----')
    return img_tensor

@app.route('/calculate_similarity', methods=['POST'])
def calculate_similarity():
    data = request.get_json()
    found_item_image_url = data['found_item_image_url']
    lost_items_data = data['lost_items_data']

    similarity_scores = []
    found_item_embedding = model(preprocess_image(found_item_image_url))

    for item_data in lost_items_data:
        lost_item_image_url = item_data['lost_item_image_url']
        lost_item_embedding = model(preprocess_image(lost_item_image_url))
        print('---{0}---'.format(lost_item_image_url))

        # Calculate Euclidean distance for similarity
        similarity_score = torch.linalg.norm(found_item_embedding - lost_item_embedding)
        print(similarity_score)
        similarity_score = float(similarity_score)
        print('---similarity score ---')

        similarity_scores.append({
            'similarity_score': similarity_score,
            'itemName': item_data['lost_item_name'],
            'itemImageURL': item_data['lost_item_image_url']
        })
        print(item_data['lost_item_name'])

    return jsonify(similarity_scores)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
