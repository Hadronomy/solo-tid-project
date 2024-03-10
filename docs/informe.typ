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
  caption: [Unique Values for non categorical columns],
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
  caption: [Unique Values for categorical columns],
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
#lorem(90)
#lorem(30)

= Naive Results <naive-results>
#lorem(30)

#lorem(80)

== Naive Bayes Classifier <nbc>

#lorem(50)

// #figure(
//   image("images/nbc-cm.png"),
//   caption: "Image Example",
// )

#lorem(80)

== Decision Tree Classifier <dtc>

#lorem(50)

#figure(
  image("images/dtc-cm.png"),
  caption: "Decision Tree Classifier Confusion Matrix, Without Preprocessing",
)

]

#figure(
  image("images/dtc-first.png"),
  caption: "Decision Tree Classifier Without Preprocessing",
)

#columns(2)[

= Proper Preprocessing <proper-preprocessing>
#lorem(120)

= Final Results <final-results>
#lorem(130)

= Conclusions <conclusions>
#lorem(80)

]


