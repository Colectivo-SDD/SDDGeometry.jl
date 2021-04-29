
abstract type AbstractCurve2D end
abstract type AbstractCircularLinearCurve <: AbstractCurve2D end

abstract type AbstractLinearCurve <: AbstractCircularLinearCurve end
abstract type AbstractLine <: AbstractLinearCurve end
abstract type AbstractRay <: AbstractLinearCurve end
abstract type AbstractLineSegment <: AbstractLinearCurve end

abstract type AbstractCircularCurve <: AbstractCircularLinearCurve end
abstract type AbstractCircle <: AbstractCircularCurve end
abstract type AbstractArc <: AbstractCircularCurve end
