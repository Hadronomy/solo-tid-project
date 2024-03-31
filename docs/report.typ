#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx, cellx

#import "template.typ": conf

#set text(lang: "en")

#show: doc => conf(
  title: [Home Loan Approval Classification],
  abstract: [
    The process of approving home loans plays a critical role in the financial sector, impacting individuals and economies alike. In this study, we undertake the classification of a home loan approval dataset using two distinct machine learning algorithms: Decision Tree Classifier (DTC) and Naive Bayes. The dataset encompasses various features such as applicant's income, credit history, loan amount, and employment status, among others.

    Our objective is to evaluate the performance of these algorithms in predicting the approval or rejection of home loan applications. We begin by preprocessing the dataset, handling missing values, and encoding categorical variables. Subsequently, we split the dataset into training and testing sets to train the classifiers and assess their performance.
  ],
  affiliations: (
    (
      name: "Universidad de La Laguna",
      full: [Tratamiento Inteligente de Datos, Escuela Superior de Ingeniería y Tecnología, #linebreak()Universidad de La Laguna, Canarias, España],
    ),
  ),
  authors: (
    (
      name: "Pablo Hernández Jiménez",
      affiliation: "Universidad de La Laguna",
      email: "alu0101495934@ull.edu.es",
    ),
  ),
  doc,
)



#columns(2)[

= Introduction
We will be analyzing a dataset of mortgage applications, 
with the goal of predicting whether a mortgage application will be approved or denied. 
For the prediction, we will be using the Decision Tree Classifier#footnote()[
  More information about the Decision Tree Classifier algorithm can be found in #link("https://en.wikipedia.org/wiki/Decision_tree_learning")
]
and Naive Bayes#footnote()[
  More information about the Naive Bayes algorithm can be found in #link("https://en.wikipedia.org/wiki/Naive_Bayes_classifier")
],
each with and without preprocessing, to guide
us to making the best decision when treating the data.

= Dataset Analysis <dataset-analysis>
A quick look at the dataset shows that there are $614$ entries and $12$ columns.

// Data columns (total 12 columns):
//  #   Column             Non-Null Count  Dtype  
// ---  ------             --------------  -----  
//  0   Loan_ID            614 non-null    object 
//  1   Gender             601 non-null    object 
//  2   Married            611 non-null    object 
//  3   Dependents         599 non-null    object 
//  4   Education          614 non-null    object 
//  5   SelfEmployed       582 non-null    object 
//  6   ApplicantIncome    614 non-null    int64  
//  7   CoapplicantIncome  614 non-null    object 
//  8   LoanAmount         592 non-null    float64
//  9   LoanAmountTerm     600 non-null    float64
//  10  PropertyArea       614 non-null    object 
//  11  LoanStatus         614 non-null    object 
// dtypes: float64(2), int64(1), object(9)
#colbreak()
#figure(
  text(8pt)[
    #table(
      columns: (auto, auto, 1fr, auto),
      align: (
        center + horizon,
        left + horizon,
        center + horizon,
        center + horizon
      ),

      table.header[\#][Columns][Non-Null Count][Dtype],
      [0], [Loan_ID], [614 non-null], [object],
      [1], [Gender], [601 non-null], [object],
      [2], [Married], [611 non-null], [object],
      [3], [Dependents], [599 non-null], [object],
      [4], [Education], [614 non-null], [object],
      [5], [SelfEmployed], [582 non-null], [object],
      [6], [ApplicantIncome], [614 non-null], [int64],
      [7], [CoapplicantIncome], [614 non-null], [object],
      [8], [LoanAmount], [592 non-null], [float64],
      [9], [LoanAmountTerm], [600 non-null], [float64],
      [10], [PropertyArea], [614 non-null], [object],
      [11], [LoanStatus], [614 non-null], [object],
    )
  ],
  kind: table,
  caption: [Dataset Columns],
)

Out of the $12$ columns, $9$ of them are of type object, which means they are categorical. Additionally, there are missing values in half of the columns, which we will need to handle before training the classifiers.

// Loan_ID              614
// Gender                 2
// Married                2
// Dependents             4
// Education              2
// SelfEmployed           2
// ApplicantIncome      505
// CoapplicantIncome    287
// LoanAmount           203
// LoanAmountTerm        10
// PropertyArea           3
// LoanStatus             2

