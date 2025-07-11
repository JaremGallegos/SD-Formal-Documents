#import "../../../src/lib.typ": *

#set text(font: "Carlito", lang: "es")
#show: fd-general-report.with(
  title: "Modelado de la Unidad Lógica Aritmético (ALU) en Arquitecturas Von Neumann Empleando una Máquina de Turing para la Implementación de la Operación de Conjunción (AND)",
  description: "Producto Académico 3",
  authors: (
    "Gallegos Yanarico, Jarem Joseph (GRUPO B) - Único Participante del Producto",
  ),
  date: datetime.today().display("[day] [month repr:long] [year]"),
  course: "Teoría de la Computación",
  department: "Universidad Continental",
  department-full-title: "Curso Especializado de Carrera",
  address-i: "La Canseco II Valle Chili \nJosé Luis Bustamante y Rivero",
  address-ii: "(054) 412030",
  department-website: "www.ucontinental.edu.pe",

  before: (
    contents: include "sections/preface/contents.typ"
  ),
)
#include "sections/introduction.typ"
#include "sections/marco-teorico.typ"
#include "sections/desarrollo.typ"
#include "sections/resultados.typ"
#include "sections/conclusion.typ"
#include "sections/bibliografia.typ"
#include "sections/anexos.typ"

#pagebreak()