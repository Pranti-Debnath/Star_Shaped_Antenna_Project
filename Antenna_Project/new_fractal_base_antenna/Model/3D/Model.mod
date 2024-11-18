'# MWS Version: Version 2020.0 - Sep 25 2019 - ACIS 29.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 30
'# created = '[VERSION]2020.0|29.0.1|20190925[/VERSION]


'@ use template: Antenna - Planar_9.cfg

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
'set the frequency range
Solver.FrequencyRange "1", "30"
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
Dim sDefineAt As String
sDefineAt = "1;15.5;30"
Dim sDefineAtName As String
sDefineAtName = "1;15.5;30"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")
Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)
Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)
' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With
' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With
Next
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
     .Yrange "0", "ls " 
     .Zrange "0", "-hs" 
     .Create
End With

'@ switch bounding box

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Plot.DrawBox "False"

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
Pick.PickEndpointFromId "component1:solid1_1", "2"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1", "10"

'@ transform: translate component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Vector "-1.7763568394003e-16", "12.5", "0" 
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
     .Angle "0", "0", "180" 
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

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ delete shape: component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_3"

'@ pick center point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCenterpointFromId "component1:solid1_1_1", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ transform: scale component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
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
Pick.PickEndpointFromId "component1:solid1_1_3", "2"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1", "10"

'@ transform: translate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
     .Vector "-0", "12.5", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_3"

'@ transform: scale component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
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
Pick.PickEndpointFromId "component1:solid1_1_3", "2"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1", "10"

'@ transform: translate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
     .Vector "-1.7763568394003e-16", "12", "0" 
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
Pick.PickCenterpointFromId "component1:solid1_1", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ transform: rotate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
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

'@ transform: rotate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
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

'@ transform: rotate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
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

'@ transform: rotate component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_3" 
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

'@ pick center point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickCenterpointFromId "component1:solid1_1_1", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ transform: scale component1:solid1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_1" 
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

'@ delete shape: component1:solid1_1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_1_1"

'@ transform: scale component1:solid1_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2" 
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
Pick.PickEndpointFromId "component1:solid1_1_2_1", "4"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_2", "12"

'@ transform: translate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
     .Vector "-2.9332682201217", "7", "-1" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_2_1"

'@ transform: scale component1:solid1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_1" 
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
Pick.PickEndpointFromId "component1:solid1_1_1_1", "4"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_4", "12"

'@ transform: translate component1:solid1_1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_1_1" 
     .Vector "5.8362925136173", "2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_1_1"

'@ transform: scale component1:solid1_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2" 
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
Pick.PickEndpointFromId "component1:solid1_1_2_1", "2"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_4", "4"

'@ transform: translate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
     .Vector "8", "5", "4" 
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
Pick.PickCenterpointFromId "component1:solid1_1_4", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ transform: rotate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
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

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ delete shape: component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_2_1"

'@ delete shape: component1:solid1_1_2_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_2_1_1"

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
Pick.PickEndpointFromId "component1:solid1_2", "10"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_2", "4"

'@ transform: translate component1:solid1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_2" 
     .Vector "-4.8887803668695", "0.1525902085825", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_2"

'@ transform: scale component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
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
Pick.PickEndpointFromId "component1:solid1_1_6", "6"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_4", "12"

'@ transform: translate component1:solid1_1_6

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_6" 
     .Vector "3", "-0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_1_6

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_6"

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

'@ delete shape: component1:solid1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_2"

'@ transform: scale component1:solid1_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2" 
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
Pick.PickEndpointFromId "component1:solid1_1_2_1", "2"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_2", "10"

'@ transform: translate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
     .Vector "-5", "4", "0" 
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
Pick.PickCenterpointFromId "component1:solid1_1_2", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ transform: rotate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
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

'@ transform: rotate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
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

'@ transform: rotate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
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