Is worth noting that `Loan_ID` is a unique identifier for each entry, and `LoanStatus` is the target variable, which we will be predicting. The rest of the columns are features that will be used to train the classifiers.

#figure(
  text(8pt)[
    #tablex(
      columns: (1fr, auto),
      align: (left + horizon, center + horizon),
      auto-vlines: false,
      repeat-header: true,

      [*Column*], [*Unique Values*],
      [Loan_ID], [614],
      [ApplicantIncome], [505],
      [CoapplicantIncome], [287],
      [LoanAmount], [203],
    )
  ],
  kind: table,
  caption: [Unique Values for Non Categorical Columns],
) <unique-values-non-categorical>

As shown @unique-values-non-categorical, `Loan_ID` has $614$ unique values, which is the same as the number of entries in the dataset. 
This means, as expected that `Loan_ID` is a unique identifier for each entry. 
The rest of the columns have a lower number of unique values, which means they are not unique for each entry.

#figure(
  text(8pt)[
    #tablex(
      columns: (1fr, auto),
      align: (left + horizon, center + horizon),
      auto-vlines: false,
      repeat-header: true,

      [*Column*], [*Unique Values*],
      rowspanx(2, )[Gender], [Male], [Female],
      rowspanx(2)[Married], [Yes], [No],
      [Dependents], [0, 1, 2, 3+],
      rowspanx(2)[Education], [Graduate], [Not Graduate],
      rowspanx(2)[SelfEmployed], [Yes], [No],
      rowspanx(3)[PropertyArea], [Urban], [Semiurban], [Rural]
    )
  ],
  kind: table,
  caption: [Unique Values for Categorical Columns],
)

The unique values in categorical columns are each
of the possible values that the feature can take.

Next we have to check whether the dataset is balanced or not. 
This is important because if the dataset is not balanced, the classifiers might be biased towards the majority class.

#figure(
  image("images/balance.png"),
  caption: "Loan Status Distribution",
) <loan-status-distribution>

As seen in @loan-status-distribution the dataset is clearly unbalanced,
with a majority of the entries being approved loans,
doubling the number of denied loans.
This is important to keep in mind when training the classifiers, 
as they might be biased towards the majority class and not perform well when predicting the minority class.

To solve this issue, we will have to balance the dataset before training the classifiers.

= Basic Preprocessing <basic-preprocessing>
Even if at first we are not going to preprocess the dataset,
we will have to handle the missing values and encode the categorical features before training the classifiers.

Firstly, we will be dropping the `Loan_ID` column, as it is a unique identifier 
for each entry as it will just mess with the classifiers predictions.
As the `LoanStatus` column is the target variable, we will be separating it from the rest of the features.

After that, is necessary to handle the missing values. In this
case is just a basic preprocessing, the rows with missing values will be dropped.

Finally, we will be encoding the categorical features using the One-Hot Encoding
#footnote([
  More information about One-Hot Encoding can be found in
  #link("https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html")
]) technique.

The dataset is now ready to be split into training and testing sets,
and then to be trained and tested with the classifiers.

= Initial Results <naive-results>

For the purpose of better training and understanding the classifiers,
we will be training them with just the basic preprocessing.

The classifiers will be evaluated by their
accuracy, precision, recall, and F1-score.

The training and testing sets will be split with a $70|30$ ratio respectively.

== Decision Tree Classifier <dtc>

The Decision Tree Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[
/ criterion: entropy
/ max_depth: 5, to avoid overfitting#footnote([
  More information about overfitting can be found in #link(
    "https://www.ibm.com/es-es/topics/overfitting#:~:text=El%20\"overfitting\"%20o%20sobreajuste%20es,a%20sus%20datos%20de%20entrenamiento.",
    "https://www.ibm.com/es-es/topics/overfitting"
  )
])
]

Yielding the following results:

// Accuracy: 0.6496815286624203
// Precision: 0.5837945676843107
// Recall: 0.6496815286624203
// F1 Score: 0.5680379528894609
#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.6496815286624203],
    [Precision], [0.5837945676843107],
    [Recall], [0.6496815286624203],
    [F1 Score], [0.5680379528894609],
  ),
  kind: table,
  caption: "Decision Tree Classifier Scores, Without Preprocessing",
) <naive-dtc-scores>

#figure(
  image("images/dtc-cm.png"),
  caption: "Decision Tree Classifier Confusion Matrix, Without Preprocessing",
) <naive-dtc-cm>

