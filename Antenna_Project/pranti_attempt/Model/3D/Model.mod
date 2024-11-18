'# MWS Version: Version 2020.0 - Sep 25 2019 - ACIS 29.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.0 fmax = 0.0
'# created = '[VERSION]2020.0|29.0.1|20190925[/VERSION]


'@ use template: Antenna - Planar_8.cfg

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------




'@ define material: Rogers RT5880 (lossy)

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Material
     .Reset
     .Name "Rogers RT5880 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "2.2"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.0009"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.20"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With 


'@ new component: component1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Component.New "component1" 


'@ define brick: component1:subs

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Brick
     .Reset 
     .Name "subs" 
     .Component "component1" 
     .Material "Rogers RT5880 (lossy)" 
     .Xrange "-ws/2", "ws/2" 
     .Yrange "0", "ls" 
     .Zrange "0", "-hs" 
     .Create
End With


'@ switch working plane

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Plot.DrawWorkplane "false" 


'@ define brick: component1:feed

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Brick
     .Reset 
     .Name "feed" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-wf/2", "wf/2" 
     .Yrange "0", "lf" 
     .Zrange "0", "hc" 
     .Create
End With


'@ pick mid point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickMidpointFromId "component1:feed", "2" 


'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point" 


'@ define curve line: curve1:line1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "-wp/2" 
     .Y1 "0" 
     .X2 "wp/2" 
     .Y2 "0" 
     .Create
End With


'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCurveEndpointFromId "curve1:line1", "1" 


'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point" 


'@ transform curve: rotate curve1:line1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "60" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Transform "Curve", "Rotate" 
End With 


'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCurveEndpointFromId "curve1:line1", "2" 


'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point" 


'@ transform curve: rotate curve1:line1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "300" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Transform "Curve", "Rotate" 
End With 


'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"


'@ define coverprofile: component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Curve "curve1:line1" 
     .DeleteCurve "True" 
     .Create
End With


'@ thicken sheet: component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.ThickenSheetAdvanced "component1:solid1", "Inside", "hc", "True" 


'@ pick center point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCenterpointFromId "component1:solid1", "3" 


'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point" 


'@ transform: rotate component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "60" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Rotate" 
End With 


'@ transform: rotate component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "300" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With 


'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"


'@ boolean add shapes: component1:solid1, component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1" 


'@ transform: scale component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .ScaleFactor "s1", "s1", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Scale" 
End With 


'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1", "8" 


'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "4" 


'@ transform: translate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Vector "7.105427357601e-16", "12.5", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With 


'@ pick center point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCenterpointFromId "component1:solid1", "8" 


'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point" 


'@ transform: rotate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "300" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With 


'@ transform: rotate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "60" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With 


'@ transform: rotate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "120" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With 


'@ transform: rotate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "240" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With 


'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"


'@ boolean add shapes: component1:solid1, component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1" 


'@ boolean add shapes: component1:solid1_1_1, component1:solid1_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_1", "component1:solid1_1_2" 


'@ boolean add shapes: component1:solid1_1_3, component1:solid1_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_3", "component1:solid1_1_4" 


'@ boolean add shapes: component1:solid1, component1:solid1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_1" 


'@ boolean add shapes: component1:solid1, component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_3" 


'@ boolean add shapes: component1:feed, component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:feed", "component1:solid1" 


'@ pick mid point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickMidpointFromId "component1:feed", "265" 


'@ pick edge

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEdgeFromId "component1:feed", "265", "167" 


'@ pick edge

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEdgeFromId "component1:feed", "266", "166" 


'@ chamfer edges of: component1:feed

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.ChamferEdge "0.5", "45", "False", "104" 


'@ pick face

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickFaceFromId "component1:subs", "2" 


'@ define extrude: component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Extrude 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "hc" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With 


'@ pick face

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickFaceFromId "component1:feed", "136" 


'@ define port:1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.8*8.93", "0.8*8.93"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.8", "0.8*8.93"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With



