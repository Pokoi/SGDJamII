// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Ghost"
{
	Properties
	{
		_Color0("Color 0", Color) = (1,0,0,0)
		_TX_CutAlphaGhost("TX_CutAlphaGhost", 2D) = "white" {}
		_VelocityPanner("VelocityPanner", Vector) = (0.1,0,0,0)
		_MaskIntensity("MaskIntensity", Range( 0 , 2)) = 0
		_ColorIntensity("ColorIntensity", Range( 0 , 2)) = 0
		_Head("Head", 2D) = "white" {}
		_HeadIntensity("HeadIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _Head;
		uniform float4 _Head_ST;
		uniform float _HeadIntensity;
		uniform float _ColorIntensity;
		uniform sampler2D _TX_CutAlphaGhost;
		uniform float2 _VelocityPanner;
		uniform float _MaskIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Head = i.uv_texcoord * _Head_ST.xy + _Head_ST.zw;
			o.Emission = ( ( _Color0 + ( tex2D( _Head, uv_Head ) * _HeadIntensity ) ) * _ColorIntensity ).rgb;
			float2 panner4 = ( 1.0 * _Time.y * _VelocityPanner + i.uv_texcoord);
			o.Alpha = ( tex2D( _TX_CutAlphaGhost, panner4 ) * _MaskIntensity ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
1926;27;1906;921;2210.332;684.3863;1.5997;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1518.198,67.73465;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;12;-1513.544,237.7145;Float;False;Property;_VelocityPanner;VelocityPanner;2;0;Create;True;0;0;False;0;0.1,0;-0.02,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;23;-1541.873,-305.8836;Float;True;Property;_Head;Head;5;0;Create;True;0;0;False;0;6040436a55b572042a4540b70099e855;6040436a55b572042a4540b70099e855;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1436.371,-104.1201;Float;False;Property;_HeadIntensity;HeadIntensity;6;0;Create;True;0;0;False;0;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-1190.198,203.7346;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1130.865,-183.5994;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-1200.494,-487.0274;Float;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;1,0,0,0;0.8988771,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-976.3638,266.8364;Float;True;Property;_TX_CutAlphaGhost;TX_CutAlphaGhost;1;0;Create;True;0;0;False;0;7219c24c990890c43af83b5d0552a332;7219c24c990890c43af83b5d0552a332;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-959.9752,465.6479;Float;False;Property;_MaskIntensity;MaskIntensity;3;0;Create;True;0;0;False;0;0;0.993;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-819.5853,-203.3612;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-962.2273,-79.64893;Float;False;Property;_ColorIntensity;ColorIntensity;4;0;Create;True;0;0;False;0;0;1.008;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-549.5159,361.0725;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-657.9008,-137.9212;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-294.5967,-19.17988;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;S_Ghost;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;4;2;12;0
WireConnection;26;0;23;0
WireConnection;26;1;27;0
WireConnection;3;1;4;0
WireConnection;25;0;2;0
WireConnection;25;1;26;0
WireConnection;13;0;3;0
WireConnection;13;1;15;0
WireConnection;17;0;25;0
WireConnection;17;1;16;0
WireConnection;0;2;17;0
WireConnection;0;9;13;0
ASEEND*/
//CHKSM=8B8ECD74D85EB26252D1840154F64F775BCBAB0D