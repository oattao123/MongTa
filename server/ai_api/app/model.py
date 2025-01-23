from roboflow import Roboflow
import cv2
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend for server-side rendering

# Initialize the model
rf = Roboflow(api_key="aM8lfTby2MelLeXjGDLl")
project = rf.workspace("kmutt-ajmwi").project("se_mongta")
model = project.version(2).model

def perform_prediction(image_path):
    predictions = model.predict(image_path, confidence=40, overlap=30).json()

    # Open image using OpenCV
    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    # Check if predictions are empty
    if not predictions['predictions']:
        # Define default rectangle for "Normal"
        height, width, _ = image.shape
        eye_x1, eye_y1 = int(width * 0.3), int(height * 0.4)
        eye_x2, eye_y2 = int(width * 0.7), int(height * 0.6)
        output_path = draw_default_eyes(image, eye_x1, eye_y1, eye_x2, eye_y2)
    else:
        output_path = draw_predictions(image, predictions)
    
    return output_path

def draw_default_eyes(image, eye_x1, eye_y1, eye_x2, eye_y2):
    plt.figure(figsize=(10, 10))
    plt.imshow(image)
    plt.gca().add_patch(
        plt.Rectangle((eye_x1, eye_y1), eye_x2 - eye_x1, eye_y2 - eye_y1, 
                      linewidth=2, edgecolor='blue', facecolor='none')
    )
    plt.text(eye_x1, eye_y1 - 20, "Normal", fontsize=20, color='blue', 
             bbox=dict(facecolor='white', edgecolor='blue', boxstyle='round,pad=0.5'))
    plt.axis('off')

    # Save the image without white space
    output_path = "default_eyes_output.jpg"
    plt.savefig(output_path, format='jpg', bbox_inches='tight', pad_inches=0)
    plt.close()  # Close the plot to avoid memory leaks
    return output_path

def draw_predictions(image, predictions):
    plt.figure(figsize=(10, 10))
    plt.imshow(image)

    for prediction in predictions['predictions']:
        x, y, width, height, confidence, label = prediction['x'], prediction['y'], prediction['width'], prediction['height'], prediction['confidence'], prediction['class']
        x1, y1 = x - width / 2, y - height / 2
        x2, y2 = x + width / 2, y + height / 2

        plt.gca().add_patch(
            plt.Rectangle((x1, y1), width, height, linewidth=2, edgecolor='red', facecolor='none')
        )
        plt.text(x1, y1 - 10, f"{label} ({confidence:.2f})", color='red', fontsize=12,
                 bbox=dict(facecolor='yellow', alpha=0.5))

    plt.axis('off')

    # Save the image without white space
    output_path = "predictions_output.jpg"
    plt.savefig(output_path, format='jpg', bbox_inches='tight', pad_inches=0)
    plt.close()  # Close the plot to avoid memory leaks
    return output_path
