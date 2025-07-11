#let front-page(
  title: "", course: "", type: "", description: "", authors: (),
  date: none, department: "", department-full-title: "", body
) = {
  set text(size: 10pt, fill: black)
  set par(leading: 1em, justify: true)
  set page(numbering: none, number-align: center, fill: rgb("#ffffff"), margin: (top: 1.5in, rest: 2in))
  set page(margin: 0.5in)

  let depart = [
    #align(right, [
      #block([
        #align(right)[
          #text(weight: 540, 1.0em, department)
          #v(0.7em, weak: true)
          #text(weight: 540, 1.0em, department-full-title)
          #v(0.7em, weak: true)
          #text(weight: 720, 1.0em, "NRC 25874" + " • " + course)

        ]
      ])
    ])
  ]

  table(
    columns: (auto, 1fr), inset: 0pt, stroke: none, align: horizon,
    table.header(
      [#image("../images/FA/Logo-alterno-continental.svg", width: 6.5em)],
      [#depart]
    ),
  )


  v(2.5em)
  text(weight: 1000, 26pt, title)
  linebreak()
  v(2.9em)
  align(right)[
    #text(12pt, "Docente")
    #v(0.7em, weak: true)
    #text(16pt, "Walter Quispe Vargas")
  ]
  v(1em)

  text(12pt, "Autores")
  v(0.9em, weak: true)
  pad(x: 0.1em, grid(
    gutter: 1em, columns: if authors.len() == 0 {2} else {3},
    ..authors.map(author => align(left, author)),
  ),)
  
  place(
    bottom, dx: -150%, dy: 33%, 
    image("../images/FA/CONTINENTAL-sede-Huancayo.jpg", width: 300%)
  )

  pagebreak()
  body
}