Analyzing the results in @naive-dtc-scores:

#par(first-line-indent: 0em)[
/ Accuracy: represents the proportion of correctly classified instances out of the total instances. In this case, the classifier achieves an accuracy of approximately $65%$, indicating that about $65%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: measures the proportion of true positive predictions out of all positive predictions made by the classifier. A precision of $0.5838$ indicates that around $58%$ of the predicted approvals are indeed correct, while the remaining $42%$ are false positives.

/ Recall: also known as sensitivity, measures the proportion of true positive predictions out of all actual positive instances in the dataset. With a recall of $0.6497$, the classifier captures about $65%$ of the actual positive instances, meaning that it misses around $35%$ of the true positives.

/ F1 Score: A value of $0.5680$ suggests that the classifier achieves a reasonable balance between precision and recall.
]

Also as implied in @naive-dtc-scores and clearly seen in @naive-dtc-cm,
the classifier is biased towards the majority class.
This is a common issue when dealing with unbalanced datasets,
and it can be solved by balancing the dataset before training the classifiers.

Overall, the trained classifier demonstrates moderate performance in classifying home loan applications. 
While the accuracy is relatively decent, there is room for improvement in terms of
precision, recall, and F1 score.
Depending on the specific requirements and objectives of the application,
further optimization or fine-tuning of the classifier may be
necessary to enhance its performance.


]

#page(flipped: true)[

#figure(
  image("images/dtc-first.png"),
  caption: "Decision Tree Classifier Without Preprocessing",
) <naive-dtc-graph>

]

#pagebreak()

#columns(2)[

== Naive Bayes Classifier <nbc>

The Naive Bayes Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[
/ priors: None
/ var_smoothing: $1e-9$
]

Yielding the following results:

// Accuracy: 0.3503184713375796
// Precision: 0.5272944898046424
// Recall: 0.3503184713375796
// F1 Score: 0.2262632996693664
#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.3503184713375796],
    [Precision], [0.5272944898046424],
    [Recall], [0.3503184713375796],
    [F1 Score], [0.2262632996693664],
  ),
  kind: table,
  caption: "Naive Bayes Classifier Scores, Without Preprocessing",
) <naive-nbc-scores>

#figure(
  image("images/nbc-cm.png"),
  caption: "Naive Bayes Classifier Confusion Matrix, Without Preprocessing",
) <naive-nbc-cm>

Analyzing the results in @naive-nbc-scores:

#par(first-line-indent: 0em)[
/ Accuracy: the classifier achieves an accuracy of approximately $35%$, indicating that about $35%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: with a precision of $0.5273$, around $53%$ of the predicted approvals are indeed correct, while the remaining $47%$ are false positives.

/ Recall: the classifier captures about $35%$ of the actual positive instances, meaning that it misses around $65%$ of the true positives.

/ F1 Score: A value of $0.2263$ suggests that the classifier does not achieve a good balance between precision and recall.
]

Also as implied in @naive-nbc-scores and clearly seen in @naive-nbc-cm, 
the classifier is biased towards the majority class.
This is a common issue when dealing with unbalanced datasets,
and it can be solved by balancing the dataset before training the classifiers.

Overall, the trained classifier demonstrates poor performance in classifying home loan applications.
The accuracy, precision, recall, and F1 score are all relatively low, 
indicating that the classifier struggles to accurately predict the approval or rejection of home loan applications.

]

#pagebreak()

#columns(2)[

== K-NN Classifier <knn>

The K-Nearest Neighbors (K-NN) Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[
/ n_neighbors: 5
/ weights: uniform
/ algorithm: auto
/ leaf_size: 30
/ p: 2, power parameter for the Minkowski metric.
/ metric: minkowski
/ metric_params: None
/ n_jobs: None
]

Yielding the following results:

// Accuracy: 0.643312101910828
// Precision: 0.533648771610555
// Recall: 0.643312101910828
// F1 Score: 0.5388802514335389

#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.643312101910828],
    [Precision], [0.533648771610555],
    [Recall], [0.643312101910828],
    [F1 Score], [0.5388802514335389],
  ),
  kind: table,
  caption: [K-NN Classifier Scores,#linebreak() Without Preprocessing],
) <naive-knn-scores>

#figure(
  image("images/knn-cm.png"),
  caption: "K-NN Classifier Confusion Matrix, Without Preprocessing",
) <naive-knn-cm>

