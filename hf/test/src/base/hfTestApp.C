//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "hfTestApp.h"
#include "hfApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
hfTestApp::validParams()
{
  InputParameters params = hfApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

hfTestApp::hfTestApp(InputParameters parameters) : MooseApp(parameters)
{
  hfTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

hfTestApp::~hfTestApp() {}

void
hfTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  hfApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"hfTestApp"});
    Registry::registerActionsTo(af, {"hfTestApp"});
  }
}

void
hfTestApp::registerApps()
{
  registerApp(hfApp);
  registerApp(hfTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
hfTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hfTestApp::registerAll(f, af, s);
}
extern "C" void
hfTestApp__registerApps()
{
  hfTestApp::registerApps();
}
