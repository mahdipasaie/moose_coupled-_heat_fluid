[Mesh]
    [./gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 0.1   # 10 cm in meters
    ymin = 0
    ymax = 0.1   # 10 cm in meters
    nx = 100
    ny = 100
    [../]
[]
  

[Variables]
    [./T]
      order = FIRST
      family = LAGRANGE
    [../]   
[]

[AuxVariables]
  [./ut]
  [../]
  [./vt]
  [../]
[]

[Kernels]
    [./conduction]
      type = heat1  
      variable = T
      thermal_conductivity = 0.026  # Thermal conductivity of air in W/(m·K)
    [../]
    [./timeder]
        type = heat2
        variable = T
        rho = 1.1405
        cp = 1005
    [../]
    [./advection]
        type = heat3
        variable = T
        rho = 1.1405
        cp = 1005
        v = ut
        u = vt
    [../]
[]

[ICs]
    # Initial condition for the temperature across the domain
    [./initial_temperature]
      type = FunctionIC
      variable = T
      function = '290'  # Starting temperature for the entire domain in Kelvin
    [../]
[]

[BCs]
    # Hot wall
    [./left_hot_wall]
      type = DirichletBC
      variable = T
      boundary = 'left'
      value = 305 
    [../]
    # Cold wall
    [./right_cold_wall]
      type = DirichletBC
      variable = T
      boundary = 'right'
      value = 290  
    [../]
    # Insulated walls (no heat flux)
    [./top_insulated]
      type = NeumannBC
      variable = T
      boundary = 'top'
      value = 0 
    [../]
    [./bottom_insulated]
      type = NeumannBC
      variable = T
      boundary = 'bottom'
      value = 0  
    [../]
[]

[Executioner]
    type = Transient
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -pc_factor_shift_type'
    petsc_options_value = 'lu NONZERO'
    nl_rel_tol = 1e-8
    dt = 0.01       # Initial time step size
    end_time = 10   # Total simulation time
[]
  
  
[Outputs]
    exodus = true
[]


[MultiApps]
  [./fluid]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'fluid_flow.i'
  [../]
[]

[Transfers]
  [./utrans]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = fluid
    source_variable = vel_x
    variable = ut
  [../]
  [./vtrans]
      type = MultiAppGeometricInterpolationTransfer
      from_multi_app = fluid
      source_variable = vel_y
      variable = vt
  [../]
  [./Ttrans]
    type = MultiAppGeometricInterpolationTransfer
    to_multi_app = fluid
    source_variable = T
    variable = Tf 
  [../]
[]