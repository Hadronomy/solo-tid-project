import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import ConfusionMatrixDisplay, confusion_matrix
from sklearn.feature_selection import RFE
import matplotlib.pyplot as plt
from imblearn.over_sampling import SMOTE

num_attributes = [
    "credit_score",
    "age",
    "tenure",
    "balance",
    "products_number",
    "credit_card",
    "active_member",
    "estimated_salary",
]

dataset = pd.read_csv("data/gauravtopre-bank-customer-churn-dataset.csv")

churn_zero = len(dataset[dataset["churn"] == 0])
churn_one = len(dataset[dataset["churn"] == 1])

print(f"Churn 0: {churn_zero} Churn 1: {churn_one} = {churn_zero + churn_one}")

dataset = dataset.drop("customer_id", axis=1)
dataset_no_churn = dataset.drop("churn", axis=1)

pipeline = ColumnTransformer(
    [
        ("numeric", StandardScaler(), num_attributes),
        ("text", OneHotEncoder(), ["gender"])
    ]
)
preprocessed_dataset = pipeline.fit_transform(dataset_no_churn)

X_train, X_test, y_train, y_test = train_test_split(
    preprocessed_dataset, dataset["churn"], test_size=0.2, random_state=42
)

sm = SMOTE(random_state=42)
X_train_oversampled, y_train_oversampled = sm.fit_resample(X_train, y_train)

classifier = SVC(kernel="poly")
classifier.fit(X_train_oversampled, y_train_oversampled)

# rfe = RFE(estimator=classifier, n_features_to_select=5, step=1)
# rfe.fit(X_train_oversampled, y_train_oversampled)

# train_rfe = rfe.transform(X_train_oversampled)
# test_rfe = rfe.transform(X_test)

confusion_matrix = confusion_matrix(y_test, classifier.predict(X_test))
cm_display = ConfusionMatrixDisplay(
    confusion_matrix, display_labels=classifier.classes_
).plot()


print(f"SVC: {classifier.score(X_test, y_test)}")

plt.show()