'@ transform: rotate component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_2_1" 
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

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ transform: scale component1:solid1_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4" 
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
Pick.PickEndpointFromId "component1:solid1_1_4_1", "12"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_4", "4"

'@ transform: translate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
     .Vector "5", "6", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Delete "component1:solid1_1_4_1"

'@ transform: scale component1:solid1_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4" 
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
Pick.PickEndpointFromId "component1:solid1_1_4_1", "8"

'@ pick end point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEndpointFromId "component1:solid1_1_4", "6"

'@ transform: translate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
     .Vector "2.9332682201217", "3", "0" 
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
Pick.PickCenterpointFromId "component1:solid1_1_4", "8"

'@ align wcs with point

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.AlignWCSWithSelected "Point"

'@ transform: rotate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
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

'@ transform: rotate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "180" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
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

'@ transform: rotate component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_4_1" 
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

'@ activate global coordinates

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
WCS.ActivateWCS "global"

'@ boolean add shapes: component1:solid1, component1:solid1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1"

'@ boolean add shapes: component1:solid1_1_1, component1:solid1_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_1", "component1:solid1_1_2"

'@ boolean add shapes: component1:solid1_1_2_1, component1:solid1_1_2_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1", "component1:solid1_1_2_1_1"

'@ boolean add shapes: component1:solid1_1_2_1_2, component1:solid1_1_2_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1_2", "component1:solid1_1_2_1_3"

'@ boolean add shapes: component1:solid1_1_2_1_4, component1:solid1_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1_4", "component1:solid1_1_3"

'@ boolean add shapes: component1:solid1_1_3_1, component1:solid1_1_3_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_3_1", "component1:solid1_1_3_2"

'@ boolean add shapes: component1:solid1_1_3_3, component1:solid1_1_3_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_3_3", "component1:solid1_1_3_4"

'@ boolean add shapes: component1:solid1_1_4, component1:solid1_1_4_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_4", "component1:solid1_1_4_1"

'@ boolean add shapes: component1:solid1_1_4_1_1, component1:solid1_1_4_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_4_1_1", "component1:solid1_1_4_1_2"

'@ boolean add shapes: component1:solid1_1_4_1_3, component1:solid1_1_4_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_4_1_3", "component1:solid1_1_4_1_4"

'@ boolean add shapes: component1:solid1_1_4_1_3, component1:solid1_1_5

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_4_1_3", "component1:solid1_1_5"

'@ boolean add shapes: component1:solid1, component1:solid1_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_1"

'@ boolean add shapes: component1:solid1_1_2_1, component1:solid1_1_2_1_2

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1", "component1:solid1_1_2_1_2"

'@ boolean add shapes: component1:solid1_1_2_1_4, component1:solid1_1_3_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1_4", "component1:solid1_1_3_1"

'@ boolean add shapes: component1:solid1_1_3_3, component1:solid1_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_3_3", "component1:solid1_1_4"

'@ boolean add shapes: component1:solid1_1_4_1_1, component1:solid1_1_4_1_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_4_1_1", "component1:solid1_1_4_1_3"

'@ boolean add shapes: component1:solid1, component1:solid1_1_2_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_2_1"

'@ boolean add shapes: component1:solid1_1_2_1_4, component1:solid1_1_3_3

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1_4", "component1:solid1_1_3_3"

'@ boolean add shapes: component1:solid1_1_2_1_4, component1:solid1_1_4_1_1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1_1_2_1_4", "component1:solid1_1_4_1_1"

'@ boolean add shapes: component1:solid1, component1:solid1_1_2_1_4

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_2_1_4"

'@ boolean add shapes: component1:feed, component1:solid1

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.Add "component1:feed", "component1:solid1"

'@ pick edge

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEdgeFromId "component1:feed", "909", "587"

'@ pick edge

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Pick.PickEdgeFromId "component1:feed", "910", "586"

