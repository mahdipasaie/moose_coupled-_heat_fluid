#include "heat2.h"

registerMooseObject("hfApp", heat2);

InputParameters
heat2::validParams()
{
    InputParameters params = ADTimeKernelValue::validParams();
    params.addClassDescription("Implements the time derivative term.");
    params.addParam<Real>("rho", 1.1405, "Coefficient _rho kg/m^3.");
    params.addParam<Real>("cp", 1005, "Coefficient _cp .");
    return params;
}

heat2::heat2(const InputParameters & parameters)
  : ADTimeKernelValue(parameters),
    _rho(getParam<Real>("rho")),
    _cp(getParam<Real>("cp"))
{
}

ADReal
heat2::precomputeQpResidual()
{
    return _rho*_cp*_u_dot[_qp];
}