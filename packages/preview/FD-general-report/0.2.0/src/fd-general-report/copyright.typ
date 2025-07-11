#let copyright(
  title: "", description: "", authors: (), date: none, course: "", educational-center: "",
  department: "", department-full-title: "", address-i: "", address-ii: "", body
) = {
  set page(margin: auto)
  v(1fr) 
  text(weight: "bold", title)
  v(0.1em)
  text(course + " / " + date)
  v(1em)
  text("Por")  
  v(-5pt)
  grid(gutter: 5pt, ..authors)
  v(1em)
  grid(
    columns: (auto, 1fr), rows: (auto, auto, auto), gutter: 1em, row-gutter: 1em,
      [Copyright:], [El desarrollo y diseño del presente proyecto están protegidos por derechos de autor. Todos los derechos están reservados a favor del autor Gallegos Yanarico, Jarem Joseph, con algunos derechos restringidos bajo licencia Creative Commons (CC)],
      [Foto de Portada:], [Universidad Continental sede central Huancayo, 2025])
  pagebreak()
  body
} 