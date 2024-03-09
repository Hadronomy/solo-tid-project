#import "template.typ": conf

#set text(lang: "en")

#show: doc => conf(
  title: [Clasificación de Conseción de Hipotecas],
  abstract: [
    The process of approving home loans plays a critical role in the financial sector, impacting individuals and economies alike. In this study, we undertake the classification of a home loan approval dataset using two distinct machine learning algorithms: Decision Tree Classifier (DTC) and Naive Bayes. The dataset encompasses various features such as applicant's income, credit history, loan amount, and employment status, among others.

    Our objective is to evaluate the performance of these algorithms in predicting the approval or rejection of home loan applications. We begin by preprocessing the dataset, handling missing values, and encoding categorical variables. Subsequently, we split the dataset into training and testing sets to train the classifiers and assess their performance.
  ],
  affiliations: (
    (
      name: "Universidad de La Laguna",
      full: "Tratamiento Inteligente de Datos, Escuela Superior de Ingeniería y Tecnología, Universidad de La Laguna, Canarias, España",
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
#lorem(100)

= Basic Processing <basic-processing>
#lorem(90)
#figure(
  image("images/example.png"),
  caption: "Image Example",
)
#lorem(30)

= Naive Results <naive-results>
#lorem(30)

== Decision Tree Classifier <dtc>

#lorem(50)

#figure(
  image("images/dtc-cm.png"),
  caption: "Decision Tree Classifier Confusion Matrix, Without Preprocessing",
)

#lorem(80)

== Naive Bayes Classifier <nbc>

#lorem(50)

// #figure(
//   image("images/nbc-cm.png"),
//   caption: "Image Example",
// )

#lorem(80)

]

#figure(
  image("images/dtc-first.png"),
  caption: "Decision Tree Classifier Without Preprocessing",
)

#columns(2)[

= Data Preprocessing
#lorem(120)

= Final Results
#lorem(130)

= Conclusions
#lorem(80)

]


