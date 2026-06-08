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
        pp_name = mdot_inlet
        translation_vector = '0 0 0.5'
    []
    [T_inlet]
        type = FoamFixedValueBC
        boundary = inlet
        foam_variable = 'T'
    []
    [p_outlet]
        type = FoamFixedValueBC
        boundary = outlet
        foam_variable = 'p'
    []
[]

[AuxKernels]
    [T_inlet]
        type= FunctionAux
        variable = T_inlet
        function = T_inlet
        execute_on = TIMESTEP_BEGIN
    []
    [p_outlet]
        type= FunctionAux
        variable = p_outlet
        function = p_outlet
        execute_on = TIMESTEP_BEGIN
    []
[]
[Functions]
    [T_inlet]
        type = ParsedFunction
        expression = 'pp'
        symbol_names = 'pp'
        symbol_values = T_inlt_pp
    []
    [p_outlet]
        type = ParsedFunction
        expression = 'pp'
        symbol_names = 'pp'
        symbol_values = p_outlet
    []
[]

[Postprocessors]
    [mdot_inlet]
        type = Receiver
        default = 3.92
    []
    [T_inlt_pp]
        type = Receiver
        default = 300
    []
    [p_outlet]
        type = Receiver
        default = 101325
    []
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
