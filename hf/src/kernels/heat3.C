#include "heat3.h"

registerMooseObject("hfApp", heat3);

InputParameters
heat3::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addParam<Real>("rho", 1, "Coefficient of the source term");  
  params.addParam<Real>("cp", 1, "Coefficient for scaling term");
  params.addCoupledVar("v", "First velocity component (x-direction)"); 
  params.addCoupledVar("u", "Second velocity component (y-direction)"); 
  return params;
}

heat3::heat3(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _rho(getParam<Real>("rho")),
    _cp(getParam<Real>("cp")),
    _v(adCoupledValue("v")),
    _u(adCoupledValue("u"))
{
}

ADReal
heat3::precomputeQpResidual()
{
    // return _grad_u[_qp](0)* _v[_qp](0) + _grad_u[_qp](1)* _v[_qp](1);

    return _rho * _cp * (_v[_qp]* _grad_u[_qp](0) + _u[_qp] * _grad_u[_qp](1));

}