Analyzing the results in @naive-knn-scores:

#par(first-line-indent: 0em)[
/ Accuracy: the classifier achieves an accuracy of approximately $64%$, indicating that about $64%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: with a precision of $0.5336$, around $53%$ of the predicted approvals are indeed correct, while the remaining $47%$ are false positives.

/ Recall: the classifier captures about $64%$ of the actual positive instances, meaning that it misses around $36%$ of the true positives.

/ F1 Score: A value of $0.5389$ suggests that the classifier does not achieve a good balance between precision and recall.

]

Also as implied in @naive-knn-scores and clearly seen in @naive-knn-cm,
the classifier is biased towards the majority class.

Overall, the trained classifier demonstrates moderate performance in classifying home loan applications. 
There is room for improvement in all metrics. Depending on the specific requirements and objectives of the application, 
further optimization or fine-tuning of the classifier may be necessary to enhance its performance.

== Conclusions <naive-conclusions>

In conclusion, the classifiers demonstrate moderate to poor performance in
classifying home loan applications. 
This is to be expected as the dataset
has not been preprocessed, and it is unbalanced. 
The classifiers are biased towards the majority class, and they struggle to
accurately predict the approval or rejection of home loan applications.

The best performing classifier at this stage is the Decision Tree Classifier.

]

#pagebreak()

#columns(2)[

= Proper Preprocessing <proper-preprocessing>

Now that we have seen the results of the classifiers without preprocessing,
we will be training them with proper preprocessing.

The dataset will be preprocessed using the following steps:

#par(first-line-indent: 0em)[

+ Dropping the `Loan_ID` column, as it is a unique identifier for each entry.
+ Separating the `LoanStatus` column from the rest of the features.
+ Encoding the categorical features using the One-Hot Encoding technique.
+ Scaling the numerical features using the Standard Scaler.
+ Handling the missing values by imputing the median for the numerical columns and the most frequent value for the categorical columns.
]

After splitting the dataset into training and testing sets, we will
find outlier values and balance the training set using the SMOTE#footnote([
  More information about the SMOTE technique can be found in 
  #link("https://imbalanced-learn.org/stable/references/generated/imblearn.over_sampling.SMOTE.html")
]) technique
This technique will create synthetic samples of the minority class to balance the dataset.

The classifiers will be evaluated by their accuracy, precision, recall, and F1-score.

The training and testing sets will be split with a $60|40$ ratio respectively.


= Final Results <final-results>

== Decision Tree Classifier <dtc-final>

The Decision Tree Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[

/ criterion: entropy
/ max_depth: 5, to avoid overfitting
]

Yielding the following results:

// Accuracy: 0.6382113821138211
// Precision: 0.6134095640296096
// Recall: 0.6382113821138211
// F1 Score: 0.6180512012505862

#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.6382113821138211],
    [Precision], [0.6134095640296096],
    [Recall], [0.6382113821138211],
    [F1 Score], [0.6180512012505862],
  ),
  kind: table,
  caption: "Decision Tree Classifier Scores, With Proper Preprocessing",
) <final-dtc-scores>

#figure(
  image("images/dtc-final-cm.png"),
  caption: "Decision Tree Classifier Confusion Matrix, With Proper Preprocessing",
) <final-dtc-cm>

In this case, the previous results are improved, as shown in @final-dtc-scores compared to @naive-dtc-scores.

#par(first-line-indent: 0em)[

/ Accuracy: the classifier achieves an accuracy of approximately $64%$, indicating that about $64%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: with a precision of $0.6134$, around $61%$ of the predicted approvals are indeed correct, while the remaining $39%$ are false positives.

/ Recall: the classifier captures about $64%$ of the actual positive instances, meaning that it misses around $36%$ of the true positives.

/ F1 Score: A value of $0.6181$ suggests that the classifier achieves a reasonable balance between precision and recall.
]

Also as implied in @final-dtc-scores and clearly seen in @final-dtc-cm,
the classifier is still biased towards the majority class, but not as
much as before.

Overall, the trained classifier demonstrates moderately high performance in classifying home loan applications.

]

#page(flipped: true)[

#figure(
  image("images/dtc-final.png"),
  caption: "Decision Tree Classifier With Proper Preprocessing",
) <final-dtc-graph>

]

#pagebreak()

#columns(2)[

== Naive Bayes Classifier <nbc-final>

