
"Geometry utils for the SDD ecosystem."
module SDDGeometry

import Base: show


include("utils.jl")

export
    dot,
    perp,
    complexU


include("abstractcurves.jl")
include("lines.jl")
include("circles.jl")

export
    AbstractCurve2D,
    AbstractCircularLinearCurve,
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
    pickpoint,
    circlepoints,
    circlecomplexes,
    distance,
    signeddistance,
    nearestpoint


#include("discs.jl")

#export
#    AbstractDisc,
#    Disc,
#    HemiPlane
#    isinside,
#    isoutside,


#include("intersections.jl")
#include("lengths.jl")
#include("metrics.jl")
#include("stereographicprojections.jl")


include("mobiustransformations.jl")
include("inversions.jl")

export
    AbstractComplexInvertibleFunction,
    AbstractMobiusTransformation,
    MobiusTransformation,
    AbstractAffineTransformation,
    LinearTransformation,
    Translation,
    AffineTransformation,
    InversionReflection,
    AbstractInversion,
    CircleInversion,
    Reflection,
    #a, b, c, d, r, p, θ,
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

end # module
