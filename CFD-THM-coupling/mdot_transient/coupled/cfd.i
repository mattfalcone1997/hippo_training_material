[Mesh]
    type = FoamMesh
    case = 'foam_cfd'
    foam_patch = 'inlet outlet pipe'
[]


[Problem]
    type = FoamProblem
    library_path = /home/mfalcone/software_development/hippo/hippo/lib
    library_name = libhippo-opt.la
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
    [m_dot]
        type = FoamMassFlowRateMappedInletBC
        boundary = inlet
        translation_vector = '0 0 0.5'
    []
    [T_inlet]
        type = FoamFixedValuePostprocessorBC
        boundary = inlet
        foam_variable = 'T'
    []
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