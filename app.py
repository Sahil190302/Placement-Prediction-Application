import pickle
from flask import Flask, request, jsonify, send_from_directory
import numpy as np
from flask_cors import CORS
import os
from datetime import datetime
from fpdf import FPDF

app = Flask(__name__)
CORS(app)

# Paths
BASE_DIR = r"D:\Placement_Prediction_Application\models"
MODEL_PATH = os.path.join(BASE_DIR, "placement_model.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")
REPORT_DIR = os.path.join(BASE_DIR, "reports")
os.makedirs(REPORT_DIR, exist_ok=True)

# Load model and scaler
try:
    with open(MODEL_PATH, "rb") as model_file:
        model = pickle.load(model_file)
    with open(SCALER_PATH, "rb") as scaler_file:
        scaler = pickle.load(scaler_file)
    print("✅ Model and Scaler loaded successfully!")
except FileNotFoundError:
    print(f"❌ ERROR: Model or scaler not found in {BASE_DIR}.")
    model = None
    scaler = None

def generate_pdf_report(features, prediction, probability, suggestions):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"placement_report_{timestamp}.pdf"
    filepath = os.path.join(REPORT_DIR, filename)

    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)

    pdf.cell(200, 10, txt="Placement Prediction Report", ln=True, align="C")
    pdf.cell(200, 10, txt=f"Timestamp: {timestamp}", ln=True)
    pdf.ln(5)

    labels = [
        "CGPA", "Projects", "Internships", "Certifications",
        "Aptitude", "Soft Skills", "Technical Test", "Programming Questions"
    ]
    pdf.cell(200, 10, txt="Input Features:", ln=True)
    for label, value in zip(labels, features):
        pdf.cell(200, 10, txt=f"- {label}: {value}", ln=True)

    result = "Placed" if prediction == 1 else "Not Placed"
    pdf.ln(5)
    pdf.cell(200, 10, txt=f"Prediction: {result} ({probability:.2f}% confidence)", ln=True)

    if suggestions:
        pdf.ln(5)
        pdf.cell(200, 10, txt="Suggestions:", ln=True)
        for line in suggestions.strip().split("\n"):
            pdf.cell(200, 10, txt=f"- {line.strip()}", ln=True)

    pdf.output(filepath)
    return filename

@app.route('/predict', methods=['POST'])
def predict():
    if not model or not scaler:
        return jsonify({"error": "Model or scaler not loaded"}), 500

    try:
        data = request.json
        features = data.get("features", [])

        if not isinstance(features, list) or len(features) not in [7, 8]:
            return jsonify({"error": "'features' should be a list of 7 or 8 numerical values"}), 400

        try:
            features = [float(x) for x in features]
        except ValueError:
            return jsonify({"error": "All feature values should be numbers"}), 400

        if len(features) == 7:
            features.append(0.0)  # default Programming Questions

        features_np = np.array(features).reshape(1, -1)
        features_scaled = scaler.transform(features_np)
        prediction = int(model.predict(features_scaled)[0])
        probability = float(model.predict_proba(features_scaled)[0][prediction]) * 100

        # Basic suggestions
        suggestions = ""
        if prediction == 0:
            suggestions = "Work on projects, certifications, or improve soft skills."
        else:
            if features[4] < 80:
                suggestions += "Improve aptitude score.\n"
            if features[6] < 80:
                suggestions += "Enhance technical test performance."

        pdf_file = generate_pdf_report(features, prediction, probability, suggestions)

        return jsonify({
            "placement_prediction": prediction,
            "probability": round(probability / 100, 4),
            "pdf_report_url": f"/reports/{pdf_file}"
        })

    except Exception as e:
        print(f"❌ Error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/reports/<filename>', methods=['GET'])
def download_pdf(filename):
    return send_from_directory(REPORT_DIR, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
