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
A quick look at the dataset shows that there are 614 entries and 12 columns.

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
    #tablex(
      columns: (auto, auto, 1fr, auto),
      align: (
        center + horizon,
        left + horizon,
        center + horizon,
        center + horizon
      ),
      auto-vlines: false,
      repeat-header: true,

      [*\#*], [*Columns*], [*Non-Null Count*], [*Dtype*],
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

Out of the 12 columns, 9 of them are of type object, which means they are categorical. Additionally, there are missing values in half of the columns, which we will need to handle before training the classifiers.

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
)<unique-values-non-categorical>

As shown @unique-values-non-categorical, `Loan_ID` has 614 unique values, which is the same as the number of entries in the dataset. 
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
)<loan-status-distribution>

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

The datasets will be evaluated by their
accuracy, precision, recall, and F1-score.

The training and testing sets will be split with a $70|30$ ratio respectively.

== Decision Tree Classifier <dtc>

The Decision Tree Classifier was trained with the following parameters:

#par(first-line-indent: 0em)[
/ criterion: entropy
/ max_depth: 5, to avoid overfitting
#footnote([
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

Analyzing the results in @naive-dtc-scores

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

#figure(
  image("images/dtc-first.png"),
  caption: "Decision Tree Classifier Without Preprocessing",
) <naive-dtc-graph>

#columns(2)[

== Naive Bayes Classifier <nbc>

#lorem(50)

// #figure(
//   image("images/nbc-cm.png"),
//   caption: "Image Example",
// )

#lorem(80)

= Proper Preprocessing <proper-preprocessing>
#lorem(120)

= Final Results <final-results>
#lorem(130)

= Conclusions <conclusions>
#lorem(80)

]


