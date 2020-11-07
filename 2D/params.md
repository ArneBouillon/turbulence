# Interesting parameter combinations

## `&methodlist`

```properties
time_stepper='twostep' | 'onestep' | 'threestep' | 'fourstep' | 'fivestep'
time_integrator= choices depend on time_stepper
```

Temporal discretisation, Couette uses `'fourstep'`.
`'onestep'` might be interesting in combination with `'tvd'` (see below).
Fourth order Runge-Kutta type method, when `time_stepper='fourstep'` and `time_integrator='rk4'` and `dimsplit= T`.



```properties
flux_scheme= nlevelshi * strings from: 'tvdlf' (default) | 'hll' | 'hllc' | 'tvd' | 'tvdmu' | 'fd'
```

Spacial discretisation, Couette uses `13*'hll'`.
`'hllc'`  is designed for HD, so we should try that one out.
`'tvdlf'` maybe too diffusive to resolve details, so might give bad results. So let's check this out as well, it might be good to discuss bad results as well(?).
`'tvd'` [^1] should be *one of the most accurate and efficient*. This method also uses central differencing (like the paper does, but of higher order).
The integer `nlevelshi` is the maximum number of levels in the grid refinement. The default AMRVAC setting for this is 20. Run simulations for 1, (5 or 10) and 20?
`'flux_scheme'` can be given an array as argument, to use different discretisations on different activated grid levels.

```properties
limiter= nlevelshi * strings from: 'minmod' (default) | 'woodward' | 'superbee' | 'vanleer' | 'albada' | 'ppm' | 'mcbeta' | 'koren' | 'cada' | 'cada3' | 'mp5'
```

This is for suppressing numerical oscillations, Couette uses `13*'koren'` .
[This](http://amrvac.org/md_doc_limiter.html) explains the limiters. It does not go into a lot of detail, `'koren'` (third order) should be pretty diffusive, so maybe we can test that against some other limiter. `'cada3'` is third order as well, is recommended over `'koren'` when using third order limiters, but is asymmetric. All limiters listed above are TVD.
We can also give an array as argument here, like above.

## `&meshlist`

```properties
refine_max_level= INTEGER
```

Set this to 1 to disable AMR. Should maximally be equal to `nlevelshi` from above.

```properties
amr_wavefilter= nlevelshi DOUBLE values
refine_threshold= nlevelshi DOUBLE values
```

> When `refine_criterion=0`, all refinement will only be based on the user- defined criteria to be coded up in subroutine *specialrefine_grid*.
>
> When `refine_criterion=1`, we simply compare the previous  time level t_(n-1) solution with the present t_n values, and trigger  refinement on relative differences.
>
> When `refine_criterion=3`, the default value, errors are  estimated using current t_n values and their gradients following Lohner  prescription. In this scheme, the `amr_wavefilter`  coefficient can be adjusted from its default value 0.01d0. You can set  different values for the wavefilter coefficient per grid level. This  error estimator is computationally efficient, and has shown similar  accuracy to the Richardson approach on a variety of test problems. When `refine_criterion=3`, the original Lohner method is used.
>
> A call to the user defined subroutine *usr_refine_grid*  follows the error estimator, making it possible to use this routine for  augmented user-controlled refinement, or even derefinement.
>
> Depending on the error estimator used, it is needed or advisable to  additionally provide a buffer zone of a certain number of grid cells in  width, which will surround cells that are flagged for refinement by any  other means. It will thus trigger more finer grids. `nbufferx^D=2` is usually sufficient. It can never be greater than the block size. For Lohner scheme, the buffer can actually be turned off completely by  setting `nbufferx^D=0` which is default value.

Maybe just use one trying `refine_criterion=1` and compare this to the default? I don't think it's worth it to define our own refine criterion. What do you think?


[^1]: when using `'tvd'`, we can also specify

```properties
typetvd= 'roe' (default) | 'yee' | 'harten' | 'sweby'
```

I don't think this is really that interesting, other parameters seem more interesting to play with.