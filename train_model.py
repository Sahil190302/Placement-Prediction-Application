import os
import pickle
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

# Define paths
BASE_DIR = r"D:\Placement_Prediction_Application"
MODEL_DIR = os.path.join(BASE_DIR, "models")
os.makedirs(MODEL_DIR, exist_ok=True)

MODEL_PATH = os.path.join(MODEL_DIR, "placement_model.pkl")
SCALER_PATH = os.path.join(MODEL_DIR, "scaler.pkl")

# Load dataset with error handling
try:
    data = pd.read_csv(os.path.join(BASE_DIR, "sample_dataset.csv"))
    print("✅ Dataset loaded successfully!")
except FileNotFoundError:
    print("❌ Error: sample_dataset.csv not found. Please ensure the file exists in the specified path.")
    exit()

# Ensure column names have no leading/trailing spaces
data.columns = data.columns.str.strip()

# Ensure all data is properly formatted
data = data.applymap(lambda x: str(x).strip() if isinstance(x, str) else x)  # Remove spaces
data = data.apply(pd.to_numeric, errors='coerce')  # Convert everything to numeric, set errors to NaN

# Check for NaN values after conversion
if data.isnull().sum().sum() > 0:
    print("⚠️ Warning: Non-numeric values detected, replacing them with mean values.")
    data.fillna(data.mean(), inplace=True)

# Split features and target
if "placement" not in data.columns:
    print("❌ Error: 'placement' column not found in the dataset.")
    exit()

X = data.drop(columns=["placement"], errors='ignore')
y = data["placement"]

# Split data into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scale the data
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train the model
print("🚀 Training RandomForest model...")
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

# Evaluate the model
y_pred = model.predict(X_test_scaled)
accuracy = accuracy_score(y_test, y_pred)
print(f"✅ Model Accuracy: {accuracy:.4f}")
print("Classification Report:\n", classification_report(y_test, y_pred))
print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))

# Save the model and scaler
try:
    with open(MODEL_PATH, "wb") as model_file:
        pickle.dump(model, model_file)

    with open(SCALER_PATH, "wb") as scaler_file:
        pickle.dump(scaler, scaler_file)

    print("✅ Model and scaler saved successfully!")
except Exception as e:
    print(f"❌ Error saving model or scaler: {e}")
