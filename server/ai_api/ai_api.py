from flask import Flask, request, jsonify, send_file
from roboflow import Roboflow
import matplotlib
matplotlib.use('Agg')  # Use a non-interactive backend
import matplotlib.pyplot as plt
from PIL import Image
import cv2
import io
import os

app = Flask(__name__)

# Initialize the model
rf = Roboflow(api_key="aM8lfTby2MelLeXjGDLl")
project = rf.workspace("kmutt-ajmwi").project("se_mongta")
model = project.version(2).model

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    # Load image from the request
    image_file = request.files['image']
    image_path = "temp.jpg"
    image_file.save(image_path)

    try:
        # Perform inference
        predictions = model.predict(image_path, confidence=40, overlap=30).json()

        # Open image using OpenCV
        image = cv2.imread(image_path)
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

        # Check if predictions are empty
        if not predictions['predictions']:
            # Define the approximate bounding box for the eyes
            height, width, _ = image.shape
            eye_x1, eye_y1 = int(width * 0.3), int(height * 0.4)
            eye_x2, eye_y2 = int(width * 0.7), int(height * 0.6)

            # Create an overlay with "Normal" text and rectangle around the eyes
            plt.figure(figsize=(10, 10))
            plt.imshow(image)

            # Draw rectangle around the eyes
            plt.gca().add_patch(
                plt.Rectangle((eye_x1, eye_y1), eye_x2 - eye_x1, eye_y2 - eye_y1, 
                              linewidth=2, edgecolor='blue', facecolor='none')
            )

            # Add "Normal" text near the rectangle
            plt.text(
                eye_x1, eye_y1 - 20, "Normal", fontsize=20, color='blue', 
                bbox=dict(facecolor='white', edgecolor='blue', boxstyle='round,pad=0.5')
            )

            plt.axis('off')

            # Save the output image
            output_path = "output.jpg"
            plt.savefig(output_path, bbox_inches='tight', pad_inches=0)
            plt.close()

            # Send the output image back to the client
            with open(output_path, "rb") as f:
                img_bytes = io.BytesIO(f.read())

            return send_file(img_bytes, mimetype='image/jpeg')


        # Plot the image with bounding boxes
        plt.figure(figsize=(10, 10))
        plt.imshow(image)

        for prediction in predictions['predictions']:
            x = prediction['x']
            y = prediction['y']
            width = prediction['width']
            height = prediction['height']
            confidence = prediction['confidence']
            label = prediction['class']

            # Calculate the rectangle's coordinates
            x1 = x - width / 2
            y1 = y - height / 2
            x2 = x + width / 2
            y2 = y + height / 2

            # Draw rectangle
            plt.gca().add_patch(
                plt.Rectangle((x1, y1), width, height, linewidth=2, edgecolor='red', facecolor='none')
            )
            # Add label and confidence
            plt.text(
                x1,
                y1 - 10,
                f"{label} ({confidence:.2f})",
                color='red',
                fontsize=12,
                bbox=dict(facecolor='yellow', alpha=0.5),
            )

        plt.axis('off')

        # Save the output image
        output_path = "output.jpg"
        plt.savefig(output_path, bbox_inches='tight', pad_inches=0)
        plt.close()

        # Send the output image back to the client
        with open(output_path, "rb") as f:
            img_bytes = io.BytesIO(f.read())

        return send_file(img_bytes, mimetype='image/jpeg')

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        # Clean up temporary files
        if os.path.exists(image_path):
            os.remove(image_path)
        if os.path.exists("output.jpg"):
            os.remove("output.jpg")

if __name__ == '__main__':
    app.run(debug=True)
