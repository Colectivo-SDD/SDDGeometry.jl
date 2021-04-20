
"Geometry utils for the SDD ecosystem."
module SDDGeometry

include("utils.jl")

export
    dot,
    perp


include("curve2d.jl")
include("lines.jl")
include("circles.jl")

export
    AbstractCurve2D,
    AbstractLinearCircularCurve,
    AbstractLinearCurve,
    AbstractCircularCurve,
    Line,
    #Ray,
    LineSegment,
    initialpoint,
    finalpoint,
    linepoints,
    linecomplexes,
    Circle,
    CircularArc,
    CLine,
    center,
    radius,
    radius2,
    isinside,
    isoutside,
    circlepoints,
    circlecomplexes


#include("intersections.jl")
#include("lengths.jl")
#include("metrics.jl")
#include("stereographicprojections.jl")


include("mobiustransformation.jl")

export
    AbstractMobiusTransformation,
    MobiusTransformation,
    LinearTransformation,
    Translation,
    AffineTransformation,
    InversionReflection,
    inverse,
    derivative,
    fixedpoints,
    kind,
    tr,
    det,
    compose,
    ∘,
    maptozerooneinf,
    mapfromzerooneinf


#include("inversions.jl")


end # module
