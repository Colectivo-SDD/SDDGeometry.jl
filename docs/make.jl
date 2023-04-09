push!(LOAD_PATH, "./../../")
using SDDGeometry

using Documenter

makedocs(
    modules = [SDDGeometry], # Lista de módulos a documentar
    sitename = "SDDGeometry.jl", # Nombre del documento
    authors = "Colectivo SDD, Facultad de Ciencias, UNAM", # Autores
    #root    = "<current-directory>", # Carpeta raiz donde se ejecuta este script
    #source  = "src", # Carpeta con archivos fuente
    #build   = "build", # Carpeta con la construcción
    clean = true, # Indica si debe limpiarse la carpeta build antes de construir
    pages = ["Home" => "index.md", "Other Pages" => ["other1.md", "other2.md"] ], # Páginas y navegación
    highlightsig = true, # Usar resaltamiento de código para el primer párrafo
    doctest = false, # Realizar pruebas de código dentro de documentación
    #expandfirst = [],
    #format = DocumenterHTML(...) # Formato de salida
    format = Documenter.HTML(prettyurls = false)
)
