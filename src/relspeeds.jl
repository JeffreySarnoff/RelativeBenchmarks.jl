
#=
    `relspeed` determines the datatype-relative performance of a function
    -  (speedof fn(data::TypeA)) / (speedof fn(data::TypeB))
    -  TypeB(TypeA(data)) == TypeB(data)
    -  TypeA(TypeB(data)) == TypeA(data)
    -  (speedof fn(xdata::TypeA, ydata::T)) / (speedof fn(xdata::TypeB, ydata::T)) where T
    -  TypeB(TypeA(data)) == TypeB(data)
    -  TypeA(TypeB(data)) == TypeA(data)
    -  (speedof fn(xdata::TypeA, ydata::TypeB)) / (speedof fn(xdata::TypeC, ydata::TypeD)) where ..
    -  TypeA(TypeC(xdata)) == TypeA(xdata) && TypeC(TypeA(xdata)) == TypeC(xdata)
    -  TypeB(TypeD(ydata)) == TypeB(ydata) && TypeD(TypeB(ydata)) == TypeD(ydata)
=#

function relspeed(fn, xs, ys; digits::Int=2, broadcasted::Bool=false)
    reltime = if broadcasted
                   relspeed_broadcast_fn(fn, xs, ys)
               else
                   relspeed_apply_fn(fn, xs, ys)
               end
    return round(Float64(reltime), digits=digits)
end

function relspeed(fn, x1s, x2s, y1s, y2s; digits::Int=2, broadcasted::Bool=false)
    reltime = if broadcasted
                  relspeed_broadcast_fn(fn, x1s, x2s, y1s, y2s)
              else
                  relspeed_apply_fn(fn, x1s, x2s, y1s, y2s)
              end
    return round(Float64(reltime), digits=digits)
end

function relspeed_apply_fn(fn, xs, ys)
    xstime = @refd @belapsed ($(fn))($(xs))
    ystime = @refd @belapsed ($(fn))($(ys))
    return Float32(xstime) / Float32(ystime)
end

function relspeed_broadcast_fn(fn, xs, ys)
    xstime = @refd @belapsed ($(fn)).($(xs))
    ystime = @refd @belapsed ($(fn)).($(ys))
    return Float32(xstime) / Float32(ystime)
end

function relspeed_apply_fn(fn, x1s, x2s, y1s, y2s)
    xstime = @refd @belapsed ($(fn))(($(x1s)), ($(x2s)))
    ystime = @refd @belapsed ($(fn))(($(y1s)), ($(y2s)))
    return Float32(xstime) / Float32(ystime)
end

function relspeed_broadcast_fn(fn, x1s, x2s, y1s, y2s)
    xstime = @refd @belapsed ($(fn)).(($(x1s)), ($(x2s)))
    ystime = @refd @belapsed ($(fn)).(($(y1s)), ($(y2s)))
    return Float32(xstime) / Float32(ystime)
end
