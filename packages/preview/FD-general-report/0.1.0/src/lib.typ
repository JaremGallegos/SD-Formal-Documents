#import "fd-general-report/copyright.typ": *
#import "fd-general-report/frontpage-FD.typ": *
#import "fd-general-report/lastpage-FD.typ": *
#import "preamble.typ": *

#let hide-formalities = false
#let fd-general-report(
  title: "", description: "", authors: (), date: none, educational-center: "",
  department: "", department-full-title: "", address-i: "", address-ii: "",
  department-website: "", before: (), frontpage-input: none, background-color: rgb("#224ea9"),
  body
) = {
  // FRONTPAGE
  if frontpage-input == none {
    show: front-page.with(
      title: title,
      description: description,
      authors: authors,
      date: date,
      educational-center: educational-center,
      department: department,
      department-full-title: department-full-title,
    )
  } else {
    frontpage-input
  }

  // SETUP
  set text(size: 10pt, fill: block)
  set document(author: authors, title: title)
  set page(numbering: none, number-align: center, fill: none, margin: auto)
  set par(leading: 0.65em)
  set heading(numbering: none)
  show heading: set block(above: 1.4em, below: 1em)

  // FORMALITIES
  if not hide-formalities {
    show: copyright.with(
      title: title,
      description: description,
      authors: authors,
      date: date,
      educational-center: educational-center,
      department: department,
      department-full-title: department-full-title,
      address-i: address-i,
      address-ii: address-ii,
    )

    set page(numbering: "i", number-align: center)
    counter(page).update(1)
    include-files(before)
    pagebreak()
  } else {
    set page(numbering: "i", number-align: center)
    counter(page).update(1)
    before.contents
  }

  // MAIN
  set page(numbering: "1", numbering-align: center)
  set heading(numbering: "1.1")
  counter(page).update(1)
  set par(justify: true)
  set text(hyphenate: false)
  
  // CUSTOM HEADING
  show heading.where(level: 1): it => custom-heading(it)
  set page(footer: context {
    if calc.rem(here().page(), 2) == 0 [
      #text(current-h(level: 1)) #h(1fr) #counter(page).display()
    ] else [
      #counter(page).display() #h(1fr) #text(current-h(level: 1))
    ]
  })

  // BODY
  body

  // LAST PAGE
  show: last-page.with(
    department: department,
    educational-center: educational-center,
    address-i: address-i,
    address-ii: address-ii,
    department-website: department-website,
    background-color: background-color
  )
}