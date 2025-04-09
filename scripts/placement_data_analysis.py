import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# Load Dataset
df = pd.read_csv("placement_data.csv")

# Display first few rows
print("Dataset Preview:\n", df.head())
print("\nDataset Info:")
df.info()

# Check for missing values
print("\nMissing Values:\n", df.isnull().sum())

# Summary statistics
print("\nStatistical Summary:\n", df.describe())

# Correlation Matrix
plt.figure(figsize=(10, 6))
sns.heatmap(df.corr(), annot=True, cmap="coolwarm", fmt='.2f')
plt.title("Feature Correlation Matrix")
plt.show()

# Visualizing Distribution of Features
features = ["CGPA", "Backlogs", "Programming_Score", "Certifications", "Internships", "Resume_Score", "LinkedIn_Score", "Placed"]
plt.figure(figsize=(12, 8))
for i, feature in enumerate(features, 1):
    plt.subplot(3, 3, i)
    sns.histplot(df[feature], bins=20, kde=True, color='blue')
    plt.title(f"Distribution of {feature}")
plt.tight_layout()
plt.show()

# Placement Outcome Analysis
plt.figure(figsize=(8, 4))
sns.countplot(x=df["Placed"], palette="viridis")
plt.title("Placement Count (0 = Not Placed, 1 = Placed)")
plt.xlabel("Placement Outcome")
plt.ylabel("Count")
plt.show()

# Boxplots for feature comparison
plt.figure(figsize=(12, 6))
sns.boxplot(x=df["Placed"], y=df["CGPA"], palette="Set2")
plt.title("CGPA vs Placement Outcome")
plt.show()

# Standardizing Data for ML Models
scaler = StandardScaler()
df_scaled = pd.DataFrame(scaler.fit_transform(df.drop(columns=["Student_ID", "Placed"])), columns=df.columns[1:-1])
df_scaled["Placed"] = df["Placed"]

# Save the cleaned and scaled dataset
df_scaled.to_csv("processed_placement_data.csv", index=False)
print("Processed dataset saved successfully!")
