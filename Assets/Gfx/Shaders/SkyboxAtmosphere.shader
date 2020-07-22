// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DM/SkyboxAtmosphere"
{
	Properties
	{
		_SkyColorTop("Sky Color Top", Color) = (0.3764706,0.6039216,1,0)
		_SkyColorBottom("Sky Color Bottom", Color) = (0.3764706,0.6039216,1,0)
		_NightColorTop("Night Color Top", Color) = (0,0,0,0)
		_NightColorBottom("Night Color Bottom", Color) = (0,0,0,0)
		_SkyGradientPower("Sky Gradient Power", Float) = 0
		_SkyGradientScale("Sky Gradient Scale", Float) = 0
		_HorizonGlowIntensity("Horizon Glow Intensity", Float) = 0.59
		_HorizonSharpness("Horizon Sharpness", Float) = 5.7
		_HorizonSunGlowSpreadMin("Horizon Sun Glow Spread Min", Range( 0 , 10)) = 5.075109
		_HorizonSunGlowSpreadMax("Horizon Sun Glow Spread Max", Range( 0 , 10)) = 0
		_NightTransitionScale("Night Transition Scale", Float) = 1
		_NightTransitionHorizonDelay("Night Transition Horizon Delay", Float) = 0
		_HorizonMinAmountAlways("Horizon Min Amount Always", Range( 0 , 1)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			uniform float4 _SkyColorTop;
			uniform float4 _SkyColorBottom;
			uniform float _SkyGradientPower;
			uniform float _SkyGradientScale;
			uniform float4 _NightColorTop;
			uniform float4 _NightColorBottom;
			uniform float4 SunDirLightDirection;
			uniform float _NightTransitionScale;
			uniform float4 _HorizonColor;
			uniform float _NightTransitionHorizonDelay;
			uniform float _HorizonMinAmountAlways;
			uniform float _HorizonSharpness;
			uniform float _HorizonSunGlowSpreadMin;
			uniform float _HorizonSunGlowSpreadMax;
			uniform float _HorizonGlowIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float3 normalizeResult566 = normalize( WorldPosition );
				float dotResult563 = dot( normalizeResult566 , float3( 0,1,0 ) );
				float SkyColorGradient573 = saturate( ( pow( ( 1.0 - abs( dotResult563 ) ) , _SkyGradientPower ) * _SkyGradientScale ) );
				float4 lerpResult575 = lerp( _SkyColorTop , _SkyColorBottom , SkyColorGradient573);
				float4 lerpResult578 = lerp( _NightColorTop , _NightColorBottom , SkyColorGradient573);
				float3 appendResult1071 = (float3(SunDirLightDirection.x , SunDirLightDirection.y , SunDirLightDirection.z));
				float3 SunDirection1070 = -appendResult1071;
				float dotResult81 = dot( -SunDirection1070 , float3( 0,1,0 ) );
				float NightTransScale235 = _NightTransitionScale;
				float4 lerpResult78 = lerp( lerpResult575 , lerpResult578 , saturate( ( dotResult81 * NightTransScale235 ) ));
				float4 SkyColor197 = lerpResult78;
				float4 HorizonColor313 = _HorizonColor;
				float dotResult238 = dot( -SunDirection1070 , float3( 0,1,0 ) );
				float HorizonScaleDayNight304 = saturate( ( dotResult238 * ( NightTransScale235 + _NightTransitionHorizonDelay ) ) );
				float dotResult213 = dot( SunDirection1070 , float3( 0,1,0 ) );
				float HorizonGlowGlobalScale307 = (_HorizonMinAmountAlways + (saturate( pow( ( 1.0 - abs( dotResult213 ) ) , 4.14 ) ) - 0.0) * (1.0 - _HorizonMinAmountAlways) / (1.0 - 0.0));
				float3 normalizeResult42 = normalize( WorldPosition );
				float dotResult40 = dot( normalizeResult42 , float3( 0,1,0 ) );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float dotResult12 = dot( -SunDirection1070 , ase_worldViewDir );
				float InvVDotL200 = dotResult12;
				float temp_output_22_0 = min( _HorizonSunGlowSpreadMin , _HorizonSunGlowSpreadMax );
				float temp_output_23_0 = max( _HorizonSunGlowSpreadMin , _HorizonSunGlowSpreadMax );
				float clampResult14 = clamp( (0.0 + (InvVDotL200 - ( 1.0 - ( temp_output_22_0 * temp_output_22_0 ) )) * (1.0 - 0.0) / (( 1.0 - ( temp_output_23_0 * temp_output_23_0 ) ) - ( 1.0 - ( temp_output_22_0 * temp_output_22_0 ) ))) , 0.0 , 1.0 );
				float dotResult88 = dot( SunDirection1070 , float3( 0,-1,0 ) );
				float clampResult89 = clamp( dotResult88 , 0.0 , 1.0 );
				float TotalHorizonMask314 = saturate( ( ( ( 1.0 - HorizonScaleDayNight304 ) * HorizonGlowGlobalScale307 ) * saturate( pow( ( 1.0 - abs( dotResult40 ) ) , _HorizonSharpness ) ) * saturate( ( pow( ( 1.0 - clampResult14 ) , 5.0 ) * _HorizonGlowIntensity * ( 1.0 - clampResult89 ) ) ) ) );
				float4 lerpResult55 = lerp( SkyColor197 , HorizonColor313 , TotalHorizonMask314);
				float4 Sky175 = ( lerpResult55 + float4( 0,0,0,0 ) );
				
				
				finalColor = Sky175;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
211;126;1678;1046;9867.883;3967.03;3.681195;True;False
Node;AmplifyShaderEditor.CommentaryNode;1083;-8531.427,-1556.444;Inherit;False;844.854;872.9316;Comment;13;1070;1073;1069;1077;1071;1078;1079;1080;1072;1076;1081;1082;1089;Global Light vars;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;1069;-8481.427,-1506.444;Float;False;Global;SunDirLightDirection;SunDirLightDirection;44;0;Create;True;0;0;False;0;False;0,0,0,0;-0.09010103,-0.314326,0.9450296,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;1071;-8208.742,-1492.023;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;1089;-8066.074,-1497.566;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1070;-7889.867,-1509.405;Float;False;SunDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;199;-975.0939,-2287.015;Inherit;False;2101.376;1153.238;Comment;28;79;197;78;84;56;85;81;92;235;86;562;563;564;565;566;567;568;569;570;571;573;574;575;576;577;578;579;1088;Sky Color Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;206;-8530.652,-3276.606;Inherit;False;4121.021;1625.509;Comment;16;198;57;175;76;55;63;233;234;305;309;311;313;314;316;356;395;Horizon And Sun Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;205;-4298.641,-2301.435;Inherit;False;2704.589;737.7334;Comment;39;939;933;71;69;298;303;261;264;297;302;263;287;262;300;265;75;286;271;268;282;281;284;252;285;200;12;34;11;942;947;951;950;952;953;956;958;959;1068;1085;Sun Disk;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2833.574,-2787.448;Inherit;False;1802.634;338.6813;Comment;10;213;221;215;220;222;216;223;244;307;1086;Scalar that makes the horizon glow brighter when the sun is low, scales it out when the sun is down and directly above;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;356;-8504.089,-2440.018;Inherit;False;2341.093;657.4434;Comment;23;62;19;90;15;17;89;16;32;14;88;13;201;27;29;28;26;25;24;23;22;20;21;1084;Horizon Glow added from the sun;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1085;-4254.569,-1820.743;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;562;-927.0293,-2210.465;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;306;-4288.764,-2808.82;Inherit;False;1333.227;394.979;Scales the horizon glow depending on the direction of the sun.  If it's below the horizon it scales out faster;9;241;237;243;242;238;239;240;304;1087;Horizon Daynight mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-8444.089,-2239.498;Float;False;Property;_HorizonSunGlowSpreadMin;Horizon Sun Glow Spread Min;11;0;Create;True;0;0;False;0;False;5.075109;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;566;-698.6517,-2199.093;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;11;-4258.888,-1735.156;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1086;-2785.129,-2739.142;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;34;-3996.254,-1748.051;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-890.7012,-1249.016;Float;False;Property;_NightTransitionScale;Night Transition Scale;14;0;Create;True;0;0;False;0;False;1;7.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-8454.089,-2150.497;Float;False;Property;_HorizonSunGlowSpreadMax;Horizon Sun Glow Spread Max;12;0;Create;True;0;0;False;0;False;0;3.77;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1087;-4199.787,-2739.142;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;23;-8124.09,-2134.497;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-3823.731,-1746.835;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;22;-8139.091,-2250.498;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;213;-2501.345,-2721.35;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;563;-527.2941,-2209.55;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-561.6544,-1289.811;Float;False;NightTransScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-7976.095,-2132.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-3669.823,-1744.45;Float;False;InvVDotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-7988.094,-2261.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-4238.763,-2528.84;Float;False;Property;_NightTransitionHorizonDelay;Night Transition Horizon Delay;15;0;Create;True;0;0;False;0;False;0;-4.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-4180.15,-2614.813;Inherit;False;235;NightTransScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;311;-8507.238,-2833.718;Inherit;False;1484.109;291.775;;8;59;51;47;46;44;40;42;41;Base Horizon Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;221;-2350.324,-2723.671;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;237;-3893.125,-2738.227;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;564;-366.0621,-2209.015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-2173.107,-2648.247;Float;False;Constant;_HideHorizonGlowScale;Hide Horizon Glow Scale;12;0;Create;True;0;0;False;0;False;4.14;4.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-7853.091,-2383.479;Inherit;False;200;InvVDotL;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-7777.447,-2027.897;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;565;-203.6511,-2216.562;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-8452.61,-2767.515;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;26;-7799.547,-2272.297;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-2157.975,-2733.936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-7802.145,-2185.197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-7780.047,-2112.397;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;568;-903.3739,-2062.666;Float;False;Property;_SkyGradientPower;Sky Gradient Power;4;0;Create;True;0;0;False;0;False;0;2.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;238;-3742.438,-2746.011;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-3890.97,-2606.997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-3584.789,-2734.266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1084;-7530.41,-2050.117;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;570;-906.5739,-1984.266;Float;False;Property;_SkyGradientScale;Sky Gradient Scale;5;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;220;-1900.078,-2704.504;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;567;39.02571,-2233.867;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;42;-8257.913,-2736.203;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-7545.959,-2319.831;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;222;-1732.469,-2693.311;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;240;-3415.625,-2720.031;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;40;-7981.716,-2737.504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-1862.364,-2563.768;Float;False;Property;_HorizonMinAmountAlways;Horizon Min Amount Always;16;0;Create;True;0;0;False;0;False;0;0.715;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;569;245.8354,-2216.961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-7325.624,-2320.166;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;88;-7292.435,-2043.723;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,-1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1088;-881.2212,-1443.89;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;89;-7160.735,-2048.504;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;304;-3251.538,-2724.358;Float;False;HorizonScaleDayNight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;571;403.3264,-2207.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;44;-7795.364,-2730.654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-7288.022,-2195.466;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-7163.071,-2308.566;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;92;-621.4085,-1461.355;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;223;-1518.243,-2695.267;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-1306.939,-2695.907;Float;False;HorizonGlowGlobalScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-8481.854,-3151.044;Inherit;False;304;HorizonScaleDayNight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-7738.571,-2640.74;Float;False;Property;_HorizonSharpness;Horizon Sharpness;10;0;Create;True;0;0;False;0;False;5.7;5.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;573;598.1349,-2185.916;Float;False;SkyColorGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-7005.608,-2055.175;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-6957.122,-2345.966;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;-7605.807,-2717.514;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-7094.485,-2206.375;Float;False;Property;_HorizonGlowIntensity;Horizon Glow Intensity;9;0;Create;True;0;0;False;0;False;0.59;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;81;-265.5615,-1408.569;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-3.628321,-2063.511;Float;False;Property;_SkyColorTop;Sky Color Top;0;0;Create;True;0;0;False;0;False;0.3764706,0.6039216,1,0;0.1200088,0.3730534,0.8207547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;79;-911.0458,-1887.826;Float;False;Property;_NightColorTop;Night Color Top;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;234;-8184.324,-3148.781;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-8472.78,-3049.193;Inherit;False;307;HorizonGlowGlobalScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;574;-17.86925,-1886.846;Float;False;Property;_SkyColorBottom;Sky Color Bottom;1;0;Create;True;0;0;False;0;False;0.3764706,0.6039216,1,0;0.2782968,0.8399825,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;51;-7438.125,-2713.062;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-6736.965,-2315.807;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;577;-917.1683,-1673.77;Float;False;Property;_NightColorBottom;Night Color Bottom;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.03302112,0.004004983,0.1698065,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;579;-686.7681,-1582.57;Inherit;False;573;SkyColorGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;576;-20.44614,-1707.933;Inherit;False;573;SkyColorGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-84.46637,-1355.791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-7963.283,-3096.833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;578;-422.7684,-1780.97;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;62;-6571.195,-2321.984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;84;169.556,-1311.744;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;575;298.7695,-1723.96;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;59;-7193.505,-2738.412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-6317.039,-2583.552;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;703.1164,-1475.541;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;395;-6150.704,-2569.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;898.4506,-1438.622;Float;False;SkyColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-6194.929,-2758.385;Float;False;Global;_HorizonColor;_Horizon Color;2;0;Create;True;0;0;False;0;False;0.9137255,0.8509804,0.7215686,0;0.882925,0.6844728,0.4615038,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-5874.567,-2677.044;Float;False;HorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-6219.937,-3226.605;Inherit;False;197;SkyColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;-5921.566,-2569.372;Float;False;TotalHorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-5473.988,-2676.948;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-5144.016,-3034.872;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-4834.533,-3005.006;Float;False;Sky;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;598;-4285.022,-3428.877;Inherit;False;1897.999;485.0002;Comment;15;583;586;585;593;592;590;589;588;581;582;594;584;595;591;587;Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;316;-6116.676,-2284.35;Inherit;False;927.1527;431.4218;Comment;7;204;291;312;315;289;290;288;Tinting the sun with the horizon color for added COOL;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1082;-7942.962,-895.1428;Float;False;MoonLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;590;-2827.022,-3058.877;Half;False;Property;_FogFill;Fog Fill;18;0;Create;True;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-3259.603,-2244.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-6022.634,-1971.189;Inherit;False;203;SunDisk;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;268;-3717.819,-2252.427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;300;-2967.63,-1765.923;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;586;-3467.022,-3250.877;Half;False;Constant;_Float39;Float 39;55;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-2656.793,-2117.085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;-3422.459,-1812.328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;-3542.116,-1971.204;Inherit;False;286;SunDiskSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1081;-8452.296,-890.5125;Float;False;Global;MoonDirLightColor;MoonDirLightColor;44;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;589;-3019.022,-3378.877;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-2474.651,-2107.593;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;582;-3979.02,-3378.877;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4235.022,-3058.877;Half;False;Property;_FogSmoothness;Fog Smoothness;19;0;Create;True;0;0;False;0;False;0.01;0.122;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-3706.731,-2069.258;Inherit;False;2;2;0;FLOAT;0.99;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1080;-7964.573,-989.2928;Float;False;MoonLightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;1077;-8453.834,-1103.508;Float;False;Global;MoonDirLightDirection;MoonDirLightDirection;44;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;933;-2109.753,-2041.923;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;959;-2142.145,-2235.793;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1072;-7981.711,-1382.26;Float;False;SunLightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;271;-3503.003,-2059.693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-6051.268,-2237.611;Inherit;False;313;HorizonColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;952;-1767.385,-1837.813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1079;-7967.661,-1081.899;Float;False;MoonDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-6073.199,-2050.299;Float;False;Property;_HorizonTintSunPower;Horizon Tint Sun Power;13;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;297;-2934.906,-1966.745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1078;-8157.503,-1086.529;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;587;-3211.023,-3058.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;264;-3042.316,-2243.866;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;303;-2480.372,-1755.841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;583;-3787.022,-3378.877;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;263;-3043.371,-2114.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;265;-3208.504,-1834.41;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1104;1577.67,-806.7673;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;593;-2571.023,-3378.877;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;958;-2444.473,-2238.817;Float;False;Property;_SunDiskCloudsTransmissionIntensity;Sun Disk Clouds Transmission Intensity;21;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;594;-4235.022,-3186.877;Half;False;Property;_FogHeight;Fog Height;17;0;Create;True;0;0;False;0;False;1;0.624;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1073;-8464.695,-1308.522;Float;False;Global;SunDirLightColor;SunDirLightColor;44;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;1091;806.6702,-952.7673;Inherit;False;2;0;FLOAT3;0,1,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1076;-7981.552,-1304.155;Float;False;SunLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-6064.281,-2141.399;Inherit;False;314;TotalHorizonMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1092;385.6702,-900.7673;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;1093;638.6702,-868.7673;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1105;1811.484,-1298.031;Inherit;False;175;Sky;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;-3891.45,-2248.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;942;-2332.729,-1739.246;Inherit;False;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1102;1275.67,-1232.767;Float;False;Property;_SunGlow;SunGlow;23;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,1,0.9023998,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;956;-2654.001,-2242.046;Float;False;SunDiskMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;585;-3467.022,-3378.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;581;-4235.022,-3378.877;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;289;-5797.323,-2193.372;Inherit;False;Lerp White To;-1;;18;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;1094;1181.67,-837.7673;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1090;383.6702,-1011.767;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;950;-1927.105,-2120.911;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1100;1853.67,-1022.767;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;-3496.859,-2246.469;Float;False;SunDiskSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;592;-2827.022,-3186.877;Half;False;Constant;_Float41;Float 41;55;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;261;-2872.972,-2165.903;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-4255.772,-2252.467;Float;False;Property;_SunDiskSize;Sun Disk Size;6;0;Create;True;0;0;False;0;False;0;0.01;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-5365.045,-2131.549;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2307.674,-2102.25;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-1507.778,-2024.162;Float;False;SunDisk;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1103;1289.67,-1057.767;Float;False;Property;_SunGlowFar;SunGlowFar;24;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;290;-5594.751,-2186.438;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;947;-2135.227,-1733.331;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;951;-1730.199,-2062.338;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;1096;970.6702,-936.7673;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;588;-3275.023,-3378.877;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1097;1396.67,-831.7673;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;584;-3467.022,-3154.877;Half;False;Constant;_Float40;Float 40;55;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-2712.24,-1745.76;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;953;-2350.625,-1840.306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-3985.405,-1873.9;Float;False;Property;_SunDiskSharpness;Sun Disk Sharpness;8;0;Create;True;0;0;False;0;False;0;0;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;591;-2827.022,-3378.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;939;-2325.773,-1957.965;Float;False;Property;_SunDiskIntensity;Sun Disk Intensity;20;0;Create;True;0;0;False;0;False;0;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-4261.198,-2021.038;Float;False;Property;_SunDiskSizeAdjust;Sun Disk Size Adjust;7;0;Create;True;0;0;False;0;False;0;0;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1068;-2761.808,-1977.351;Float;False;Property;_SunDiskGlow;Sun Disk Glow;22;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;1099;838.6702,-731.7673;Float;False;Property;_SunGlowScaleOffsetPower;SunGlowScaleOffsetPower;25;0;Create;True;0;0;False;0;False;0,0,0;1,0,66.76;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1110;2314.327,-1083.046;Float;False;True;-1;2;ASEMaterialInspector;100;1;DM/SkyboxAtmosphere;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;1071;0;1069;1
WireConnection;1071;1;1069;2
WireConnection;1071;2;1069;3
WireConnection;1089;0;1071;0
WireConnection;1070;0;1089;0
WireConnection;566;0;562;0
WireConnection;34;0;1085;0
WireConnection;23;0;20;0
WireConnection;23;1;21;0
WireConnection;12;0;34;0
WireConnection;12;1;11;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;213;0;1086;0
WireConnection;563;0;566;0
WireConnection;235;0;86;0
WireConnection;25;0;23;0
WireConnection;25;1;23;0
WireConnection;200;0;12;0
WireConnection;24;0;22;0
WireConnection;24;1;22;0
WireConnection;221;0;213;0
WireConnection;237;0;1087;0
WireConnection;564;0;563;0
WireConnection;565;0;564;0
WireConnection;26;0;24;0
WireConnection;215;0;221;0
WireConnection;27;0;25;0
WireConnection;238;0;237;0
WireConnection;242;0;241;0
WireConnection;242;1;243;0
WireConnection;239;0;238;0
WireConnection;239;1;242;0
WireConnection;220;0;215;0
WireConnection;220;1;216;0
WireConnection;567;0;565;0
WireConnection;567;1;568;0
WireConnection;42;0;41;0
WireConnection;13;0;201;0
WireConnection;13;1;26;0
WireConnection;13;2;27;0
WireConnection;13;3;28;0
WireConnection;13;4;29;0
WireConnection;222;0;220;0
WireConnection;240;0;239;0
WireConnection;40;0;42;0
WireConnection;569;0;567;0
WireConnection;569;1;570;0
WireConnection;14;0;13;0
WireConnection;88;0;1084;0
WireConnection;89;0;88;0
WireConnection;304;0;240;0
WireConnection;571;0;569;0
WireConnection;44;0;40;0
WireConnection;32;0;14;0
WireConnection;92;0;1088;0
WireConnection;223;0;222;0
WireConnection;223;3;244;0
WireConnection;307;0;223;0
WireConnection;573;0;571;0
WireConnection;90;0;89;0
WireConnection;15;0;32;0
WireConnection;15;1;16;0
WireConnection;47;0;44;0
WireConnection;81;0;92;0
WireConnection;234;0;305;0
WireConnection;51;0;47;0
WireConnection;51;1;46;0
WireConnection;19;0;15;0
WireConnection;19;1;17;0
WireConnection;19;2;90;0
WireConnection;85;0;81;0
WireConnection;85;1;235;0
WireConnection;233;0;234;0
WireConnection;233;1;309;0
WireConnection;578;0;79;0
WireConnection;578;1;577;0
WireConnection;578;2;579;0
WireConnection;62;0;19;0
WireConnection;84;0;85;0
WireConnection;575;0;56;0
WireConnection;575;1;574;0
WireConnection;575;2;576;0
WireConnection;59;0;51;0
WireConnection;63;0;233;0
WireConnection;63;1;59;0
WireConnection;63;2;62;0
WireConnection;78;0;575;0
WireConnection;78;1;578;0
WireConnection;78;2;84;0
WireConnection;395;0;63;0
WireConnection;197;0;78;0
WireConnection;313;0;57;0
WireConnection;314;0;395;0
WireConnection;55;0;198;0
WireConnection;55;1;313;0
WireConnection;55;2;314;0
WireConnection;76;0;55;0
WireConnection;175;0;76;0
WireConnection;1082;0;1081;0
WireConnection;262;0;286;0
WireConnection;262;1;271;0
WireConnection;268;0;284;0
WireConnection;298;0;261;0
WireConnection;298;1;303;0
WireConnection;75;0;200;0
WireConnection;589;0;588;0
WireConnection;589;1;587;0
WireConnection;69;0;298;0
WireConnection;582;0;581;0
WireConnection;282;1;281;0
WireConnection;1080;0;1077;4
WireConnection;933;0;71;0
WireConnection;933;1;939;0
WireConnection;959;0;958;0
WireConnection;959;1;71;0
WireConnection;1072;0;1069;4
WireConnection;271;0;282;0
WireConnection;952;0;953;0
WireConnection;1079;0;1078;0
WireConnection;297;0;265;0
WireConnection;1078;0;1077;1
WireConnection;1078;1;1077;2
WireConnection;1078;2;1077;3
WireConnection;587;0;595;0
WireConnection;264;0;287;0
WireConnection;264;1;262;0
WireConnection;303;0;302;0
WireConnection;583;0;582;0
WireConnection;263;0;287;0
WireConnection;263;1;262;0
WireConnection;265;0;75;0
WireConnection;265;1;75;0
WireConnection;1104;0;1097;0
WireConnection;593;0;591;0
WireConnection;593;1;592;0
WireConnection;593;2;590;0
WireConnection;1091;0;1090;0
WireConnection;1091;1;1093;0
WireConnection;1076;0;1073;0
WireConnection;1093;0;1092;0
WireConnection;284;0;252;0
WireConnection;284;1;285;0
WireConnection;956;0;69;0
WireConnection;585;0;583;1
WireConnection;289;1;312;0
WireConnection;289;2;315;0
WireConnection;1094;0;1096;0
WireConnection;1094;1;1099;1
WireConnection;1094;2;1099;2
WireConnection;950;0;959;0
WireConnection;950;1;933;0
WireConnection;950;2;947;0
WireConnection;1100;0;1103;0
WireConnection;1100;1;1102;0
WireConnection;1100;2;1104;0
WireConnection;286;0;268;0
WireConnection;261;0;297;0
WireConnection;261;1;264;0
WireConnection;261;2;263;0
WireConnection;288;0;290;0
WireConnection;288;1;204;0
WireConnection;71;0;69;0
WireConnection;71;1;1068;0
WireConnection;203;0;951;0
WireConnection;290;0;289;0
WireConnection;290;1;291;0
WireConnection;947;0;942;0
WireConnection;951;0;950;0
WireConnection;951;1;952;0
WireConnection;1096;0;1091;0
WireConnection;588;0;585;0
WireConnection;588;1;586;0
WireConnection;588;2;594;0
WireConnection;588;3;586;0
WireConnection;588;4;584;0
WireConnection;1097;0;1094;0
WireConnection;1097;1;1099;3
WireConnection;302;0;300;2
WireConnection;953;0;69;0
WireConnection;591;0;589;0
WireConnection;1110;0;1105;0
ASEEND*/
//CHKSM=093447B5EB913DEEBF604E3998CD45F3AE7A92E8