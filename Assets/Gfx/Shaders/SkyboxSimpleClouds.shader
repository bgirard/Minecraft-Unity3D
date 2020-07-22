// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DM/SkyboxSimpleClouds"
{
	Properties
	{
		_Coverage("Coverage", Range( 0 , 1)) = 0
		_CloudTimescale("Cloud Timescale", Float) = 0
		_CloudHorizonMaskSharpness("Cloud Horizon Mask Sharpness", Float) = 0
		_CloudHorizonMaskHeightOffset("Cloud Horizon Mask Height Offset", Float) = 0
		_CloudNoise("Cloud Noise", 2D) = "white" {}
		_CloudHeight("Cloud Height", Float) = 0
		_CloudTiling("Cloud Tiling", Vector) = (0,0,0,0)
		_CloudOffset("Cloud Offset", Vector) = (0,0,0,0)
		_CloudScroll("Cloud Scroll", Vector) = (0,0,0,0)
		_CloudOffset2("Cloud Offset 2", Vector) = (0,0,0,0)
		_CloudScroll2("Cloud Scroll 2", Vector) = (2,0,0,0)
		_CloudHeight3("Cloud Height 3", Float) = 0
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_CloudSharpness("Cloud Sharpness", Vector) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
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
			#include "UnityShaderVariables.cginc"
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

			uniform float4 CloudColor;
			uniform float2 _CloudSharpness;
			uniform sampler2D _CloudNoise;
			uniform float _CloudHeight;
			uniform float2 _CloudTiling;
			uniform float2 _CloudOffset;
			uniform float2 _CloudScroll;
			uniform float _CloudTimescale;
			uniform float2 _CloudScroll2;
			uniform float2 _CloudOffset2;
			uniform float _CloudHeight3;
			uniform float2 _Vector0;
			uniform float _Coverage;
			uniform float _CloudHorizonMaskHeightOffset;
			uniform float _CloudHorizonMaskSharpness;

			
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
				float2 appendResult1184 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_1201_0 = ( ( appendResult1184 / ( WorldPosition.y * _CloudHeight ) ) / _CloudTiling );
				float mulTime1186 = _Time.y * _CloudTimescale;
				float2 appendResult1189 = (float2(WorldPosition.x , WorldPosition.z));
				float mulTime1191 = _Time.y * _CloudTimescale;
				float CloudCoverage1174 = (-1.0 + (_Coverage - 0.0) * (1.0 - -1.0) / (1.0 - 0.0));
				float smoothstepResult1213 = smoothstep( _CloudSharpness.x , _CloudSharpness.y , ( ( ( tex2D( _CloudNoise, ( temp_output_1201_0 + ( _CloudOffset + ( _CloudScroll * mulTime1186 ) ) ) ).r + tex2D( _CloudNoise, ( temp_output_1201_0 + ( mulTime1186 * _CloudScroll2 ) + _CloudOffset2 ) ).r + tex2D( _CloudNoise, ( ( appendResult1189 / ( WorldPosition.y * _CloudHeight3 ) ) + ( _Vector0 * mulTime1191 ) ) ).r ) / 3.0 ) + CloudCoverage1174 ));
				float3 normalizeResult1167 = normalize( WorldPosition );
				float CloudHorizonMask1177 = saturate( ( ( normalizeResult1167.y - _CloudHorizonMaskHeightOffset ) * _CloudHorizonMaskSharpness ) );
				float CloudLayer1218 = saturate( ( smoothstepResult1213 * CloudHorizonMask1177 ) );
				float4 appendResult1223 = (float4((CloudColor).rgb , CloudLayer1218));
				
				
				finalColor = appendResult1223;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
211;126;1678;1046;-1011.561;802.5679;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1163;-2713.908,-354.6851;Inherit;False;4348.453;1407.389;Comment;41;1218;1217;1216;1215;1214;1213;1212;1211;1210;1209;1208;1207;1206;1205;1204;1203;1202;1201;1200;1199;1198;1197;1196;1195;1194;1193;1192;1191;1190;1189;1188;1187;1186;1185;1184;1183;1182;1181;1180;1179;1178;Clouds;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1179;-2663.908,7.000977;Float;False;Property;_CloudHeight;Cloud Height;31;0;Create;True;0;0;False;0;False;0;12.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1180;-2142.711,352.0698;Float;False;Property;_CloudTimescale;Cloud Timescale;27;0;Create;True;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1178;-2653.364,-192.8792;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1185;-2097.122,682.6929;Float;False;Property;_CloudHeight3;Cloud Height 3;37;0;Create;True;0;0;False;0;False;0;-4.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1181;-1142.924,-98.71118;Float;False;Property;_CloudScroll;Cloud Scroll;34;0;Create;True;0;0;False;0;False;0,0;0.4,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1182;-2374.583,-63.42407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1164;-2724.848,-900.592;Inherit;False;1848.505;446.5817;Comment;9;1177;1176;1175;1172;1171;1170;1168;1167;1165;Cloud Horizon Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;1186;-1502.516,57.55591;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1184;-2393.373,-189.033;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1183;-2119.727,491.207;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1194;-1852.443,653.437;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1188;-2122.825,-172.51;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1190;-1867.91,815.77;Float;False;Property;_Vector0;Vector 0;38;0;Create;True;0;0;False;0;False;0,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1193;-928.4358,-15.13208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1187;-2172.571,8.064941;Float;False;Property;_CloudTiling;Cloud Tiling;32;0;Create;True;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;1189;-1849.785,509.824;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1195;-1489.475,266.616;Float;False;Property;_CloudScroll2;Cloud Scroll 2;36;0;Create;True;0;0;False;0;False;2,0;0.3,-0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;1192;-1156.626,-214.7161;Float;False;Property;_CloudOffset;Cloud Offset;33;0;Create;True;0;0;False;0;False;0,0;14.1,8.24;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;1191;-2136.353,942.7029;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1165;-2674.848,-826.6931;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;1167;-2381.415,-801.7631;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1166;-786.7927,-832.5341;Inherit;False;806.5024;269.7425;Comment;3;1174;1173;1219;Coverage;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1197;-1655.44,882.127;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1196;-1609.099,586.95;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1199;-1432.392,404.8589;Float;False;Property;_CloudOffset2;Cloud Offset 2;35;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1198;-1243.154,265.7749;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1201;-1831.997,-107.386;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1200;-785.4368,-128.2322;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1203;-742.3538,246.635;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1202;-707.1729,-304.6851;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1219;-730.4377,-663.1693;Inherit;False;Property;_Coverage;Coverage;26;0;Create;True;0;0;False;0;False;0;0.353;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1204;-799.7371,447.002;Float;True;Property;_CloudNoise;Cloud Noise;30;0;Create;True;0;0;False;0;False;None;713efc49b75fdd1498ec0d64c7f5836e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1205;-1251.177,900.6021;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1170;-2228.224,-693.1201;Float;False;Property;_CloudHorizonMaskHeightOffset;Cloud Horizon Mask Height Offset;29;0;Create;True;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1168;-2148.321,-810.6051;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;1207;-232.6987,10.61987;Inherit;True;Property;_TextureSample3;Texture Sample 3;32;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1171;-1979.724,-590.821;Float;False;Property;_CloudHorizonMaskSharpness;Cloud Horizon Mask Sharpness;28;0;Create;True;0;0;False;0;False;0;11.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1206;-254.9409,777.5369;Inherit;True;Property;_TextureSample0;Texture Sample 0;32;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1172;-1819.421,-724.493;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1208;-247.4609,-240.084;Inherit;True;Property;_TextureSample1;Texture Sample 1;32;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1173;-447.6328,-764.791;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1174;-230.2898,-782.5331;Float;False;CloudCoverage;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1209;238.5271,57.12891;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1175;-1602.321,-805.092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1176;-1411.221,-850.592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1216;-264.4019,264.7581;Inherit;False;1174;CloudCoverage;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1210;394.6611,50.12183;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1211;548.3242,54.75391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1177;-1173.226,-844.6101;Float;False;CloudHorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1212;452.1301,225.991;Float;False;Property;_CloudSharpness;Cloud Sharpness;39;0;Create;True;0;0;False;0;False;0,0;0.4,0.44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;1213;845.7551,39.62695;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1217;461.3103,411.3459;Inherit;False;1177;CloudHorizonMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1214;1037.826,93.97583;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;206;-8530.652,-3276.606;Inherit;False;4121.021;1625.509;Comment;16;198;57;175;76;55;63;233;234;305;309;311;313;314;316;356;395;Horizon And Sun Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;1220;1815.612,-417.7094;Inherit;False;Global;CloudColor;Cloud Color;27;0;Create;True;0;0;False;0;False;0,0,0,0;0.9488763,0.7605211,0.5253618,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;1215;1214.411,120.241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;311;-8507.238,-2833.718;Inherit;False;1484.109;291.775;;8;59;51;47;46;44;40;42;41;Base Horizon Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-2833.574,-2787.448;Inherit;False;1802.634;338.6813;Comment;10;213;221;215;220;222;216;223;244;307;1086;Scalar that makes the horizon glow brighter when the sun is low, scales it out when the sun is down and directly above;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;199;-975.0939,-2287.015;Inherit;False;2101.376;1153.238;Comment;28;79;197;78;84;56;85;81;92;235;86;562;563;564;565;566;567;568;569;570;571;573;574;575;576;577;578;579;1088;Sky Color Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;306;-4288.764,-2808.82;Inherit;False;1333.227;394.979;Scales the horizon glow depending on the direction of the sun.  If it's below the horizon it scales out faster;9;241;237;243;242;238;239;240;304;1087;Horizon Daynight mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;356;-8504.089,-2440.018;Inherit;False;2341.093;657.4434;Comment;23;62;19;90;15;17;89;16;32;14;88;13;201;27;29;28;26;25;24;23;22;20;21;1084;Horizon Glow added from the sun;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;598;-4285.022,-3428.877;Inherit;False;1897.999;485.0002;Comment;15;583;586;585;593;592;590;589;588;581;582;594;584;595;591;587;Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1218;1364.309,174.6809;Float;False;CloudLayer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1222;2125.917,-302.1705;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1083;-8531.427,-1556.444;Inherit;False;844.854;872.9316;Comment;13;1070;1073;1069;1077;1071;1078;1079;1080;1072;1076;1081;1082;1089;Global Light vars;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;205;-4298.641,-2301.435;Inherit;False;2704.589;737.7334;Comment;39;939;933;71;69;298;303;261;264;297;302;263;287;262;300;265;75;286;271;268;282;281;284;252;285;200;12;34;11;942;947;951;950;952;953;956;958;959;1068;1085;Sun Disk;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;316;-6116.676,-2284.35;Inherit;False;927.1527;431.4218;Comment;7;204;291;312;315;289;290;288;Tinting the sun with the horizon color for added COOL;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;569;245.8354,-2216.961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;244;-1862.364,-2563.768;Float;False;Property;_HorizonMinAmountAlways;Horizon Min Amount Always;16;0;Create;True;0;0;False;0;False;0;0.715;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-7094.485,-2206.375;Float;False;Property;_HorizonGlowIntensity;Horizon Glow Intensity;9;0;Create;True;0;0;False;0;False;0.59;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-7545.959,-2319.831;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;-7605.807,-2717.514;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;81;-265.5615,-1408.569;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-3584.789,-2734.266;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-8481.854,-3151.044;Inherit;False;304;HorizonScaleDayNight;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;304;-3251.538,-2724.358;Float;False;HorizonScaleDayNight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;223;-1518.243,-2695.267;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-7325.624,-2320.166;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;573;598.1349,-2185.916;Float;False;SkyColorGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;40;-7981.716,-2737.504;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;575;298.7695,-1723.96;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;240;-3415.625,-2720.031;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;571;403.3264,-2207.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;88;-7292.435,-2043.723;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,-1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;-7193.505,-2738.412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1088;-881.2212,-1443.89;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-7963.283,-3096.833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;222;-1732.469,-2693.311;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-6957.122,-2345.966;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1086;-2785.129,-2739.142;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-890.7012,-1249.016;Float;False;Property;_NightTransitionScale;Night Transition Scale;14;0;Create;True;0;0;False;0;False;1;7.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-8454.089,-2150.497;Float;False;Property;_HorizonSunGlowSpreadMax;Horizon Sun Glow Spread Max;12;0;Create;True;0;0;False;0;False;0;3.77;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1087;-4199.787,-2739.142;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;23;-8124.09,-2134.497;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;213;-2501.345,-2721.35;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;22;-8139.091,-2250.498;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-3823.731,-1746.835;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;563;-527.2941,-2209.55;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;221;-2350.324,-2723.671;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;703.1164,-1475.541;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;220;-1900.078,-2704.504;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;567;39.02571,-2233.867;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;-5921.566,-2569.372;Float;False;TotalHorizonMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-8472.78,-3049.193;Inherit;False;307;HorizonGlowGlobalScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-7738.571,-2640.74;Float;False;Property;_HorizonSharpness;Horizon Sharpness;10;0;Create;True;0;0;False;0;False;5.7;5.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-7163.071,-2308.566;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;84;169.556,-1311.744;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;11;-4258.888,-1735.156;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;92;-621.4085,-1461.355;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-5144.016,-3034.872;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-1306.939,-2695.907;Float;False;HorizonGlowGlobalScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;577;-917.1683,-1673.77;Float;False;Property;_NightColorBottom;Night Color Bottom;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.03302112,0.004004983,0.1698065,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;51;-7438.125,-2713.062;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;579;-686.7681,-1582.57;Inherit;False;573;SkyColorGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;574;-17.86925,-1886.846;Float;False;Property;_SkyColorBottom;Sky Color Bottom;1;0;Create;True;0;0;False;0;False;0.3764706,0.6039216,1,0;0.2782968,0.8399825,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;234;-8184.324,-3148.781;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-3.628321,-2063.511;Float;False;Property;_SkyColorTop;Sky Color Top;0;0;Create;True;0;0;False;0;False;0.3764706,0.6039216,1,0;0.1200088,0.3730534,0.8207547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;89;-7160.735,-2048.504;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-7288.022,-2195.466;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;566;-698.6517,-2199.093;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-8444.089,-2239.498;Float;False;Property;_HorizonSunGlowSpreadMin;Horizon Sun Glow Spread Min;11;0;Create;True;0;0;False;0;False;5.075109;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;34;-3996.254,-1748.051;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;562;-927.0293,-2210.465;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;584;-3467.022,-3154.877;Half;False;Constant;_Float40;Float 40;55;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;-3891.45,-2248.7;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-1507.778,-2024.162;Float;False;SunDisk;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;265;-3208.504,-1834.41;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;271;-3503.003,-2059.693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-7005.608,-2055.175;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;576;-20.44614,-1707.933;Inherit;False;573;SkyColorGradient;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;-3542.116,-1971.204;Inherit;False;286;SunDiskSize;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-84.46637,-1355.791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-6736.965,-2315.807;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;302;-2712.24,-1745.76;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1073;-8464.695,-1308.522;Float;False;Global;SunDirLightColor;SunDirLightColor;44;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-2656.793,-2117.085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-4834.533,-3005.006;Float;False;Sky;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;953;-2350.625,-1840.306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;290;-5594.751,-2186.438;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;1096;1812.333,-1823.143;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;1094;2023.333,-1724.143;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;591;-2827.022,-3378.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;593;-2571.023,-3378.877;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;1077;-8453.834,-1103.508;Float;False;Global;MoonDirLightDirection;MoonDirLightDirection;44;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;75;-3422.459,-1812.328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-3706.731,-2069.258;Inherit;False;2;2;0;FLOAT;0.99;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1081;-8452.296,-890.5125;Float;False;Global;MoonDirLightColor;MoonDirLightColor;44;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-2307.674,-2102.25;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-6064.281,-2141.399;Inherit;False;314;TotalHorizonMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;952;-1767.385,-1837.813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;1093;1480.333,-1755.143;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1072;-7981.711,-1382.26;Float;False;SunLightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;583;-3787.022,-3378.877;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.AbsOpNode;44;-7795.364,-2730.654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;958;-2444.473,-2238.817;Float;False;Property;_SunDiskCloudsTransmissionIntensity;Sun Disk Clouds Transmission Intensity;21;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-7802.145,-2185.197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-8452.61,-2767.515;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;942;-2332.729,-1739.246;Inherit;False;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1076;-7981.552,-1304.155;Float;False;SunLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4235.022,-3058.877;Half;False;Property;_FogSmoothness;Fog Smoothness;19;0;Create;True;0;0;False;0;False;0.01;0.122;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-4261.198,-2021.038;Float;False;Property;_SunDiskSizeAdjust;Sun Disk Size Adjust;7;0;Create;True;0;0;False;0;False;0;0;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;947;-2135.227,-1733.331;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;592;-2827.022,-3186.877;Half;False;Constant;_Float41;Float 41;55;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;950;-1927.105,-2120.911;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1082;-7942.962,-895.1428;Float;False;MoonLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1102;2117.333,-2119.142;Float;False;Property;_SunGlow;SunGlow;23;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,1,0.9023998,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;898.4506,-1438.622;Float;False;SkyColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;1099;1680.333,-1618.143;Float;False;Property;_SunGlowScaleOffsetPower;SunGlowScaleOffsetPower;25;0;Create;True;0;0;False;0;False;0,0,0;1,0,66.76;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;252;-4255.772,-2252.467;Float;False;Property;_SunDiskSize;Sun Disk Size;6;0;Create;True;0;0;False;0;False;0;0.01;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1079;-7967.661,-1081.899;Float;False;MoonDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-3259.603,-2244.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-7799.547,-2272.297;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-911.0458,-1887.826;Float;False;Property;_NightColorTop;Night Color Top;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;1089;-8066.074,-1497.566;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;-3496.859,-2246.469;Float;False;SunDiskSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1071;-8208.742,-1492.023;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;933;-2109.753,-2041.923;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;268;-3717.819,-2252.427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;-561.6544,-1289.811;Float;False;NightTransScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;289;-5797.323,-2193.372;Inherit;False;Lerp White To;-1;;18;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1085;-4254.569,-1820.743;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1092;1227.333,-1787.143;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;1100;2695.333,-1909.143;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-4238.763,-2528.84;Float;False;Property;_NightTransitionHorizonDelay;Night Transition Horizon Delay;15;0;Create;True;0;0;False;0;False;0;-4.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;42;-8257.913,-2736.203;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;590;-2827.022,-3058.877;Half;False;Property;_FogFill;Fog Fill;18;0;Create;True;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1223;2363.597,-194.8843;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;297;-2934.906,-1966.745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1068;-2761.808,-1977.351;Float;False;Property;_SunDiskGlow;Sun Disk Glow;22;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-7976.095,-2132.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1078;-8157.503,-1086.529;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-6219.937,-3226.605;Inherit;False;197;SkyColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-6194.929,-2758.385;Float;False;Global;_HorizonColor;_Horizon Color;2;0;Create;True;0;0;False;0;False;0.9137255,0.8509804,0.7215686,0;0.882925,0.6844728,0.4615038,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;1097;2238.333,-1718.143;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;-3043.371,-2114.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;582;-3979.02,-3378.877;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-6073.199,-2050.299;Float;False;Property;_HorizonTintSunPower;Horizon Tint Sun Power;13;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;586;-3467.022,-3250.877;Half;False;Constant;_Float39;Float 39;55;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;587;-3211.023,-3058.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-5874.567,-2677.044;Float;False;HorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;585;-3467.022,-3378.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1090;1225.333,-1898.143;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;264;-3042.316,-2243.866;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;237;-3893.125,-2738.227;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-3669.823,-1744.45;Float;False;InvVDotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-5473.988,-2676.948;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-5365.045,-2131.549;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;300;-2967.63,-1765.923;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;956;-2654.001,-2242.046;Float;False;SunDiskMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;959;-2142.145,-2235.793;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;395;-6150.704,-2569.337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1103;2131.333,-1944.143;Float;False;Property;_SunGlowFar;SunGlowFar;24;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;281;-3985.405,-1873.9;Float;False;Property;_SunDiskSharpness;Sun Disk Sharpness;8;0;Create;True;0;0;False;0;False;0;0;0;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;594;-4235.022,-3186.877;Half;False;Property;_FogHeight;Fog Height;17;0;Create;True;0;0;False;0;False;1;0.624;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1104;2419.333,-1693.143;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;589;-3019.022,-3378.877;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-6022.634,-1971.189;Inherit;False;203;SunDisk;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-6051.268,-2237.611;Inherit;False;313;HorizonColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;1091;1648.333,-1839.143;Inherit;False;2;0;FLOAT3;0,1,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;69;-2474.651,-2107.593;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;1069;-8481.427,-1506.444;Float;False;Global;SunDirLightDirection;SunDirLightDirection;44;0;Create;True;0;0;False;0;False;0,0,0,0;-0.09010103,-0.314326,0.9450296,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;564;-366.0621,-2209.015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;939;-2325.773,-1957.965;Float;False;Property;_SunDiskIntensity;Sun Disk Intensity;20;0;Create;True;0;0;False;0;False;0;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;588;-3275.023,-3378.877;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;951;-1730.199,-2062.338;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-7988.094,-2261.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1084;-7530.41,-2050.117;Inherit;False;1070;SunDirection;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-7777.447,-2027.897;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-7853.091,-2383.479;Inherit;False;200;InvVDotL;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-2173.107,-2648.247;Float;False;Constant;_HideHorizonGlowScale;Hide Horizon Glow Scale;12;0;Create;True;0;0;False;0;False;4.14;4.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;568;-903.3739,-2062.666;Float;False;Property;_SkyGradientPower;Sky Gradient Power;4;0;Create;True;0;0;False;0;False;0;2.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;242;-3890.97,-2606.997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;565;-203.6511,-2216.562;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-2157.975,-2733.936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;62;-6571.195,-2321.984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1105;1885.358,-551.3749;Inherit;False;175;Sky;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;238;-3742.438,-2746.011;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1070;-7889.867,-1509.405;Float;False;SunDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-7780.047,-2112.397;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;578;-422.7684,-1780.97;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;570;-906.5739,-1984.266;Float;False;Property;_SkyGradientScale;Sky Gradient Scale;5;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-6317.039,-2583.552;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;261;-2872.972,-2165.903;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;303;-2480.372,-1755.841;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;581;-4235.022,-3378.877;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;241;-4180.15,-2614.813;Inherit;False;235;NightTransScale;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1080;-7964.573,-989.2928;Float;False;MoonLightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1161;2631.936,-479.2202;Float;False;True;-1;2;ASEMaterialInspector;100;1;DM/SkyboxSimpleClouds;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;1182;0;1178;2
WireConnection;1182;1;1179;0
WireConnection;1186;0;1180;0
WireConnection;1184;0;1178;1
WireConnection;1184;1;1178;3
WireConnection;1194;0;1183;2
WireConnection;1194;1;1185;0
WireConnection;1188;0;1184;0
WireConnection;1188;1;1182;0
WireConnection;1193;0;1181;0
WireConnection;1193;1;1186;0
WireConnection;1189;0;1183;1
WireConnection;1189;1;1183;3
WireConnection;1191;0;1180;0
WireConnection;1167;0;1165;0
WireConnection;1197;0;1190;0
WireConnection;1197;1;1191;0
WireConnection;1196;0;1189;0
WireConnection;1196;1;1194;0
WireConnection;1198;0;1186;0
WireConnection;1198;1;1195;0
WireConnection;1201;0;1188;0
WireConnection;1201;1;1187;0
WireConnection;1200;0;1192;0
WireConnection;1200;1;1193;0
WireConnection;1203;0;1201;0
WireConnection;1203;1;1198;0
WireConnection;1203;2;1199;0
WireConnection;1202;0;1201;0
WireConnection;1202;1;1200;0
WireConnection;1205;0;1196;0
WireConnection;1205;1;1197;0
WireConnection;1168;0;1167;0
WireConnection;1207;0;1204;0
WireConnection;1207;1;1203;0
WireConnection;1206;0;1204;0
WireConnection;1206;1;1205;0
WireConnection;1172;0;1168;1
WireConnection;1172;1;1170;0
WireConnection;1208;0;1204;0
WireConnection;1208;1;1202;0
WireConnection;1173;0;1219;0
WireConnection;1174;0;1173;0
WireConnection;1209;0;1208;1
WireConnection;1209;1;1207;1
WireConnection;1209;2;1206;1
WireConnection;1175;0;1172;0
WireConnection;1175;1;1171;0
WireConnection;1176;0;1175;0
WireConnection;1210;0;1209;0
WireConnection;1211;0;1210;0
WireConnection;1211;1;1216;0
WireConnection;1177;0;1176;0
WireConnection;1213;0;1211;0
WireConnection;1213;1;1212;1
WireConnection;1213;2;1212;2
WireConnection;1214;0;1213;0
WireConnection;1214;1;1217;0
WireConnection;1215;0;1214;0
WireConnection;1218;0;1215;0
WireConnection;1222;0;1220;0
WireConnection;569;0;567;0
WireConnection;569;1;570;0
WireConnection;13;0;201;0
WireConnection;13;1;26;0
WireConnection;13;2;27;0
WireConnection;13;3;28;0
WireConnection;13;4;29;0
WireConnection;47;0;44;0
WireConnection;81;0;92;0
WireConnection;239;0;238;0
WireConnection;239;1;242;0
WireConnection;304;0;240;0
WireConnection;223;0;222;0
WireConnection;223;3;244;0
WireConnection;14;0;13;0
WireConnection;573;0;571;0
WireConnection;40;0;42;0
WireConnection;575;0;56;0
WireConnection;575;1;574;0
WireConnection;575;2;576;0
WireConnection;240;0;239;0
WireConnection;571;0;569;0
WireConnection;88;0;1084;0
WireConnection;59;0;51;0
WireConnection;233;0;234;0
WireConnection;233;1;309;0
WireConnection;222;0;220;0
WireConnection;15;0;32;0
WireConnection;15;1;16;0
WireConnection;23;0;20;0
WireConnection;23;1;21;0
WireConnection;213;0;1086;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;12;0;34;0
WireConnection;12;1;11;0
WireConnection;563;0;566;0
WireConnection;221;0;213;0
WireConnection;78;0;575;0
WireConnection;78;1;578;0
WireConnection;78;2;84;0
WireConnection;220;0;215;0
WireConnection;220;1;216;0
WireConnection;567;0;565;0
WireConnection;567;1;568;0
WireConnection;314;0;395;0
WireConnection;32;0;14;0
WireConnection;84;0;85;0
WireConnection;92;0;1088;0
WireConnection;76;0;55;0
WireConnection;307;0;223;0
WireConnection;51;0;47;0
WireConnection;51;1;46;0
WireConnection;234;0;305;0
WireConnection;89;0;88;0
WireConnection;566;0;562;0
WireConnection;34;0;1085;0
WireConnection;284;0;252;0
WireConnection;284;1;285;0
WireConnection;203;0;951;0
WireConnection;265;0;75;0
WireConnection;265;1;75;0
WireConnection;271;0;282;0
WireConnection;90;0;89;0
WireConnection;85;0;81;0
WireConnection;85;1;235;0
WireConnection;19;0;15;0
WireConnection;19;1;17;0
WireConnection;19;2;90;0
WireConnection;302;0;300;2
WireConnection;298;0;261;0
WireConnection;298;1;303;0
WireConnection;175;0;76;0
WireConnection;953;0;69;0
WireConnection;290;0;289;0
WireConnection;290;1;291;0
WireConnection;1096;0;1091;0
WireConnection;1094;0;1096;0
WireConnection;1094;1;1099;1
WireConnection;1094;2;1099;2
WireConnection;591;0;589;0
WireConnection;593;0;591;0
WireConnection;593;1;592;0
WireConnection;593;2;590;0
WireConnection;75;0;200;0
WireConnection;282;1;281;0
WireConnection;71;0;69;0
WireConnection;71;1;1068;0
WireConnection;952;0;953;0
WireConnection;1093;0;1092;0
WireConnection;1072;0;1069;4
WireConnection;583;0;582;0
WireConnection;44;0;40;0
WireConnection;27;0;25;0
WireConnection;1076;0;1073;0
WireConnection;947;0;942;0
WireConnection;950;0;959;0
WireConnection;950;1;933;0
WireConnection;950;2;947;0
WireConnection;1082;0;1081;0
WireConnection;197;0;78;0
WireConnection;1079;0;1078;0
WireConnection;262;0;286;0
WireConnection;262;1;271;0
WireConnection;26;0;24;0
WireConnection;1089;0;1071;0
WireConnection;286;0;268;0
WireConnection;1071;0;1069;1
WireConnection;1071;1;1069;2
WireConnection;1071;2;1069;3
WireConnection;933;0;71;0
WireConnection;933;1;939;0
WireConnection;268;0;284;0
WireConnection;235;0;86;0
WireConnection;289;1;312;0
WireConnection;289;2;315;0
WireConnection;1100;0;1103;0
WireConnection;1100;1;1102;0
WireConnection;1100;2;1104;0
WireConnection;42;0;41;0
WireConnection;1223;0;1222;0
WireConnection;1223;3;1218;0
WireConnection;297;0;265;0
WireConnection;25;0;23;0
WireConnection;25;1;23;0
WireConnection;1078;0;1077;1
WireConnection;1078;1;1077;2
WireConnection;1078;2;1077;3
WireConnection;1097;0;1094;0
WireConnection;1097;1;1099;3
WireConnection;263;0;287;0
WireConnection;263;1;262;0
WireConnection;582;0;581;0
WireConnection;587;0;595;0
WireConnection;313;0;57;0
WireConnection;585;0;583;1
WireConnection;264;0;287;0
WireConnection;264;1;262;0
WireConnection;237;0;1087;0
WireConnection;200;0;12;0
WireConnection;55;0;198;0
WireConnection;55;1;313;0
WireConnection;55;2;314;0
WireConnection;288;0;290;0
WireConnection;288;1;204;0
WireConnection;956;0;69;0
WireConnection;959;0;958;0
WireConnection;959;1;71;0
WireConnection;395;0;63;0
WireConnection;1104;0;1097;0
WireConnection;589;0;588;0
WireConnection;589;1;587;0
WireConnection;1091;0;1090;0
WireConnection;1091;1;1093;0
WireConnection;69;0;298;0
WireConnection;564;0;563;0
WireConnection;588;0;585;0
WireConnection;588;1;586;0
WireConnection;588;2;594;0
WireConnection;588;3;586;0
WireConnection;588;4;584;0
WireConnection;951;0;950;0
WireConnection;951;1;952;0
WireConnection;24;0;22;0
WireConnection;24;1;22;0
WireConnection;242;0;241;0
WireConnection;242;1;243;0
WireConnection;565;0;564;0
WireConnection;215;0;221;0
WireConnection;62;0;19;0
WireConnection;238;0;237;0
WireConnection;1070;0;1089;0
WireConnection;578;0;79;0
WireConnection;578;1;577;0
WireConnection;578;2;579;0
WireConnection;63;0;233;0
WireConnection;63;1;59;0
WireConnection;63;2;62;0
WireConnection;261;0;297;0
WireConnection;261;1;264;0
WireConnection;261;2;263;0
WireConnection;303;0;302;0
WireConnection;1080;0;1077;4
WireConnection;1161;0;1223;0
ASEEND*/
//CHKSM=80C4D06EC4A161744300904EC1DC3479F6FCF65E