
"Geometry utils for the SDD ecosystem."
module SDDGeometry

include("utils.jl")

export
    dot,
    perp


include("abstractcurves.jl")
include("lines.jl")
include("circles.jl")

export
    AbstractCurve2D,
    AbstractLinearCircularCurve,
    AbstractLinearCurve,
    AbstractCircularCurve,
    Line,
    Ray,
    LineSegment,
    basepoint,
    angle,
    normal,
    initialpoint,
    finalpoint,
    linepoints,
    linecomplexes,
    isinside,
    isoutside,
    Circle,
    CircularArc,
    CLine,
    center,
    radius,
    radius2,
    circlepoints,
    circlecomplexes


#include("intersections.jl")
#include("lengths.jl")
#include("metrics.jl")
#include("stereographicprojections.jl")


include("mobiustransformations.jl")

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
