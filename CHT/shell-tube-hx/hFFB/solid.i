[Mesh]
    type = FileMesh
    file = 'solid.exo'
[]

[Variables]
    [T]
        family = LAGRANGE
        order = FIRST
        initial_condition = 300
    []
[]

[Kernels]
    [heat-conduction]
        type = ADHeatConduction
        variable = T
    []
[]

[BCs]
    [inner]
        type = CoupledConvectiveHeatFluxBC
        variable = T
        boundary = inner
        T_infinity = bulk_t_inner
        htc = inner_htc
    []

    [outer]
        type = CoupledConvectiveHeatFluxBC
        variable = T
        boundary = outer
        T_infinity = bulk_t_outer
        htc = outer_htc
    []
[]

[Functions]
    [cp_func]
        type=ParsedFunction
        expression = 'if(t<50, 0.385, 385)'
    []
[]
[Materials]
    # Solid material properties for copper
    [thermal-conduction]
        type = ADGenericConstantMaterial
        prop_names = 'thermal_conductivity density'
        prop_values = '401 8960'  # W/(m.K) kg/m^3
    []
    [specific-heat]
        type=ADGenericFunctionMaterial
        prop_names = 'specific_heat'
        prop_values = cp_func
    []
[]
[Executioner]
    type = Transient
    start_time = 0
    end_time = 500
    dt = 2.

    solve_type = NEWTON
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'
    nl_rel_tol = 1e-7
    l_tol = 1e-8
    nl_abs_tol = 1e-7
    steady_state_detection = true
    steady_state_tolerance = 1e-4
[]

[Outputs]
    exodus = true
[]

[MultiApps]
    [inner]
        type = TransientMultiApp
        app_type = hippoApp
        execute_on = timestep_begin
        input_files = 'inner.i'
        sub_cycling = true
    []
    [outer]
        type = TransientMultiApp
        app_type = hippoApp
        execute_on = timestep_begin
        input_files = 'outer.i'
        sub_cycling = true
    []
[]

[AuxVariables]
    [inner_htc]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
    []
    [outer_htc]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 0
    []
    [wall_temp]
        family = MONOMIAL
        order = CONSTANT
        initial_condition = 300
    []
    [bulk_t_inner]
        family = MONOMIAL
        order = CONSTANT
    []
    [bulk_t_outer]
        family = MONOMIAL
        order = CONSTANT
    []
[]

[AuxKernels]
    [wall_temp]
        type = ProjectionAux
        variable = wall_temp
        v = T
        boundary = 'inner outer'
        check_boundary_restricted = false
    []
[]

[Transfers]
    [wall_temperature_to_inner]
        type = MultiAppGeneralFieldNearestLocationTransfer
        source_variable = wall_temp
        to_multi_app = inner
        variable = solid_wall_temp
        execute_on = same_as_multiapp
        from_boundaries = 'inner'
    []

    [wall_temperature_to_outer]
        type = MultiAppGeneralFieldNearestLocationTransfer
        source_variable = wall_temp
        to_multi_app = outer
        variable = solid_wall_temp
        execute_on = same_as_multiapp
        from_boundaries = 'outer'
    []

    [htc_from_inner]
        type = MultiAppGeneralFieldNearestLocationTransfer
        source_variable = fluid_htc
        from_multi_app = inner
        variable = inner_htc
        execute_on = same_as_multiapp
        to_boundaries = 'inner'
    []

    [htc_from_outer]
        type = MultiAppGeneralFieldNearestLocationTransfer
        source_variable = fluid_htc
        from_multi_app = outer
        variable = outer_htc
        execute_on = same_as_multiapp
        to_boundaries = 'outer'
        search_value_conflicts=false
    []
    [bulk_from_inner]
        type = MultiAppGeneralFieldUserObjectTransfer
        source_user_object = bulk_t
        from_multi_app = inner
        variable = bulk_t_inner
#        bbox_factor = 2.
        to_boundaries = 'inner'
        greedy_search = false
    []
    [bulk_from_outer]
        type = MultiAppGeneralFieldUserObjectTransfer
        source_user_object = bulk_t
        from_multi_app = outer
        variable = bulk_t_outer
 #       bbox_factor = 2.
        to_boundaries = 'outer'
        greedy_search = true
        use_bounding_boxes = false
    []
[]
