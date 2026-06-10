[Mesh]
    type = FoamMesh
    case = 'foam_cfd'
    foam_patch = 'inlet outlet pipe'
[]


[Problem]
    type = FoamProblem
[]

[Executioner]
    type = Transient
    [TimeSteppers]
        [foam]
            type = FoamTimeStepper
        []
    []
[]

[FoamBCs]
    # Mapped inlet weighted by postprocessor of name mdot
    [mdot_inlet]
        type = FoamMassFlowRateMappedInletBC
        boundary = inlet
        translation_vector = '0 0 0.5'
    []
    # Impose uniform temperature on the inlet
    [T_inlet]
        type = FoamFixedValuePostprocessorBC
        boundary = inlet
        foam_variable = 'T'
    []
    # Impose uniform pressure of the outlet
    [p_outlet]
        type = FoamFixedValuePostprocessorBC
        boundary = outlet
        foam_variable = 'p'
    []
[]

[Postprocessors]
    [mdot_outlet]
        type = FoamSideAdvectiveFluxIntegral
        foam_scalar = rho
        boundary = 'outlet'
    []
    [T_outlet]
        type = FoamSideAverageValue
        foam_variable = T
        boundary = 'outlet'
    []
    [p_avg]
        type = FoamSideAverageValue
        foam_variable = p
        boundary = 'inlet'
    []
[]

[Outputs]
    exodus = false
[]
