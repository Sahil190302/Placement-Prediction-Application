import pandas as pd

# Sample Data
data = {
    "Student_ID": [1, 2, 3, 4, 5],
    "CGPA": [8.5, 7.0, 6.0, 5.5, 9.0],
    "Backlogs": [0, 1, 2, 3, 0],
    "Programming_Score": [85, 75, 65, 55, 95],
    "Certifications": [3, 2, 1, 0, 4],
    "Internships": [2, 1, 0, 0, 3],
    "Soft_Skills": [7, 6, 5, 4, 9],
    "Projects": [4, 3, 2, 1, 6],
    "Resume_Score": [78, 70, 60, 50, 85],
    "GitHub_Activity": [10, 8, 5, 2, 15],
    "LinkedIn_Score": [80, 75, 65, 50, 90],
    "Work_Experience": [0, 0, 0, 0, 1],
    "Placed": [1, 1, 0, 0, 1],
}

# Convert to DataFrame
df = pd.DataFrame(data)

# Save as CSV
df.to_csv("placement_data.csv", index=False)

print("CSV file saved successfully!")
