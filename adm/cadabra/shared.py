import cadabra2
from cadabra2_defaults import *
__cdbkernel__ = cadabra2.__cdbkernel__

__cdbtmp__ = Coordinate(Ex(r'''{x,y,z}'''), Ex(r'''''') )
__cdbtmp__ = Indices(Ex(r'''{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u#}'''), Ex(r'''values={x,y,z},position=independent)''') )

__cdbtmp__ = Symbol(Ex(r''';'''), Ex(r'''''') ); display(__cdbtmp__)
# Cadabra doesn't allow | as a ::Symbol so we use this trick
__cdbtmp__ = LaTeXForm(Ex(r''';'''), Ex(r'''"{\vert}"}''') )

__cdbtmp__ = PartialDerivative(Ex(r'''\partial{#}'''), Ex(r'''''') ); display(__cdbtmp__)

__cdbtmp__ = Metric(Ex(r'''g_{a b}'''), Ex(r'''''') ); display(__cdbtmp__)
__cdbtmp__ = InverseMetric(Ex(r'''g^{a b}'''), Ex(r'''''') ); display(__cdbtmp__)

__cdbtmp__ = Symmetric(Ex(r'''K_{a b}'''), Ex(r'''''') )
__cdbtmp__ = Symmetric(Ex(r'''R_{a b}'''), Ex(r'''''') )

__cdbtmp__ = RiemannTensor(Ex(r'''R_{a b c d}'''), Ex(r'''''') )
__cdbtmp__ = RiemannTensor(Ex(r'''R^{a}_{b c d}'''), Ex(r'''''') )

__cdbtmp__ = Depends(Ex(r'''g_{a b}'''), Ex(r'''t,x,y,z)''') )
__cdbtmp__ = Depends(Ex(r'''g^{a b}'''), Ex(r'''t,x,y,z)''') )

__cdbtmp__ = Depends(Ex(r'''K_{a b}'''), Ex(r'''t,x,y,z)''') )
__cdbtmp__ = Depends(Ex(r'''K^{a b}'''), Ex(r'''t,x,y,z)''') )

__cdbtmp__ = Depends(Ex(r'''N'''), Ex(r'''t,x,y,z)''') )

__cdbtmp__ = LaTeXForm(Ex(r'''trK'''), Ex(r'''"{{\rm tr} K}")''') )
__cdbtmp__ = LaTeXForm(Ex(r'''Ham'''), Ex(r'''"{\cal H}")''') )
__cdbtmp__ = LaTeXForm(Ex(r'''Mom{#}'''), Ex(r'''"{\cal D}")''') )

def product_sort (ex):
    substitute (ex,Ex(r''' N                            -> A001           ''', False))
    substitute (ex,Ex(r''' trK                          -> A002           ''', False))
    substitute (ex,Ex(r''' g_{a b}                      -> A003_{a b}     ''', False))
    substitute (ex,Ex(r''' g^{a b}                      -> A004^{a b}     ''', False))
    substitute (ex,Ex(r''' K_{a b}                      -> A005_{a b}     ''', False))
    substitute (ex,Ex(r''' K^{a b}                      -> A006^{a b}     ''', False))
    substitute (ex,Ex(r''' R_{a b}                      -> A007_{a b}     ''', False))
    substitute (ex,Ex(r''' R^{a b}                      -> A008^{a b}     ''', False))
    substitute (ex,Ex(r''' Gamma^{a}_{b c}              -> A009^{a}_{b c} ''', False))
    substitute (ex,Ex(r''' \partial_{a}{N}              -> A010_{a}       ''', False))
    substitute (ex,Ex(r''' \partial_{a b}{N}            -> A011_{a b}     ''', False))
    substitute (ex,Ex(r''' \partial_{a}{g_{c d}}        -> A012_{a c d}   ''', False))
    substitute (ex,Ex(r''' \partial_{a}{g^{c d}}        -> A013_{a}^{c d} ''', False))
    substitute (ex,Ex(r''' \partial_{a b}{g_{c d}}      -> A014_{a b c d} ''', False))
    sort_product   (ex)
    rename_dummies (ex)
    substitute (ex,Ex(r'''A001                    -> N                           ''', False))
    substitute (ex,Ex(r'''A002                    -> trK                         ''', False))
    substitute (ex,Ex(r'''A003_{a b}              -> g_{a b}                     ''', False))
    substitute (ex,Ex(r'''A004^{a b}              -> g^{a b}                     ''', False))
    substitute (ex,Ex(r'''A005_{a b}              -> K_{a b}                     ''', False))
    substitute (ex,Ex(r'''A006^{a b}              -> K^{a b}                     ''', False))
    substitute (ex,Ex(r'''A007_{a b}              -> R_{a b}                     ''', False))
    substitute (ex,Ex(r'''A008^{a b}              -> R^{a b}                     ''', False))
    substitute (ex,Ex(r'''A009^{a}_{b c}          -> Gamma^{a}_{b c}             ''', False))
    substitute (ex,Ex(r'''A010_{a}                -> \partial_{a}{N}             ''', False))
    substitute (ex,Ex(r'''A011_{a b}              -> \partial_{a b}{N}           ''', False))
    substitute (ex,Ex(r'''A012_{a c d}            -> \partial_{a}{g_{c d}}       ''', False))
    substitute (ex,Ex(r'''A013_{a}^{c d}          -> \partial_{a}{g^{c d}}       ''', False))
    substitute (ex,Ex(r'''A014_{a b c d}          -> \partial_{a b}{g_{c d}}     ''', False))
    return ex
