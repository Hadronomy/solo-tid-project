#import "template.typ": conf

#set text(lang: "en")

#show: doc => conf(
  title: [Clasificación de Conseción de Hipotecas],
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
#lorem(80) 
#link(
  "https://www.google.com",
  "Google",
)
#footnote[A search engine]

= Dataset Analysis
#lorem(100)

= Basic Processing
#lorem(90)
#figure(
  image("example.png"),
  caption: "Image Example",
)
#lorem(30)

= Naive Results
#lorem(400)

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    rows: 3,
    [Colum1], [Colum2] ,[Colum3],
    [Row1], [Row1], [Row1],
    [Row2], [Row2], [Row2],
  ),
  caption: "Table Example",
)

]

#figure(
  image("example-big.jpg"),
  caption: "Ejemplo de imagen",
)

#columns(2)[

= Data Preprocessing
#lorem(120)

= Final Results
#lorem(130)

= Conclusions
#lorem(80)

]


