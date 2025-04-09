import pandas as pd
from sklearn.preprocessing import StandardScaler
import joblib

# Step 1: Load your dataset
data = pd.read_csv('D:/Placement_Prediction_Application/dataset/processed_placement_data.csv')

# Step 2: Select columns to scale
columns_to_scale = [
    'CGPA', 'Backlogs', 'Programming_Score', 'Certifications', 
    'Internships', 'Soft_Skills', 'Projects', 'Resume_Score', 
    'GitHub_Activity', 'LinkedIn_Score', 'Work_Experience'
]

# Step 3: Create a scaler
scaler = StandardScaler()

# Step 4: Fit the scaler on the data
X = data[columns_to_scale]
scaler.fit(X)

# Step 5: Save the scaler to a file
joblib.dump(scaler, 'D:/Placement_Prediction_Application/models/scaler.pkl')

print("Scaler saved as scaler.pkl")
