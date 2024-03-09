#import "template.typ": conf

#set text(lang: "es")

#show: doc => conf(
  title: [Clasificación de Conseción de Hipotecas],
  affiliations: (
    (
      name: "Universidad de La Laguna",
      full: "Tratamiento Inteligente de Datos, Escuela Superior de Ingeniería y Tecnología, Universidad de La Laguna",
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

#set columns(2)
== Section 1
#figure(
  image("example.png"),
  caption: "Ejemplo de imagen",
)
#lorem(80) 
#link(
  "https://www.google.com",
  "Google",
)
#footnote[A search engine]

== Section 2
#lorem(100)

== Section 3
#lorem(90)

== Section 4
#lorem(110)

#figure(
  image("example-big.jpg"),
  caption: "Ejemplo de imagen",
)


== Section 5
#lorem(120)

== Section 6
#lorem(130)

