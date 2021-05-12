
"Geometry utils for the SDD ecosystem."
module SDDGeometry

import Base: show


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
    AbstractLine,
    AbstractRay,
    AbstractLineSegment,
    AbstractCircularCurve,
    AbstractCircle,
    AbstractArc,
    Line,
    Ray,
    LineSegment,
    basepoint,
    basepointC,
    basepointR2,
    lineangle,
    normal,
    normalC,
    normalR2,
    initialpoint,
    finalpoint,
    initialpointC,
    finalpointC,
    initialpointR2,
    finalpointR2,
    linepoints,
    linecomplexes,
    isinside,
    isoutside,
    Circle,
    Arc,
    #CLine,
    center,
    centerC,
    centerR2,
    centerx,
    centery,
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
    #a, b, c, d,
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
#export

end # module
