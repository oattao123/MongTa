import io
from flask import request, jsonify, send_file
from model import perform_prediction
from utils import clean_up_temp_files

def setup_routes(app):
    @app.route('/predict', methods=['POST'])
    def predict():
        if 'image' not in request.files:
            return jsonify({"error": "No image file provided"}), 400

        image_file = request.files['image']
        image_path = "temp.jpg"
        image_file.save(image_path)

        try:
            output_image_path = perform_prediction(image_path)

            with open(output_image_path, "rb") as f:
                img_bytes = io.BytesIO(f.read())
            
            return send_file(img_bytes, mimetype='image/jpeg')
        
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        
        finally:
            # Clean up temporary files
            clean_up_temp_files(image_path, output_image_path)
