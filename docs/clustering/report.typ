#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx, cellx
#import "@preview/note-me:0.2.1": important

#import "template.typ": conf

#set text(lang: "en")

#show: doc => conf(
  title: [Mall Customer Clustering],
  abstract: [
    The clustering of datasets is a common task for data analysis and machine learning. Clustering algorithms group similar data points together, allowing for the identification of patterns and relationships within the data.
    In this report, we will be clustering a dataset of mall customers.
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
We will be clustering a dataset of mall customers using the *K-Means*#footnote()[
  More information about the *K-Means* algorithm can be found in 
  #link("https://en.wikipedia.org/wiki/K-means_clustering")
] algorithm. Clustering is an unsupervised learning technique that groups similar 
data points together based on their features. 
The *K-Means* algorithm is one of the most popular clustering algorithms, 
as it is simple, efficient, and easy to implement.

= Dataset Analysis <dataset-analysis>
As show in @dataset-columns, 
a quick look at the dataset shows that there are $200$ entries and $5$ columns.

// Data columns (total 5 columns):
//  #   Column          Non-Null Count  Dtype 
// ---  ------          --------------  ----- 
//  0   CustomerID      200 non-null    int64 
//  1   Genre           200 non-null    object
//  2   Age             200 non-null    int64 
//  3   Annual Income   200 non-null    int64 
//  4   Spending Score  200 non-null    int64 
// dtypes: int64(4), object(1)
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
      [0], [CustomerID], [200], [int64],
      [1], [Genre], [200], [object],
      [2], [Age], [200], [int64],
      [3], [Annual Income], [200], [int64],
      [4], [Spending Score], [200], [int64],
    )
  ],
  kind: table,
  caption: [Dataset Columns],
) <dataset-columns>

@dataset-columns shows that the dataset consists of $200$ entries in every column, 
which means there are no missing values. The columns are of type `int64` except for the `Genre` column, 
which is of type `object`, indicating that it is a categorical feature.

Is worth noting that `CustomerID` is a unique identifier for each entry,
as any *UID*#footnote()[
  more information about unique identifiers can be found in
  #link("https://en.wikipedia.org/wiki/Unique_identifier")
] this column will be dropped before training the classifiers.

Genre is a categorical feature, and as such, it will have to be encoded before training the classifiers.
It contains two unique values: `Male` and `Female`.

#figure(
  text(8pt)[
    #tablex(
      columns: (1fr, auto),
      align: (left + horizon, center + horizon),
      auto-vlines: false,
      repeat-header: true,

      [*Column*], [*Unique Values*],
      rowspanx(2, )[Genre], [Male], [Female],
    )
  ],
  kind: table,
  caption: [Unique Values for Categorical Columns],
)

= Data Preprocessing

Before training the *K-Means* algorithm, we need to preprocess the data.

The steps involved in the data preprocessing are:

+ Drop the `CustomerID` column, as it is a unique identifier and does not provide any useful information for clustering.
+ Find outliers for each feature using the *Isolation Forest*#footnote()[
  More information about the *Isolation Forest* algorithm can be found in 
  #link("https://en.wikipedia.org/wiki/Isolation_forest")
] algorithm and remove them from the dataset.
+ Encode the `Genre` column, as it is a categorical feature. 
  We will use the `OrdinalEncoder` from the `scikit-learn` library to encode the `Genre` column.
+ Scale the data using the `MinMaxScaler` from the `scikit-learn` library. 
  Scaling the data is important for clustering algorithms, 
  as it ensures that all features contribute equally to the clustering process.

#important()[
  The use of the `OrdinalEncoder` is justified in this case, 
  as the `Genre` column has only two unique values: `Male` and `Female`.
]

All the preprocessing steps will be done inside a `ColumnTransformer`.

== Outlier Detection

The *Isolation Forest* algorithm is an unsupervised learning algorithm that is used to detect outliers in a dataset.
It works by isolating the outliers in the dataset by randomly selecting 
a feature and then randomly selecting a split value between the maximum and minimum values of the selected feature.

We will use the `IsolationForest` class from the `sklearn.ensemble` module to detect outliers in the dataset.

// group outlier%
// male 0.06818181818181818
// female 0.16071428571428573
#figure(
  text(8pt)[
    #table(
      columns: (1fr, auto),
      align: (left + horizon, center + horizon),

      table.header[\#][Outlier%],
      [male], [0.068],
      [female], [0.161],
    )
  ],
  kind: table,
  caption: [Outliers Detected],
) <outlier-detection> 

