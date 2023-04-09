
"Geometry utils for the SDD ecosystem."
module SDDGeometry

import Base: show


include("coordinates.jl")


include("utils.jl")

export
    dot,
    perp,
    complexU,
    complexpolar


include("distances.jl")

export
    euclideandistance2D,
    euclideandistance3D,
    euclideandistance,
    manhattandistance2D,
    manhattandistance3D,
    manhattandistance,
    maxdistance2D,
    maxdistance3D,
    maxdistance
    #chordaldistance
    #sphericdistance
    #hyperbolicdistanceD
    #hyperbolicdistanceH2
    #hyperbolicdistanceH3


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


#include("stereographicprojections.jl")


include("mobiustransformations.jl")
include("inversions.jl")

export # ToDo: Refactoring Names!!!!
    AbstractComplexInvertibleFunction,
    AbstractMobiusTransformation,
    MobiusTransformation,
    #MobT
    AbstractAffineTransformation, #AbstractMobiusAffineTransformation
    LinearTransformation, #MobiusLinearTransformation
    #MobLinT,
    Translation, #MobiusTranslation
    #MobTranslation,
    AffineTransformation, #MobiusAffineTranslation
    #MobAffT,
    InversionReflection,
    #InvRef,
    AbstractInversion,
    CircleInversion,
    Reflection, #ComplexReflection
    #ComplexRef,
    #a, b, c, d, r, p, θ,
    inverse,
    derivative,
    fixedpoints,
    kind,
    tr,
    #tr2,
    det,
    compose,
    ∘,
    maptozerooneinf,
    mapfromzerooneinf


# include("affinetransformations.jl")

# export
    #AbstractAffineTransformation,
    #AffineTransformation,
    #AffT,
    #Translation
    #AbstractLinearTransformation,
    #LinearTransformation,
    #LinT
    #Homothety,
    #Rotation,
    #Rot,
    #Reflection,
    #Ref,
    #inverse,
    #derivative,
    #tr,
    #tr2,
    #det,
    #compose,
    #∘


include("rectregion.jl")

export
    RectRegion,
    RectRegion3D,
    isinside,
    isinsideclosed,
    #isinsidemax,
    tomatrixindex,
    torot90matrixindex,
    tocubeindex

end # module