'@ chamfer edges of: component1:feed

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Solid.ChamferEdge "0.6", "45", "False", "421"

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
Pick.PickFaceFromId "component1:feed", "467"

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
  .XrangeAdd "0.8*8.74", "0.8*8.74"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.8", "0.8*8.74"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define time domain solver parameters

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
Discretizer.PBAVersion "2019092520"

'@ set optimizer parameters

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Optimizer
  .SetMinMaxAuto "10" 
  .SetAlwaysStartFromCurrent "True" 
  .ResetParameterList
  .SelectParameter "hc", "False" 
  .SetParameterInit "0.035" 
  .SetParameterMin "0.0315" 
  .SetParameterMax "0.0385" 
  .SetParameterAnchors "5" 
  .SelectParameter "hs", "False" 
  .SetParameterInit "0.8" 
  .SetParameterMin "0.72" 
  .SetParameterMax "0.88" 
  .SetParameterAnchors "5" 
  .SelectParameter "lf", "False" 
  .SetParameterInit "9" 
  .SetParameterMin "8.1" 
  .SetParameterMax "9.9" 
  .SetParameterAnchors "5" 
  .SelectParameter "ls", "True" 
  .SetParameterInit "20" 
  .SetParameterMin "16" 
  .SetParameterMax "20" 
  .SetParameterAnchors "5" 
  .SelectParameter "s1", "False" 
  .SetParameterInit "0.4" 
  .SetParameterMin "0.36" 
  .SetParameterMax "0.44" 
  .SetParameterAnchors "5" 
  .SelectParameter "wf", "False" 
  .SetParameterInit "2.8" 
  .SetParameterMin "2.52" 
  .SetParameterMax "3.08" 
  .SetParameterAnchors "5" 
  .SelectParameter "wp", "False" 
  .SetParameterInit "8.4" 
  .SetParameterMin "7.56" 
  .SetParameterMax "9.24" 
  .SetParameterAnchors "5" 
  .SelectParameter "ws", "True" 
  .SetParameterInit "20" 
  .SetParameterMin "16" 
  .SetParameterMax "20" 
  .SetParameterAnchors "5" 
End With

'@ set optimizer settings

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Optimizer 
  .SetOptimizerType "Trust_Region" 
  .SetSimulationType "Time Domain Solver" 
  .SetAccuracy "0.01" 
  .SetNumRefinements "1" 
  .SetGenerationSize "32", "Genetic_Algorithm" 
  .SetGenerationSize "30", "Particle_Swarm" 
  .SetMaxIt "30", "Genetic_Algorithm" 
  .SetMaxIt "15", "Particle_Swarm" 
  .SetMaxEval "3000", "CMAES" 
  .SetUseMaxEval "True", "CMAES" 
  .SetSigma "0.2", "CMAES" 
  .SetSeed "1", "CMAES" 
  .SetSeed "1", "Genetic_Algorithm" 
  .SetSeed "1", "Particle_Swarm" 
  .SetSeed "1", "Nelder_Mead_Simplex" 
  .SetMaxEval "500", "Trust_Region" 
  .SetUseMaxEval "False", "Trust_Region" 
  .SetSigma "0.2", "Trust_Region" 
  .SetDomainAccuracy "0.01", "Trust_Region" 
  .SetFiniteDiff "0", "Trust_Region" 
  .SetMaxEval "250", "Nelder_Mead_Simplex" 
  .SetUseMaxEval "False", "Nelder_Mead_Simplex" 
  .SetUseInterpolation "No_Interpolation", "Genetic_Algorithm" 
  .SetUseInterpolation "No_Interpolation", "Particle_Swarm" 
  .SetInitialDistribution "Latin_Hyper_Cube", "Genetic_Algorithm" 
  .SetInitialDistribution "Latin_Hyper_Cube", "Particle_Swarm" 
  .SetInitialDistribution "Noisy_Latin_Hyper_Cube", "Nelder_Mead_Simplex" 
  .SetUsePreDefPointInInitDistribution "True", "Nelder_Mead_Simplex" 
  .SetUsePreDefPointInInitDistribution "True", "CMAES" 
  .SetGoalFunctionLevel "0.0", "Genetic_Algorithm" 
  .SetGoalFunctionLevel "0.0", "Particle_Swarm" 
  .SetGoalFunctionLevel "0.0", "Nelder_Mead_Simplex" 
  .SetMutaionRate "60", "Genetic_Algorithm" 
  .SetMinSimplexSize "1e-6" 
  .SetGoalSummaryType "Sum_All_Goals" 
  .SetUseDataOfPreviousCalculations "False" 
  .SetDataStorageStrategy "None" 
  .SetOptionMoveMesh "False" 
