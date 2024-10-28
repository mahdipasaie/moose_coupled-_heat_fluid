#pragma once
#include "ADKernelValue.h"


class heat3 : public ADKernelValue
{
public:
  static InputParameters validParams();
  heat3(const InputParameters & parameters);
protected:
  virtual ADReal precomputeQpResidual() override;
private:
  Real _rho;
  Real _cp;          
  const ADVariableValue & _v;
  const ADVariableValue & _u;
};