The percentage of outliers detected for the `Male` and `Female` groups is shown in @outlier-detection.

The percentage of outliers detected for the `Male` group is $6.8\%$,
while the percentage of outliers detected for the `Female` group is $16.1\%$.

#figure(
  image(
    "./images/outliers.png",
    width: 100%,
  ),
  caption: [Outliers Detected],
) <outliers>

In @outliers we can see the outliers detected in the dataset, marked in a
light color.

All the outliers will be removed from the dataset before training the *K-Means* algorithm.

The number of entries in the dataset after removing the outliers is $176$.


= *K-Means* Clustering

The *K-Means* algorithm is an iterative algorithm that partitions the dataset into $k$ clusters.
The algorithm works by randomly selecting $k$ data points as the initial 
centroids of the clusters and then assigning each data point to the nearest centroid.

Before training the *K-Means* algorithm, we need to determine the optimal number of clusters.

== Determining the Optimal Number of Clusters

For determining the optimal number of clusters, we will use the *Elbow Method*#footnote()[
  More information about the *Elbow Method* can be found in 
  #link("https://en.wikipedia.org/wiki/Elbow_method_(clustering)")
]. The *Silhouette Score*#footnote()[
  More information about the *Silhouette Score* can be found in 
  #link("https://en.wikipedia.org/wiki/Silhouette_(clustering)")
] will also be used to evaluate the clustering performance.

The *Elbow Method* works by plotting the sum of squared distances 
between the data points and their assigned clusters for different values of $k$.
This can also be done visually by plotting the inertia of the *K-Means* algorithm for different values of $k$.
But in this case, we will be using the `KElbowVisualizer` 
from `yellowbrick.cluster` to determine the optimal number of clusters.

#figure(
  image(
    "./images/elbow-global.png",
    width: 100%,
  ),
  caption: [Optimal value of $k$ using the Elbow Method],
) <elbow-method>

As shown in @elbow-method, the optimal number of clusters is $k=5$.

== Training the *K-Means* Algorithm

After determining the optimal number of clusters, we will train the *K-Means* algorithm
using $k=5$ clusters.

The trained *K-Means* algorithm will be used to predict the clusters for each data point in the dataset.

//          Genre  Age  Annual Income  Spending Score
// Cluster                                           
// 0         1.00 0.73           0.34            0.35
// 1         0.00 0.54           0.37            0.36
// 2         1.00 0.20           0.41            0.73
// 3         1.00 0.31           0.62            0.09
// 4         0.00 0.19           0.41            0.68
#figure(
  text(8pt)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      align: (left + horizon, center + horizon),

      table.header[Cluster][Genre][Age][Annual Income][Spending Score],
      [Cluster 0], [1.00], [0.73], [0.34], [0.35],
      [Cluster 1], [0.00], [0.54], [0.37], [0.36],
      [Cluster 2], [1.00], [0.20], [0.41], [0.73],
      [Cluster 3], [1.00], [0.31], [0.62], [0.09],
      [Cluster 4], [0.00], [0.19], [0.41], [0.68],
    )
  ],
  kind: table,
  caption: [Cluster Centers],
) <cluster-centers>

The cluster centers for each cluster are shown in @cluster-centers.
The values are scaled between $0$ and $1$. In the case on
*Genre* the value $1.00$ represents *Male* and $0.00$ represents *Female*.

The cluster centers represent the average values of the features for each cluster.
The cluster centers can be used to interpret the characteristics of each cluster.

#par(first-line-indent: 0em)[
#linebreak()
Analysis of the cluster centers shows that:
]

- *Cluster $0$* has a high `Spending Score` and `Annual Income`, and
  all the customers in this cluster are the youngest `Male`.
- *Cluster $1$* has a moderate `Spending Score` and `Annual Income`, and
  all the customers in this cluster are moderately old `Female`.
- *Cluster $2$* has a high `Spending Score`, and
  all the customers in this cluster are young `Male`.
- *Cluster $3$* has a low `Spending Score` and `Annual Income`, and
  all the customers in this cluster are the oldest `Male`.
- *Cluster $4$* has a high `Spending Score` and `Age`, and
  all the customers in this cluster are young `Female`.

Each cluster represents a group of customers with clear characteristics,
which can be used for targeted marketing strategies.

#figure(
  image(
    "./images/clusters-global.png",
    width: 100%,
  ),
  caption: [Clusters Detected],
) <clusters>

