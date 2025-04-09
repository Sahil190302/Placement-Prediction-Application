from sklearn.preprocessing import StandardScaler
import pandas as pd

# Assuming you have your dataset loaded
data = pd.read_csv('D:/Placement_Prediction_Application/dataset/processed_placement_data.csv')

# Columns to scale
columns_to_scale = [
    'CGPA', 'Backlogs', 'Programming_Score', 'Certifications', 
    'Internships', 'Soft_Skills', 'Projects', 'Resume_Score', 
    'GitHub_Activity', 'LinkedIn_Score', 'Work_Experience'
]

# Create the scaler and fit it on your data
scaler = StandardScaler()
X = data[columns_to_scale]
scaler.fit(X)

# Save the scaler to a file
import joblib
joblib.dump(scaler, 'D:/Placement_Prediction_Application/models/scaler.pkl')
