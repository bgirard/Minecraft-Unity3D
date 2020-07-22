// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DM/SkyboxStars"
{
	Properties
	{
		_Stars("Stars", CUBE) = "white" {}
		_SkyRotation("Sky Rotation", Vector) = (0,0,0,0)
		_Timescale("Timescale", Float) = 0
		_StarsLayersIntensity("Stars Layers Intensity", Vector) = (1,1,1,0)
		_StarsGlobalIntensity("Stars Global Intensity", Float) = 1
		_StarsSmoothstepMin("Stars Smoothstep Min", Range( -1 , 4)) = 0
		_StarsSmoothstepMax("Stars Smoothstep Max", Range( -1 , 4)) = 0
		_StarColor("Star Color", Color) = (0,0,0,0)
		_StarsFade("Stars Fade", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 vertexToFrag27_g1;
			float3 worldPos;
		};

		uniform float _StarsSmoothstepMin;
		uniform float _StarsSmoothstepMax;
		uniform samplerCUBE _Stars;
		uniform float2 _SkyRotation;
		uniform float _Timescale;
		uniform float3 _StarsLayersIntensity;
		uniform float4 _StarColor;
		uniform float _StarsGlobalIntensity;
		uniform float _StarsFade;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime6 = _Time.y * _Timescale;
			float2 appendResult32_g1 = (float2(( _SkyRotation.x * mulTime6 ) , ( _SkyRotation.y * mulTime6 )));
			float2 break8_g1 = radians( appendResult32_g1 );
			float temp_output_13_0_g1 = cos( break8_g1.x );
			float temp_output_9_0_g1 = sin( break8_g1.x );
			float3 appendResult16_g1 = (float3(temp_output_13_0_g1 , 0.0 , -temp_output_9_0_g1));
			float3 appendResult18_g1 = (float3(0.0 , 1.0 , 0.0));
			float3 appendResult19_g1 = (float3(temp_output_9_0_g1 , 0.0 , temp_output_13_0_g1));
			float3 appendResult15_g1 = (float3(1.0 , 0.0 , 0.0));
			float temp_output_12_0_g1 = cos( break8_g1.y );
			float temp_output_10_0_g1 = sin( break8_g1.y );
			float3 appendResult20_g1 = (float3(0.0 , temp_output_12_0_g1 , -temp_output_10_0_g1));
			float3 appendResult17_g1 = (float3(0.0 , temp_output_10_0_g1 , temp_output_12_0_g1));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 normalizeResult25_g1 = normalize( ase_worldPos );
			o.vertexToFrag27_g1 = mul( mul( float3x3(appendResult16_g1, appendResult18_g1, appendResult19_g1), float3x3(appendResult15_g1, appendResult20_g1, appendResult17_g1) ), normalizeResult25_g1 );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 texCUBENode2 = texCUBE( _Stars, i.vertexToFrag27_g1 );
			float smoothstepResult17 = smoothstep( _StarsSmoothstepMin , _StarsSmoothstepMax , ( texCUBENode2.r * _StarsLayersIntensity.x ));
			float smoothstepResult19 = smoothstep( _StarsSmoothstepMin , _StarsSmoothstepMax , ( texCUBENode2.g * _StarsLayersIntensity.y ));
			float smoothstepResult20 = smoothstep( _StarsSmoothstepMin , _StarsSmoothstepMax , ( texCUBENode2.b * _StarsLayersIntensity.z ));
			float temp_output_21_0 = ( smoothstepResult17 + smoothstepResult19 + smoothstepResult20 );
			float4 temp_output_22_0 = ( ( temp_output_21_0 * _StarColor ) * _StarsGlobalIntensity * _StarsFade );
			o.Emission = temp_output_22_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
211;126;1678;1046;1449.779;723.6609;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;9;-905.8719,-135.2075;Float;False;Property;_Timescale;Timescale;3;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-675.0683,-172.9081;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-676.368,-335.4076;Float;False;Property;_SkyRotation;Sky Rotation;2;0;Create;True;0;0;False;0;False;0,0;1,0.44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-416.3688,-197.6079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-417.6704,-314.6078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;-239.4795,-199.7609;Inherit;False;RotateCubemap2D;-1;;1;c131b3b80b5844c4c820f3488bd08e1a;0;2;28;FLOAT;0;False;29;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;42.73183,-286.6082;Inherit;True;Property;_Stars;Stars;1;0;Create;True;0;0;False;0;False;-1;None;d02849f9ba0efc4428dd3fd5608e1c99;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;14;34.08728,38.60529;Float;False;Property;_StarsLayersIntensity;Stars Layers Intensity;4;0;Create;True;0;0;False;0;False;1,1,1;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;570.0876,-209.3948;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;90.31409,448.1481;Float;False;Property;_StarsSmoothstepMax;Stars Smoothstep Max;7;0;Create;True;0;0;False;0;False;0;1.12;-1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;574.8879,1.805275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;574.8875,-105.3947;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;80.48767,321.8048;Float;False;Property;_StarsSmoothstepMin;Stars Smoothstep Min;6;0;Create;True;0;0;False;0;False;0;0.8;-1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;802.0876,33.80527;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;17;806.8873,-241.3949;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;808.4877,-105.3947;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;818.4281,184.6248;Float;False;Property;_StarColor;Star Color;9;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;1034.087,-167.7945;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;1223.495,-153.3981;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;817.2572,456.4914;Float;False;Property;_StarsFade;Stars Fade;10;0;Create;True;0;0;False;0;False;0;0.003440256;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;822.074,373.9529;Float;False;Property;_StarsGlobalIntensity;Stars Global Intensity;5;0;Create;True;0;0;False;0;False;1;5.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;886.871,-528.1826;Float;False;Property;_BackgroundColor;Background Color;8;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1455.08,-159.2105;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;31;1298.922,-518.405;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;28;1162.039,-294.9187;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;35;1628.41,-180.2345;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;DM/SkyboxStars;False;False;False;False;True;True;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;9;0
WireConnection;5;0;3;2
WireConnection;5;1;6;0
WireConnection;8;0;3;1
WireConnection;8;1;6;0
WireConnection;36;28;8;0
WireConnection;36;29;5;0
WireConnection;2;1;36;0
WireConnection;13;0;2;1
WireConnection;13;1;14;1
WireConnection;16;0;2;3
WireConnection;16;1;14;3
WireConnection;15;0;2;2
WireConnection;15;1;14;2
WireConnection;20;0;16;0
WireConnection;20;1;24;0
WireConnection;20;2;25;0
WireConnection;17;0;13;0
WireConnection;17;1;24;0
WireConnection;17;2;25;0
WireConnection;19;0;15;0
WireConnection;19;1;24;0
WireConnection;19;2;25;0
WireConnection;21;0;17;0
WireConnection;21;1;19;0
WireConnection;21;2;20;0
WireConnection;33;0;21;0
WireConnection;33;1;32;0
WireConnection;22;0;33;0
WireConnection;22;1;23;0
WireConnection;22;2;34;0
WireConnection;31;0;30;0
WireConnection;31;1;22;0
WireConnection;31;2;28;0
WireConnection;28;0;21;0
WireConnection;35;2;22;0
ASEEND*/
//CHKSM=0AE116AFE613BEC19D3046E1E0206A416BECF522