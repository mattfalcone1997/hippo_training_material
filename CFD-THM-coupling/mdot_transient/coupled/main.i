T_in = 300
D = 0.05
A = ${fparse pi*0.25*D*D}
press = 101325

[MultiApps]
    [hippo]
        type = TransientMultiApp
        app_type = hippoApp
        execute_on = timestep_end
        input_files = 'cfd.i'
        sub_cycling = true
    []
[]

# Transfer postprocessors to-and-from CFD simulation
[Transfers]
    [mdot_from_cfd]
        type = MultiAppPostprocessorTransfer
        from_multi_app = hippo
        from_postprocessor = mdot_outlet
        to_postprocessor = mdot_interface_in
        reduction_type=average
    []
    [T_from_cfd]
        type = MultiAppPostprocessorTransfer
        from_multi_app = hippo
        from_postprocessor = T_outlet
        to_postprocessor = T_interface_in
        reduction_type=average
    []
    [p_to_cfd]
        type= MultiAppPostprocessorTransfer
        to_multi_app = hippo
        from_postprocessor = p_interface_in
        to_postprocessor = p_outlet
    []
    [mdot_to_cfd]
        type = MultiAppPostprocessorTransfer
        to_multi_app = hippo
        from_postprocessor = mdot_interface_out
        to_postprocessor = m_dot
    []
    [T_to_cfd]
        type = MultiAppPostprocessorTransfer
        to_multi_app = hippo
        from_postprocessor = T_interface_out
        to_postprocessor = T_inlet
    []
    [p_from_cfd]
        type= MultiAppPostprocessorTransfer
        from_multi_app = hippo
        from_postprocessor = p_avg
        to_postprocessor = p_interface_out
        reduction_type=average
    []
[]

# Impose postprocessors transferred from OpenFOAM onto the component parameters
# for the inlet and the outlet
[ControlLogic]
  [T_interface_in]
    type = SetComponentRealValueControl
    component = interface_in
    parameter = T
    value = T_interface_in
  []
  [mdot_interface_in]
    type = SetComponentRealValueControl
    component = interface_in
    parameter = m_dot
    value = mdot_interface_in
  []
  [p_interface_out]
    type = SetComponentRealValueControl
    component = interface_out
    parameter = p
    value = p_interface_out
  []
  # Impose parsed postprocessor to induce mass flow rate transient
  [mdot_inlet]
    type = SetComponentRealValueControl
    component = inlet
    parameter = m_dot
    value = mdot_inlt
  []
[]

# Receivers used as 'targets' for postprocessor transfers
[Postprocessors]
  [mdot_interface_in]
    type = Receiver
    default = 3.92
  []
  [T_interface_in]
    type = Receiver
    default = 300
  []
  [p_interface_out]
    type = Receiver
    default = ${press}
  []
  # Calculate averaged to be sent to OpenFOAM
  [p_interface_in]
    type = SideAverageValue
    boundary = pipe2:in
    variable = T
  []
  [T_interface_out]
    type = SideAverageValue
    boundary = pipe1:out
    variable = T
    execute_on = "INITIAL TIMESTEP_BEGIN"
  []
  # Calculate mass flow rate for the OpenFOAM inlet BC
  [mdot_interface_out]
    type = ADFlowBoundaryFlux1Phase
    boundary = interface_out
    equation = mass
    execute_on = "INITIAL TIMESTEP_BEGIN"
  []
  # Doubles inlet mass flow rate from 0.6s to 0.8s
  [mdot_inlt]
    type = ParsedPostprocessor
    expression = 'if(t<0.6, 3.92, if(t<0.8, 3.92+19.6*(t-0.6), 7.84))'
    use_t = true
    execute_on = "INITIAL TIMESTEP_BEGIN"
  []
[]

[GlobalParams]
  initial_p = ${press}
  initial_vel = 2
  initial_T = ${T_in}
  closures = thm_closures
  fp = water
  gravity_vector = '0 -9.81 0'
[]

# Variable properties must be used, not we have treated the CFD and constant density
[FluidProperties]
  [water]
    type = SimpleFluidProperties
    density0 = 1065
  []
[]

[Closures] # defines friction factors and heat transfer coefficients
  [thm_closures]
    type = Closures1PhaseTHM # default Churchill friction factor, DB HTC
  []
[]

[Components]
    [inlet]
        type = InletMassFlowRateTemperature1Phase
        T = 300
        m_dot = 3.92
        input = pipe1:in
    []
    [pipe1]
        type = FlowChannel1Phase
        position = '0 0 -1'
        orientation = '0 0 1'
        length = 1
        n_elems = 100
        A = ${A}
        D_h = ${D}
    []
    # interface_* where pp calculated from OpenFOAM are 'imposed'
    [interface_out]
        type =Outlet1Phase
        input = pipe1:out
        p = ${press}
    []
    [interface_in]
        type = InletMassFlowRateTemperature1Phase
        T = 300
        m_dot = 3.92
        input = pipe2:in
    []
    [pipe2]
        type = FlowChannel1Phase
        position = '0 0 1'
        orientation = '0 0 1'
        length = 1
        n_elems = 100
        A = ${A}
        D_h = ${D}
    []
    [outlet]
        type =Outlet1Phase
        input = pipe2:out
        p = ${press}
    []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  start_time = 0

  dt = 0.01
  end_time = 1.

  line_search = basic
  solve_type = NEWTON

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 25

[]

[Outputs]
  csv=true
  [out]
    type = Exodus
    min_simulation_time_interval = 0.01
  []

  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
