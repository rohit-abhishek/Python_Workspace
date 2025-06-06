import csv
import random

from sklearn import svm
from sklearn.linear_model import Perceptron
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier

model = Perceptron()
# model = svm.SVC()
# model = KNeighborsClassifier(n_neighbors=1)
# model = GaussianNB()

models = {
    "Perceptron": Perceptron(), 
    "SVC" : svm.SVC(),
    "K Neighbor with 1": KNeighborsClassifier(n_neighbors=1),
    "K Neighbor with 5": KNeighborsClassifier(n_neighbors=5),
    "GaussianNB" : GaussianNB()
}

# Read data in from file
with open("banknotes.csv") as f:
    reader = csv.reader(f)
    next(reader)

    data = []
    for row in reader:
        data.append({
            "evidence": [float(cell) for cell in row[:4]],
            "label": "Authentic" if row[4] == "0" else "Counterfeit"
        })

# Separate data into training and testing groups
evidence = [row["evidence"] for row in data]
labels = [row["label"] for row in data]

X_training, X_testing, y_training, y_testing = train_test_split(
    evidence, labels, test_size=0.4
)

for model_name, model in models.items():

    # Fit model
    model.fit(X_training, y_training)

    # Make predictions on the testing set
    predictions = model.predict(X_testing)

    # Compute how well we performed
    correct = (y_testing == predictions).sum()
    incorrect = (y_testing != predictions).sum()
    total = len(predictions)

    # Print results
    print(f"Model: {model_name}")
    print(f"Results for model {type(model).__name__}")
    print(f"Correct: {correct}")
    print(f"Incorrect: {incorrect}")
    print(f"Accuracy: {100 * correct / total:.2f}%")
    print()