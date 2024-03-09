#import "@preview/chic-hdr:0.4.0": *

#let conf(
  title: none,
  affiliations: (),
  authors: (),
  doc
) = {
  // latex looks
  set page(margin: 1.0in)
  set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
  set text(font: "New Computer Modern")
  show raw: set text(font: "New Computer Modern Mono")
  show par: set block(spacing: 0.55em)
  show heading: set block(above: 1.4em, below: 1em)

  // page
  set page(
    paper: "a4",
  )

  show: chic.with(
    skip: 1,
    chic-header(
      center-side: [
        #text(8pt, upper(title))
      ]
    ),
    chic-separator(1pt),
    chic-height(10em)
  )

  // authors
  let names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    names.join(" and ")
  } else {
    names.join(", ", last: ", and ")
  }
  let emails = authors.map(author => author.email)
  let emails-string = emails.join($", "$)

  set document(title: title, author: author-string)

  // styling
  show link: it => text(blue, it)

  set cite(style: "chicago-author-date")
  set bibliography(style: "apa", title: "references")
  
  // figures
  show figure: it => {
    set align(center)
    show: pad.with(x: 13pt)
    v(12.5pt, weak: true)

    // Display the figure's body.
    it.body

    // Display the figure's caption.
    if it.has("caption") {
      it.caption
    }
    v(1em)
  }

  // page numbering
  set text(8pt)
  set page(
    footer: locate(loc => {
      let counter = counter(page)
      let number = counter.at(loc)
      if calc.odd(number.first()) {
        align(right, counter.display())
      } else {
        align(left, counter.display())
      }
    })
  )

  set align(center)

  pad(top: 15em, bottom: 4em, [
    #rect(width: 60%, stroke: none, [
      #par(justify: false, [
        #text(12pt, weight: "bold", upper(title))
      ])

      #v(1em)
      #par(justify: false, leading: 20em, [
        #text(10pt, weight: "semibold", [
          #author-string
        ])
      ])

      #for affiliation in affiliations {
        v(1em)
        text(9pt, [
          #text(8pt, style: "italic",
            affiliation.full
          )
        ])
      }

      #v(1em)
      #text(9pt, [
        E-mail: 
        #text(8pt, style: "italic",
          emails-string
        )
      ])
    ])
  ])

  
  
  set text(10pt)
  set align(left)
  columns(2, doc)
}