The Naive Bayes Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[

/ priors: None
/ var_smoothing: $1e-9$
]

Yielding the following results:

// Accuracy: 0.3699186991869919
// Precision: 0.5352572985957131
// Recall: 0.3699186991869919
// F1 Score: 0.27234284279815585

#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.3699186991869919],
    [Precision], [0.5352572985957131],
    [Recall], [0.3699186991869919],
    [F1 Score], [0.27234284279815585],
  ),
  kind: table,
  caption: "Naive Bayes Classifier Scores, With Proper Preprocessing",
) <final-nbc-scores>

#figure(
  image("images/nbc-final-cm.png"),
  caption: "Naive Bayes Classifier Confusion Matrix, With Proper Preprocessing",
) <final-nbc-cm>

In this case the previous results are improved, as shown in @final-nbc-scores compared to @naive-nbc-scores. But the classifier still struggles to accurately predict the approval or rejection of home loan applications.

#par(first-line-indent: 0em)[

/ Accuracy: the classifier achieves an accuracy of approximately $37%$, indicating that about $37%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: with a precision of $0.5353$, around $53%$ of the predicted approvals are indeed correct, while the remaining $47%$ are false positives.

/ Recall: the classifier captures about $37%$ of the actual positive instances, meaning that it misses around $63%$ of the true positives.

/ F1 Score: A value of $0.2723$ suggests that the classifier does not achieve a good balance between precision and recall.
]

Also as implied in @final-nbc-scores and clearly seen in @final-nbc-cm,
the classifier is still biased towards the majority class.

Overall, the trained classifier demonstrates poor performance in classifying home loan applications.

#colbreak()

== K-NN Classifier <knn-final>

The K-Nearest Neighbors (K-NN) Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[

/ n_neighbors: 5
/ weights: uniform
/ algorithm: auto
/ leaf_size: 30
/ p: 2, power parameter for the Minkowski metric.
/ metric: minkowski
/ metric_params: None
/ n_jobs: None
]

Yielding the following results:

// Accuracy: 0.42276422764227645
// Precision: 0.4640303290331651
// Recall: 0.42276422764227645
// F1 Score: 0.4366383820888397

#figure(
  tablex(
    columns: (1fr, auto),
    align: (left, center),
    auto-vlines: false,
    repeat-header: true,

    [*Metric*], [*Score*],
    [Accuracy], [0.42276422764227645],
    [Precision], [0.4640303290331651],
    [Recall], [0.42276422764227645],
    [F1 Score], [0.4366383820888397],
  ),
  kind: table,
  caption: "K-NN Classifier Scores, With Proper Preprocessing",
) <final-knn-scores>

#figure(
  image("images/knn-final-cm.png"),
  caption: "K-NN Classifier Confusion Matrix, With Proper Preprocessing",
) <final-knn-cm>

In this case the new results are way worse than the previous ones, as shown in @final-knn-scores compared to @naive-knn-scores.

#par(first-line-indent: 0em)[

/ Accuracy: the classifier achieves an accuracy of approximately $42%$, indicating that about $42%$ of the home loan applications are correctly classified as either approved or rejected.

/ Precision: with a precision of $0.4640$, around $46%$ of the predicted approvals are indeed correct, while the remaining $54%$ are false positives.

/ Recall: the classifier captures about $42%$ of the actual positive instances, meaning that it misses around $58%$ of the true positives.

/ F1 Score: A value of $0.4366$ suggests that the classifier does not achieve a good balance between precision and recall.
]

Also as implied in @final-knn-scores and clearly seen in @final-knn-cm,

Overall, the trained classifier demonstrates poor performance in classifying home loan applications.

= Final Conclusion <final-conclusion>

After proper preprocessing, the classifiers demonstrate moderate to poor performance in classifying home loan applications.

The best performing classifier at this stage is the Decision Tree Classifier,
the same as before. The Naive Bayes Classifier performs horribly, and the K-NN Classifier performs poorly.

With a better preprocessing fitted to the dataset, the classifiers still 
struggle to accurately predict the approval or rejection of home loan applications. The preprocessing has improved the results, but not enough to make the classifiers useful. 
This indicates that either the dataset has too much noise, 
or some the classifiers are not suitable for this task. It could also be a
blunder in the preprocessing, but that is unlikely as the preprocessing
is quite standard.

In conclusion the classifiers are not suitable for this task, and further
analysis is needed to find a better model for this dataset.

]