In @clusters, we can see the clusters detected in the dataset, 
where each color represents a different cluster.

In @dendrogram-global, we can see the dendrogram of the hierarchical clustering
of the dataset. In this case the `single` linkage is the best
preserving distances.

]

#page(flipped: true)[
#figure(
  image(
    "./images/dendrogram-global.png",
    width: 70%,
  ),
  caption: [Dendrogram of the Hierarchical Clustering],
) <dendrogram-global>

]

#columns(2)[
== *K-Means* Clustering by Genre

We will split the dataset by `Genre` and perform the *K-Means* 
clustering separately for `Male` and `Female` customers.

== Determining the Optimal Number of Clusters for `Male` and `Female` Customers

After splitting the dataset by `Genre`, we will determine the optimal number of clusters
for each group using the *Elbow Method* and train the *K-Means* algorithm.

#figure(
  image(
    "./images/elbow-male.png"
  ),
  caption: [Optimal value of $k$ for `Male` customers],
) <elbow-male>

#figure(
  image(
    "./images/elbow-female.png"
  ),
  caption: [Optimal value of $k$ for `Female` customers],
) <elbow-female>

As show in @elbow-male and @elbow-female, the optimal number of clusters for `Male` customers is $k=3$,
and the optimal number of clusters for `Female` customers is $k=2$.

This makes a total of $5$ clusters, which is the same as the clustering of the whole dataset.

== Training the *K-Means* Algorithm for `Male` and `Female` Customers

After determining the optimal number of clusters for `Male` and `Female` customers,
we will train the *K-Means* algorithm for each group.

The results for the `Male` customers are shown in @clusters-male, The
results for the `Female` customers are shown in @clusters-female.

//          Genre  Age  Annual Income  Spending Score
// Cluster                                           
// 0         1.00 0.31           0.62            0.09
// 1         1.00 0.20           0.41            0.73
// 2         1.00 0.73           0.34            0.35
#figure(
  text(8pt)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      align: (left + horizon, center + horizon),

      table.header[Cluster][Genre][Age][Annual Income][Spending Score],
      [Cluster 0], [1.00], [0.31], [0.62], [0.09],
      [Cluster 1], [1.00], [0.20], [0.41], [0.73],
      [Cluster 2], [1.00], [0.73], [0.34], [0.35],
    )
  ],
  kind: table,
  caption: [Cluster Centers for `Male` Customers],
) <clusters-male>


//          Genre  Age  Annual Income  Spending Score
// Cluster                                           
// 0         0.00 0.54           0.37            0.36
// 1         0.00 0.19           0.41            0.68
#figure(
  text(8pt)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      align: (left + horizon, center + horizon),

      table.header[Cluster][Genre][Age][Annual Income][Spending Score],
      [Cluster 0], [0.00], [0.54], [0.37], [0.36],
      [Cluster 1], [0.00], [0.19], [0.41], [0.68],
    )
  ],
  kind: table,
  caption: [Cluster Centers for `Female` Customers],
) <clusters-female>

Joining the results of the clustering of `Male` and `Female` customers, we can conclude
that *the resulting clusters are the same as the clustering of the whole dataset*.

In the respective dendrograms, @dendrogram-male and @dendrogram-female we can see the hierarchical clustering
of the dataset for `Male` and `Female` customers. And once again the `single` linkage is the best
at preserving distances.

= Conclusion

In this report, we have clustered a dataset of mall customers using the *K-Means* algorithm.
The dataset was split by `Genre` and clustered separately for `Male` and `Female` customers.

The optimal number of clusters for the whole dataset was determined to be $k=5$.
The optimal number of clusters for `Male` customers was $k=3$, and for `Female` customers was $k=2$.

Demosntrating that the resulting clusters are the same as the clustering of the whole dataset.

Clustering is a powerful technique that can be used to identify patterns and relationships within the data.
The clusters detected in the dataset can be used for targeted 
marketing strategies to improve customer satisfaction and increase sales.

]

#page(flipped: true)[

#figure(
  image(
    "./images/dendrogram-male.png",
    width: 70%,
  ),
  caption: [Dendrogram of the Hierarchical Clustering for `Male` Customers],
) <dendrogram-male>

]

#page(flipped: true)[

#figure(
  image(
    "./images/dendrogram-female.png",
    width: 70%,
  ),
  caption: [Dendrogram of the Hierarchical Clustering for `Female` Customers],
) <dendrogram-female>

]