End With

'@ add optimizer goals: 1DC Primary Result / 0

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Optimizer 
  .AddGoal "1DC Primary Result" 
  .SetGoalOperator "<" 
  .SetGoalTarget "-40" 
  .UseSlope "False" 
  .SetGoalTargetMax "0.0" 
  .SetGoalWeight "1.0" 
  .SetGoalNormNew "MaxDiff" 
  .SetGoal1DCResultName "1D Results\S-Parameters\S1,1" 
  .SetGoalScalarType "MagdB20" 
  .SetGoalRange "1", "30" 
  .SetGoalRangeType "total" 
End With

'@ set optimizer settings

'[VERSION]2020.0|29.0.1|20190925[/VERSION]
With Optimizer 
  .SetOptimizerType "Trust_Region" 
  .SetSimulationType "Time Domain Solver" 
  .SetAccuracy "0.01" 
  .SetNumRefinements "1" 
  .SetGenerationSize "32", "Genetic_Algorithm" 
  .SetGenerationSize "30", "Particle_Swarm" 
  .SetMaxIt "30", "Genetic_Algorithm" 
  .SetMaxIt "15", "Particle_Swarm" 
  .SetMaxEval "3000", "CMAES" 
  .SetUseMaxEval "True", "CMAES" 
  .SetSigma "0.2", "CMAES" 
  .SetSeed "1", "CMAES" 
  .SetSeed "1", "Genetic_Algorithm" 
  .SetSeed "1", "Particle_Swarm" 
  .SetSeed "1", "Nelder_Mead_Simplex" 
  .SetMaxEval "500", "Trust_Region" 
  .SetUseMaxEval "False", "Trust_Region" 
  .SetSigma "0.2", "Trust_Region" 
  .SetDomainAccuracy "0.01", "Trust_Region" 
  .SetFiniteDiff "0", "Trust_Region" 
  .SetMaxEval "250", "Nelder_Mead_Simplex" 
  .SetUseMaxEval "False", "Nelder_Mead_Simplex" 
  .SetUseInterpolation "No_Interpolation", "Genetic_Algorithm" 
  .SetUseInterpolation "No_Interpolation", "Particle_Swarm" 
  .SetInitialDistribution "Latin_Hyper_Cube", "Genetic_Algorithm" 
  .SetInitialDistribution "Latin_Hyper_Cube", "Particle_Swarm" 
  .SetInitialDistribution "Noisy_Latin_Hyper_Cube", "Nelder_Mead_Simplex" 
  .SetUsePreDefPointInInitDistribution "True", "Nelder_Mead_Simplex" 
  .SetUsePreDefPointInInitDistribution "True", "CMAES" 
  .SetGoalFunctionLevel "0", "Genetic_Algorithm" 
  .SetGoalFunctionLevel "0", "Particle_Swarm" 
  .SetGoalFunctionLevel "0", "Nelder_Mead_Simplex" 
  .SetMutaionRate "60", "Genetic_Algorithm" 
  .SetMinSimplexSize "1e-6" 
  .SetGoalSummaryType "Sum_All_Goals" 
  .SetUseDataOfPreviousCalculations "False" 
  .SetDataStorageStrategy "None" 
  .SetOptionMoveMesh "False" 
End With 


