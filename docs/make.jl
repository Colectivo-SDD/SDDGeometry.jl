push!(LOAD_PATH, "./../src/")
using SDDGeometry

using Documenter
makedocs(
    modules = [SDDGeometry],
    sitename = "SDDGeometry Reference",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        warn_outdated = true,
        collapselevel=1,
        )
)
