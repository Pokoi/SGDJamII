Shader "CloudGenerated"
{
    Properties
    {
        Vector4_8D860D8F("Rotate Projection", Vector) = (1, 0, 0, 90)
        Vector1_B1FFD6A1("Noise Scale", Float) = 10
        Vector1_1FB8F5E("Noise POwer", Float) = 1.49
        Vector4_1CD4A21A("Noise Remap", Vector) = (0, 1, -1, 1)
        Vector1_5F0B6D58("Noise Speed", Float) = 50
        Vector1_F48C110F("Base Speed", Float) = 30
        Vector1_48F8D2CE("Base Strength", Float) = 2
        Vector1_DEE5B51D("Fresnel Power", Float) = 8
        Vector1_52A4234E("Fresnel Opacity", Float) = 1.2
        Vector1_2330811F("Noise Height", Float) = 30
        Color_7838ADB3("Color Base", Color) = (0.3442061, 0.8018868, 0.383027, 0)
        Color_7B754E0F("Color Peak", Color) = (0, 0, 0, 0)
        Vector1_64EE49CE("Emission Strength", Float) = 2
        Vector1_A3EF069D("Curvature radius", Float) = 220.81
        Vector1_BEA8AAF5("Fade Depth", Float) = 189.8
        Vector2_530E3E4B("Tiling", Vector) = (10, 10, 0, 0)
        Vector1_3E60CD72("Noise Edge 1", Float) = 0
        Vector1_3F76FFCA("Noise Edge 2", Float) = 0
        Vector1_69315031("Base Scale", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_FORWARD
            #define REQUIRE_DEPTH_TEXTURE
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_8D860D8F;
            float Vector1_B1FFD6A1;
            float Vector1_1FB8F5E;
            float4 Vector4_1CD4A21A;
            float Vector1_5F0B6D58;
            float Vector1_F48C110F;
            float Vector1_48F8D2CE;
            float Vector1_DEE5B51D;
            float Vector1_52A4234E;
            float Vector1_2330811F;
            float4 Color_7838ADB3;
            float4 Color_7B754E0F;
            float Vector1_64EE49CE;
            float Vector1_A3EF069D;
            float Vector1_BEA8AAF5;
            float2 Vector2_530E3E4B;
            float Vector1_3E60CD72;
            float Vector1_3F76FFCA;
            float Vector1_69315031;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_D5084951_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                float _Divide_530808FD_Out_2;
                Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                float _Power_53938C01_Out_2;
                Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                float3 _Multiply_A431FD11_Out_2;
                Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float3 _Multiply_854B0633_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                float3 _Multiply_76D889A0_Out_2;
                Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                float3 _Add_BCB7AFD_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                float3 _Add_65E783E5_Out_2;
                Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                description.VertexPosition = _Add_65E783E5_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_FB0D29DD_Out_0 = Color_7838ADB3;
                float4 _Property_C942B902_Out_0 = Color_7B754E0F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float4 _Lerp_31D2C1F5_Out_3;
                Unity_Lerp_float4(_Property_FB0D29DD_Out_0, _Property_C942B902_Out_0, (_Divide_54C0CB48_Out_2.xxxx), _Lerp_31D2C1F5_Out_3);
                float _Property_40F7DF8_Out_0 = Vector1_DEE5B51D;
                float _FresnelEffect_955250D5_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_40F7DF8_Out_0, _FresnelEffect_955250D5_Out_3);
                float _Multiply_9031E310_Out_2;
                Unity_Multiply_float(_Divide_54C0CB48_Out_2, _FresnelEffect_955250D5_Out_3, _Multiply_9031E310_Out_2);
                float _Property_62CEAF64_Out_0 = Vector1_52A4234E;
                float _Multiply_201CD0D0_Out_2;
                Unity_Multiply_float(_Multiply_9031E310_Out_2, _Property_62CEAF64_Out_0, _Multiply_201CD0D0_Out_2);
                float4 _Add_89AD2985_Out_2;
                Unity_Add_float4(_Lerp_31D2C1F5_Out_3, (_Multiply_201CD0D0_Out_2.xxxx), _Add_89AD2985_Out_2);
                float _Property_10DA481C_Out_0 = Vector1_64EE49CE;
                float4 _Multiply_D9E068F3_Out_2;
                Unity_Multiply_float((_Property_10DA481C_Out_0.xxxx), _Lerp_31D2C1F5_Out_3, _Multiply_D9E068F3_Out_2);
                float _SceneDepth_3CA34D50_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                float _Subtract_BC526A39_Out_2;
                Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                float _Subtract_C5A988EF_Out_2;
                Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                float _Divide_17E0215F_Out_2;
                Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                float _Saturate_3BCB67B1_Out_1;
                Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                surface.Albedo = (_Add_89AD2985_Out_2.xyz);
                surface.Normal = IN.TangentSpaceNormal;
                surface.Emission = (_Multiply_D9E068F3_Out_2.xyz);
                surface.Metallic = 0;
                surface.Smoothness = 0.5;
                surface.Occlusion = 1;
                surface.Alpha = _Saturate_3BCB67B1_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float3 interp03 : TEXCOORD3;
                float2 interp04 : TEXCOORD4;
                float3 interp05 : TEXCOORD5;
                float4 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp04.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp05.xyz = input.sh;
                #endif
                output.interp06.xyzw = input.fogFactorAndVertexLight;
                output.interp07.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.viewDirectionWS = input.interp03.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp04.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp05.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp06.xyzw;
                output.shadowCoord = input.interp07.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
            
            
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_8D860D8F;
            float Vector1_B1FFD6A1;
            float Vector1_1FB8F5E;
            float4 Vector4_1CD4A21A;
            float Vector1_5F0B6D58;
            float Vector1_F48C110F;
            float Vector1_48F8D2CE;
            float Vector1_DEE5B51D;
            float Vector1_52A4234E;
            float Vector1_2330811F;
            float4 Color_7838ADB3;
            float4 Color_7B754E0F;
            float Vector1_64EE49CE;
            float Vector1_A3EF069D;
            float Vector1_BEA8AAF5;
            float2 Vector2_530E3E4B;
            float Vector1_3E60CD72;
            float Vector1_3F76FFCA;
            float Vector1_69315031;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_D5084951_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                float _Divide_530808FD_Out_2;
                Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                float _Power_53938C01_Out_2;
                Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                float3 _Multiply_A431FD11_Out_2;
                Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float3 _Multiply_854B0633_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                float3 _Multiply_76D889A0_Out_2;
                Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                float3 _Add_BCB7AFD_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                float3 _Add_65E783E5_Out_2;
                Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                description.VertexPosition = _Add_65E783E5_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 TangentSpaceNormal;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_3CA34D50_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                float _Subtract_BC526A39_Out_2;
                Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                float _Subtract_C5A988EF_Out_2;
                Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                float _Divide_17E0215F_Out_2;
                Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                float _Saturate_3BCB67B1_Out_1;
                Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                surface.Alpha = _Saturate_3BCB67B1_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_8D860D8F;
            float Vector1_B1FFD6A1;
            float Vector1_1FB8F5E;
            float4 Vector4_1CD4A21A;
            float Vector1_5F0B6D58;
            float Vector1_F48C110F;
            float Vector1_48F8D2CE;
            float Vector1_DEE5B51D;
            float Vector1_52A4234E;
            float Vector1_2330811F;
            float4 Color_7838ADB3;
            float4 Color_7B754E0F;
            float Vector1_64EE49CE;
            float Vector1_A3EF069D;
            float Vector1_BEA8AAF5;
            float2 Vector2_530E3E4B;
            float Vector1_3E60CD72;
            float Vector1_3F76FFCA;
            float Vector1_69315031;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_D5084951_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                float _Divide_530808FD_Out_2;
                Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                float _Power_53938C01_Out_2;
                Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                float3 _Multiply_A431FD11_Out_2;
                Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float3 _Multiply_854B0633_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                float3 _Multiply_76D889A0_Out_2;
                Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                float3 _Add_BCB7AFD_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                float3 _Add_65E783E5_Out_2;
                Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                description.VertexPosition = _Add_65E783E5_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 TangentSpaceNormal;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_3CA34D50_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                float _Subtract_BC526A39_Out_2;
                Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                float _Subtract_C5A988EF_Out_2;
                Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                float _Divide_17E0215F_Out_2;
                Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                float _Saturate_3BCB67B1_Out_1;
                Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                surface.Alpha = _Saturate_3BCB67B1_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "Meta"
            Tags 
            { 
                "LightMode" = "Meta"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_META
            #define REQUIRE_DEPTH_TEXTURE
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_8D860D8F;
            float Vector1_B1FFD6A1;
            float Vector1_1FB8F5E;
            float4 Vector4_1CD4A21A;
            float Vector1_5F0B6D58;
            float Vector1_F48C110F;
            float Vector1_48F8D2CE;
            float Vector1_DEE5B51D;
            float Vector1_52A4234E;
            float Vector1_2330811F;
            float4 Color_7838ADB3;
            float4 Color_7B754E0F;
            float Vector1_64EE49CE;
            float Vector1_A3EF069D;
            float Vector1_BEA8AAF5;
            float2 Vector2_530E3E4B;
            float Vector1_3E60CD72;
            float Vector1_3F76FFCA;
            float Vector1_69315031;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_D5084951_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                float _Divide_530808FD_Out_2;
                Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                float _Power_53938C01_Out_2;
                Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                float3 _Multiply_A431FD11_Out_2;
                Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float3 _Multiply_854B0633_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                float3 _Multiply_76D889A0_Out_2;
                Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                float3 _Add_BCB7AFD_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                float3 _Add_65E783E5_Out_2;
                Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                description.VertexPosition = _Add_65E783E5_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Emission;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_FB0D29DD_Out_0 = Color_7838ADB3;
                float4 _Property_C942B902_Out_0 = Color_7B754E0F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float4 _Lerp_31D2C1F5_Out_3;
                Unity_Lerp_float4(_Property_FB0D29DD_Out_0, _Property_C942B902_Out_0, (_Divide_54C0CB48_Out_2.xxxx), _Lerp_31D2C1F5_Out_3);
                float _Property_40F7DF8_Out_0 = Vector1_DEE5B51D;
                float _FresnelEffect_955250D5_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_40F7DF8_Out_0, _FresnelEffect_955250D5_Out_3);
                float _Multiply_9031E310_Out_2;
                Unity_Multiply_float(_Divide_54C0CB48_Out_2, _FresnelEffect_955250D5_Out_3, _Multiply_9031E310_Out_2);
                float _Property_62CEAF64_Out_0 = Vector1_52A4234E;
                float _Multiply_201CD0D0_Out_2;
                Unity_Multiply_float(_Multiply_9031E310_Out_2, _Property_62CEAF64_Out_0, _Multiply_201CD0D0_Out_2);
                float4 _Add_89AD2985_Out_2;
                Unity_Add_float4(_Lerp_31D2C1F5_Out_3, (_Multiply_201CD0D0_Out_2.xxxx), _Add_89AD2985_Out_2);
                float _Property_10DA481C_Out_0 = Vector1_64EE49CE;
                float4 _Multiply_D9E068F3_Out_2;
                Unity_Multiply_float((_Property_10DA481C_Out_0.xxxx), _Lerp_31D2C1F5_Out_3, _Multiply_D9E068F3_Out_2);
                float _SceneDepth_3CA34D50_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                float _Subtract_BC526A39_Out_2;
                Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                float _Subtract_C5A988EF_Out_2;
                Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                float _Divide_17E0215F_Out_2;
                Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                float _Saturate_3BCB67B1_Out_1;
                Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                surface.Albedo = (_Add_89AD2985_Out_2.xyz);
                surface.Emission = (_Multiply_D9E068F3_Out_2.xyz);
                surface.Alpha = _Saturate_3BCB67B1_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
            
            
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            // Name: <None>
            Tags 
            { 
                "LightMode" = "Universal2D"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_2D
            #define REQUIRE_DEPTH_TEXTURE
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_8D860D8F;
            float Vector1_B1FFD6A1;
            float Vector1_1FB8F5E;
            float4 Vector4_1CD4A21A;
            float Vector1_5F0B6D58;
            float Vector1_F48C110F;
            float Vector1_48F8D2CE;
            float Vector1_DEE5B51D;
            float Vector1_52A4234E;
            float Vector1_2330811F;
            float4 Color_7838ADB3;
            float4 Color_7B754E0F;
            float Vector1_64EE49CE;
            float Vector1_A3EF069D;
            float Vector1_BEA8AAF5;
            float2 Vector2_530E3E4B;
            float Vector1_3E60CD72;
            float Vector1_3F76FFCA;
            float Vector1_69315031;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_D5084951_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                float _Divide_530808FD_Out_2;
                Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                float _Power_53938C01_Out_2;
                Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                float3 _Multiply_A431FD11_Out_2;
                Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float3 _Multiply_854B0633_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                float3 _Multiply_76D889A0_Out_2;
                Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                float3 _Add_BCB7AFD_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                float3 _Add_65E783E5_Out_2;
                Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                description.VertexPosition = _Add_65E783E5_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_FB0D29DD_Out_0 = Color_7838ADB3;
                float4 _Property_C942B902_Out_0 = Color_7B754E0F;
                float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                float3 _RotateAboutAxis_B322FEFB_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                float _Multiply_892E9609_Out_2;
                Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                float2 _TilingAndOffset_7E4525F6_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                float _GradientNoise_93A0065E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                float2 _TilingAndOffset_9ED6A4D7_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                float _GradientNoise_5B68DAAA_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                float _Add_B5636CC_Out_2;
                Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                float _Divide_B4A9CAB8_Out_2;
                Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                float _Saturate_EF9007D2_Out_1;
                Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                float _Power_1F04B9C8_Out_2;
                Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                float4 _Combine_68D2E9F1_RGBA_4;
                float3 _Combine_68D2E9F1_RGB_5;
                float2 _Combine_68D2E9F1_RG_6;
                Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                float4 _Combine_7074AA82_RGBA_4;
                float3 _Combine_7074AA82_RGB_5;
                float2 _Combine_7074AA82_RG_6;
                Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                float _Remap_5134C4F6_Out_3;
                Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                float _Absolute_6ACCA602_Out_1;
                Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                float _Smoothstep_44B217D8_Out_3;
                Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                float _Multiply_3B47E2E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                float2 _TilingAndOffset_AC16A3F0_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                float _Property_576D710C_Out_0 = Vector1_69315031;
                float _GradientNoise_6176A24A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                float _Add_111C237E_Out_2;
                Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                float _Multiply_F4E12D57_Out_2;
                Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                float _Add_7311E555_Out_2;
                Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                float _Divide_54C0CB48_Out_2;
                Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                float4 _Lerp_31D2C1F5_Out_3;
                Unity_Lerp_float4(_Property_FB0D29DD_Out_0, _Property_C942B902_Out_0, (_Divide_54C0CB48_Out_2.xxxx), _Lerp_31D2C1F5_Out_3);
                float _Property_40F7DF8_Out_0 = Vector1_DEE5B51D;
                float _FresnelEffect_955250D5_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_40F7DF8_Out_0, _FresnelEffect_955250D5_Out_3);
                float _Multiply_9031E310_Out_2;
                Unity_Multiply_float(_Divide_54C0CB48_Out_2, _FresnelEffect_955250D5_Out_3, _Multiply_9031E310_Out_2);
                float _Property_62CEAF64_Out_0 = Vector1_52A4234E;
                float _Multiply_201CD0D0_Out_2;
                Unity_Multiply_float(_Multiply_9031E310_Out_2, _Property_62CEAF64_Out_0, _Multiply_201CD0D0_Out_2);
                float4 _Add_89AD2985_Out_2;
                Unity_Add_float4(_Lerp_31D2C1F5_Out_3, (_Multiply_201CD0D0_Out_2.xxxx), _Add_89AD2985_Out_2);
                float _SceneDepth_3CA34D50_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                float _Subtract_BC526A39_Out_2;
                Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                float _Subtract_C5A988EF_Out_2;
                Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                float _Divide_17E0215F_Out_2;
                Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                float _Saturate_3BCB67B1_Out_1;
                Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                surface.Albedo = (_Add_89AD2985_Out_2.xyz);
                surface.Alpha = _Saturate_3BCB67B1_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
            
            
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="HDLitShader"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            // based on HDPBRPass.template
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            
            ZWrite On
        
            
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 playstation xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_SHADOWS
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   DoubleSided
                //   DoubleSided.Mirror
                //   FragInputs.isFrontFace
                //   features.NormalDropOffTS
                //   SurfaceType.Transparent
                //   BlendMode.Alpha
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   VaryingsMeshToPS.cullFace
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   FragInputs.positionRWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
        
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            // #define _BLENDMODE_ADD 1
            // #define _BLENDMODE_PRE_MULTIPLY 1
            #define _DOUBLESIDED_ON 1
            #define _NORMAL_DROPOFF_TS	1
            // #define _NORMAL_DROPOFF_OS	1
            // #define _NORMAL_DROPOFF_WS	1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        	
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
            #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            //Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_8D860D8F;
                    float Vector1_B1FFD6A1;
                    float Vector1_1FB8F5E;
                    float4 Vector4_1CD4A21A;
                    float Vector1_5F0B6D58;
                    float Vector1_F48C110F;
                    float Vector1_48F8D2CE;
                    float Vector1_DEE5B51D;
                    float Vector1_52A4234E;
                    float Vector1_2330811F;
                    float4 Color_7838ADB3;
                    float4 Color_7B754E0F;
                    float Vector1_64EE49CE;
                    float Vector1_A3EF069D;
                    float Vector1_BEA8AAF5;
                    float2 Vector2_530E3E4B;
                    float Vector1_3E60CD72;
                    float Vector1_3F76FFCA;
                    float Vector1_69315031;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_D5084951_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                        float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                        float _Divide_530808FD_Out_2;
                        Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                        float _Power_53938C01_Out_2;
                        Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                        float3 _Multiply_A431FD11_Out_2;
                        Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                        float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                        float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                        float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                        float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                        float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                        float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                        float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                        float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                        float3 _RotateAboutAxis_B322FEFB_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                        float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                        float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                        float _Multiply_892E9609_Out_2;
                        Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                        float2 _TilingAndOffset_7E4525F6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                        float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                        float _GradientNoise_93A0065E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                        float2 _TilingAndOffset_9ED6A4D7_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                        float _GradientNoise_5B68DAAA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                        float _Add_B5636CC_Out_2;
                        Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                        float _Divide_B4A9CAB8_Out_2;
                        Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                        float _Saturate_EF9007D2_Out_1;
                        Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                        float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                        float _Power_1F04B9C8_Out_2;
                        Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                        float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                        float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                        float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                        float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                        float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                        float4 _Combine_68D2E9F1_RGBA_4;
                        float3 _Combine_68D2E9F1_RGB_5;
                        float2 _Combine_68D2E9F1_RG_6;
                        Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                        float4 _Combine_7074AA82_RGBA_4;
                        float3 _Combine_7074AA82_RGB_5;
                        float2 _Combine_7074AA82_RG_6;
                        Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                        float _Remap_5134C4F6_Out_3;
                        Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                        float _Absolute_6ACCA602_Out_1;
                        Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                        float _Smoothstep_44B217D8_Out_3;
                        Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                        float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                        float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                        float _Multiply_3B47E2E0_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                        float2 _TilingAndOffset_AC16A3F0_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                        float _Property_576D710C_Out_0 = Vector1_69315031;
                        float _GradientNoise_6176A24A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                        float _Add_111C237E_Out_2;
                        Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                        float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                        float _Multiply_F4E12D57_Out_2;
                        Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                        float _Add_7311E555_Out_2;
                        Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                        float _Divide_54C0CB48_Out_2;
                        Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                        float3 _Multiply_854B0633_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                        float3 _Multiply_76D889A0_Out_2;
                        Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                        float3 _Add_BCB7AFD_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                        float3 _Add_65E783E5_Out_2;
                        Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                        description.VertexPosition = _Add_65E783E5_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_3CA34D50_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                        float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                        float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                        float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                        float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                        float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                        float _Subtract_BC526A39_Out_2;
                        Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                        float _Subtract_C5A988EF_Out_2;
                        Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                        float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                        float _Divide_17E0215F_Out_2;
                        Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                        float _Saturate_3BCB67B1_Out_1;
                        Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                        surface.Alpha = _Saturate_3BCB67B1_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
                surfaceData.ambientOcclusion = 1.0;
                surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.
        
                // copy across graph values, if defined
                // surfaceData.baseColor =             surfaceDescription.Albedo;
                // surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
                // surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
                // surfaceData.metallic =              surfaceDescription.Metallic;
                // surfaceData.specularColor =         surfaceDescription.Specular;
        
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                // normal delivered to master node
                float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
                // normalSrc = surfaceDescription.Normal;
        
                // compute world space normal
        #if _NORMAL_DROPOFF_TS
                GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
        #elif _NORMAL_DROPOFF_OS
        		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
        #elif _NORMAL_DROPOFF_WS
        		surfaceData.normalWS = normalSrc;
        #endif
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDPBRPass.template
            Name "META"
            Tags { "LightMode" = "META" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull Off
        
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 playstation xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   DoubleSided
                //   DoubleSided.Mirror
                //   FragInputs.isFrontFace
                //   features.NormalDropOffTS
                //   SurfaceType.Transparent
                //   BlendMode.Alpha
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   SurfaceDescription.Albedo
                //   SurfaceDescription.Normal
                //   SurfaceDescription.Metallic
                //   SurfaceDescription.Emission
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Occlusion
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.uv0
                //   AttributesMesh.uv1
                //   AttributesMesh.color
                //   AttributesMesh.uv2
                //   VaryingsMeshToPS.cullFace
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   AttributesMesh.positionOS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
        
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            // #define _BLENDMODE_ADD 1
            // #define _BLENDMODE_PRE_MULTIPLY 1
            #define _DOUBLESIDED_ON 1
            #define _NORMAL_DROPOFF_TS	1
            // #define _NORMAL_DROPOFF_OS	1
            // #define _NORMAL_DROPOFF_WS	1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        	
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
            #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            //Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_8D860D8F;
                    float Vector1_B1FFD6A1;
                    float Vector1_1FB8F5E;
                    float4 Vector4_1CD4A21A;
                    float Vector1_5F0B6D58;
                    float Vector1_F48C110F;
                    float Vector1_48F8D2CE;
                    float Vector1_DEE5B51D;
                    float Vector1_52A4234E;
                    float Vector1_2330811F;
                    float4 Color_7838ADB3;
                    float4 Color_7B754E0F;
                    float Vector1_64EE49CE;
                    float Vector1_A3EF069D;
                    float Vector1_BEA8AAF5;
                    float2 Vector2_530E3E4B;
                    float Vector1_3E60CD72;
                    float Vector1_3F76FFCA;
                    float Vector1_69315031;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_FB0D29DD_Out_0 = Color_7838ADB3;
                        float4 _Property_C942B902_Out_0 = Color_7B754E0F;
                        float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                        float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                        float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                        float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                        float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                        float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                        float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                        float3 _RotateAboutAxis_B322FEFB_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                        float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                        float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                        float _Multiply_892E9609_Out_2;
                        Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                        float2 _TilingAndOffset_7E4525F6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                        float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                        float _GradientNoise_93A0065E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                        float2 _TilingAndOffset_9ED6A4D7_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                        float _GradientNoise_5B68DAAA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                        float _Add_B5636CC_Out_2;
                        Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                        float _Divide_B4A9CAB8_Out_2;
                        Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                        float _Saturate_EF9007D2_Out_1;
                        Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                        float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                        float _Power_1F04B9C8_Out_2;
                        Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                        float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                        float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                        float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                        float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                        float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                        float4 _Combine_68D2E9F1_RGBA_4;
                        float3 _Combine_68D2E9F1_RGB_5;
                        float2 _Combine_68D2E9F1_RG_6;
                        Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                        float4 _Combine_7074AA82_RGBA_4;
                        float3 _Combine_7074AA82_RGB_5;
                        float2 _Combine_7074AA82_RG_6;
                        Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                        float _Remap_5134C4F6_Out_3;
                        Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                        float _Absolute_6ACCA602_Out_1;
                        Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                        float _Smoothstep_44B217D8_Out_3;
                        Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                        float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                        float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                        float _Multiply_3B47E2E0_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                        float2 _TilingAndOffset_AC16A3F0_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                        float _Property_576D710C_Out_0 = Vector1_69315031;
                        float _GradientNoise_6176A24A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                        float _Add_111C237E_Out_2;
                        Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                        float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                        float _Multiply_F4E12D57_Out_2;
                        Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                        float _Add_7311E555_Out_2;
                        Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                        float _Divide_54C0CB48_Out_2;
                        Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                        float4 _Lerp_31D2C1F5_Out_3;
                        Unity_Lerp_float4(_Property_FB0D29DD_Out_0, _Property_C942B902_Out_0, (_Divide_54C0CB48_Out_2.xxxx), _Lerp_31D2C1F5_Out_3);
                        float _Property_40F7DF8_Out_0 = Vector1_DEE5B51D;
                        float _FresnelEffect_955250D5_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_40F7DF8_Out_0, _FresnelEffect_955250D5_Out_3);
                        float _Multiply_9031E310_Out_2;
                        Unity_Multiply_float(_Divide_54C0CB48_Out_2, _FresnelEffect_955250D5_Out_3, _Multiply_9031E310_Out_2);
                        float _Property_62CEAF64_Out_0 = Vector1_52A4234E;
                        float _Multiply_201CD0D0_Out_2;
                        Unity_Multiply_float(_Multiply_9031E310_Out_2, _Property_62CEAF64_Out_0, _Multiply_201CD0D0_Out_2);
                        float4 _Add_89AD2985_Out_2;
                        Unity_Add_float4(_Lerp_31D2C1F5_Out_3, (_Multiply_201CD0D0_Out_2.xxxx), _Add_89AD2985_Out_2);
                        float _Property_10DA481C_Out_0 = Vector1_64EE49CE;
                        float4 _Multiply_D9E068F3_Out_2;
                        Unity_Multiply_float((_Property_10DA481C_Out_0.xxxx), _Lerp_31D2C1F5_Out_3, _Multiply_D9E068F3_Out_2);
                        float _SceneDepth_3CA34D50_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                        float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                        float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                        float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                        float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                        float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                        float _Subtract_BC526A39_Out_2;
                        Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                        float _Subtract_C5A988EF_Out_2;
                        Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                        float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                        float _Divide_17E0215F_Out_2;
                        Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                        float _Saturate_3BCB67B1_Out_1;
                        Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                        surface.Albedo = (_Add_89AD2985_Out_2.xyz);
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.Metallic = 0;
                        surface.Emission = (_Multiply_D9E068F3_Out_2.xyz);
                        surface.Smoothness = 0.5;
                        surface.Occlusion = 1;
                        surface.Alpha = _Saturate_3BCB67B1_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                // output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                // output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                // vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                // input.normalOS = vertexDescription.VertexNormal;
                // input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
                surfaceData.ambientOcclusion = 1.0;
                surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.
        
                // copy across graph values, if defined
                surfaceData.baseColor =             surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
                surfaceData.metallic =              surfaceDescription.Metallic;
                // surfaceData.specularColor =         surfaceDescription.Specular;
        
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                // normal delivered to master node
                float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
                normalSrc = surfaceDescription.Normal;
        
                // compute world space normal
        #if _NORMAL_DROPOFF_TS
                GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
        #elif _NORMAL_DROPOFF_OS
        		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
        #elif _NORMAL_DROPOFF_WS
        		surfaceData.normalWS = normalSrc;
        #endif
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassLightTransport.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDPBRPass.template
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull Off
        
            
            ZWrite Off
        
            
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 playstation xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #define SCENESELECTIONPASS
                #pragma editor_sync_compilation
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   DoubleSided
                //   DoubleSided.Mirror
                //   FragInputs.isFrontFace
                //   features.NormalDropOffTS
                //   SurfaceType.Transparent
                //   BlendMode.Alpha
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   VaryingsMeshToPS.cullFace
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   FragInputs.positionRWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
        
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            // #define _BLENDMODE_ADD 1
            // #define _BLENDMODE_PRE_MULTIPLY 1
            #define _DOUBLESIDED_ON 1
            #define _NORMAL_DROPOFF_TS	1
            // #define _NORMAL_DROPOFF_OS	1
            // #define _NORMAL_DROPOFF_WS	1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        	
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
            #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            //Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_8D860D8F;
                    float Vector1_B1FFD6A1;
                    float Vector1_1FB8F5E;
                    float4 Vector4_1CD4A21A;
                    float Vector1_5F0B6D58;
                    float Vector1_F48C110F;
                    float Vector1_48F8D2CE;
                    float Vector1_DEE5B51D;
                    float Vector1_52A4234E;
                    float Vector1_2330811F;
                    float4 Color_7838ADB3;
                    float4 Color_7B754E0F;
                    float Vector1_64EE49CE;
                    float Vector1_A3EF069D;
                    float Vector1_BEA8AAF5;
                    float2 Vector2_530E3E4B;
                    float Vector1_3E60CD72;
                    float Vector1_3F76FFCA;
                    float Vector1_69315031;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_D5084951_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                        float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                        float _Divide_530808FD_Out_2;
                        Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                        float _Power_53938C01_Out_2;
                        Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                        float3 _Multiply_A431FD11_Out_2;
                        Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                        float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                        float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                        float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                        float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                        float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                        float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                        float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                        float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                        float3 _RotateAboutAxis_B322FEFB_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                        float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                        float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                        float _Multiply_892E9609_Out_2;
                        Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                        float2 _TilingAndOffset_7E4525F6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                        float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                        float _GradientNoise_93A0065E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                        float2 _TilingAndOffset_9ED6A4D7_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                        float _GradientNoise_5B68DAAA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                        float _Add_B5636CC_Out_2;
                        Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                        float _Divide_B4A9CAB8_Out_2;
                        Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                        float _Saturate_EF9007D2_Out_1;
                        Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                        float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                        float _Power_1F04B9C8_Out_2;
                        Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                        float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                        float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                        float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                        float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                        float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                        float4 _Combine_68D2E9F1_RGBA_4;
                        float3 _Combine_68D2E9F1_RGB_5;
                        float2 _Combine_68D2E9F1_RG_6;
                        Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                        float4 _Combine_7074AA82_RGBA_4;
                        float3 _Combine_7074AA82_RGB_5;
                        float2 _Combine_7074AA82_RG_6;
                        Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                        float _Remap_5134C4F6_Out_3;
                        Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                        float _Absolute_6ACCA602_Out_1;
                        Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                        float _Smoothstep_44B217D8_Out_3;
                        Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                        float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                        float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                        float _Multiply_3B47E2E0_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                        float2 _TilingAndOffset_AC16A3F0_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                        float _Property_576D710C_Out_0 = Vector1_69315031;
                        float _GradientNoise_6176A24A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                        float _Add_111C237E_Out_2;
                        Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                        float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                        float _Multiply_F4E12D57_Out_2;
                        Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                        float _Add_7311E555_Out_2;
                        Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                        float _Divide_54C0CB48_Out_2;
                        Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                        float3 _Multiply_854B0633_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                        float3 _Multiply_76D889A0_Out_2;
                        Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                        float3 _Add_BCB7AFD_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                        float3 _Add_65E783E5_Out_2;
                        Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                        description.VertexPosition = _Add_65E783E5_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_3CA34D50_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                        float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                        float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                        float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                        float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                        float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                        float _Subtract_BC526A39_Out_2;
                        Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                        float _Subtract_C5A988EF_Out_2;
                        Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                        float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                        float _Divide_17E0215F_Out_2;
                        Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                        float _Saturate_3BCB67B1_Out_1;
                        Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                        surface.Alpha = _Saturate_3BCB67B1_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
                surfaceData.ambientOcclusion = 1.0;
                surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.
        
                // copy across graph values, if defined
                // surfaceData.baseColor =             surfaceDescription.Albedo;
                // surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
                // surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
                // surfaceData.metallic =              surfaceDescription.Metallic;
                // surfaceData.specularColor =         surfaceDescription.Specular;
        
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                // normal delivered to master node
                float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
                // normalSrc = surfaceDescription.Normal;
        
                // compute world space normal
        #if _NORMAL_DROPOFF_TS
                GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
        #elif _NORMAL_DROPOFF_OS
        		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
        #elif _NORMAL_DROPOFF_WS
        		surfaceData.normalWS = normalSrc;
        #endif
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDPBRPass.template
            Name "Forward"
            Tags { "LightMode" = "Forward" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        
            Cull Off
        
            
            
            
            // Stencil setup
        Stencil
        {
           WriteMask 6
           Ref  0
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 playstation xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_FORWARD
                #pragma only_renderers d3d11 playstation xboxone vulkan metal switch
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
                #define USE_CLUSTERED_LIGHTLIST
                #pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH
                #define RAYTRACING_SHADER_GRAPH_HIGH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   DoubleSided
                //   DoubleSided.Mirror
                //   FragInputs.isFrontFace
                //   features.NormalDropOffTS
                //   SurfaceType.Transparent
                //   BlendMode.Alpha
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.TangentSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Albedo
                //   SurfaceDescription.Normal
                //   SurfaceDescription.Metallic
                //   SurfaceDescription.Emission
                //   SurfaceDescription.Smoothness
                //   SurfaceDescription.Occlusion
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   FragInputs.texCoord1
                //   FragInputs.texCoord2
                //   VaryingsMeshToPS.cullFace
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
                //   VaryingsMeshToPS.texCoord1
                //   VaryingsMeshToPS.texCoord2
                //   AttributesMesh.uv1
                //   AttributesMesh.uv2
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
        
            // #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            // #define _BLENDMODE_ADD 1
            // #define _BLENDMODE_PRE_MULTIPLY 1
            #define _DOUBLESIDED_ON 1
            #define _NORMAL_DROPOFF_TS	1
            // #define _NORMAL_DROPOFF_OS	1
            // #define _NORMAL_DROPOFF_WS	1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        	
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
            #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            //Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                float4 texCoord1; // optional
                float4 texCoord2; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                float4 interp03 : TEXCOORD3; // auto-packed
                float4 interp04 : TEXCOORD4; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord1;
                output.interp04.xyzw = input.texCoord2;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord1 = input.interp03.xyzw;
                output.texCoord2 = input.interp04.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_8D860D8F;
                    float Vector1_B1FFD6A1;
                    float Vector1_1FB8F5E;
                    float4 Vector4_1CD4A21A;
                    float Vector1_5F0B6D58;
                    float Vector1_F48C110F;
                    float Vector1_48F8D2CE;
                    float Vector1_DEE5B51D;
                    float Vector1_52A4234E;
                    float Vector1_2330811F;
                    float4 Color_7838ADB3;
                    float4 Color_7B754E0F;
                    float Vector1_64EE49CE;
                    float Vector1_A3EF069D;
                    float Vector1_BEA8AAF5;
                    float2 Vector2_530E3E4B;
                    float Vector1_3E60CD72;
                    float Vector1_3F76FFCA;
                    float Vector1_69315031;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 TangentSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_D5084951_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_D5084951_Out_2);
                        float _Property_999211F5_Out_0 = Vector1_A3EF069D;
                        float _Divide_530808FD_Out_2;
                        Unity_Divide_float(_Distance_D5084951_Out_2, _Property_999211F5_Out_0, _Divide_530808FD_Out_2);
                        float _Power_53938C01_Out_2;
                        Unity_Power_float(_Divide_530808FD_Out_2, 3, _Power_53938C01_Out_2);
                        float3 _Multiply_A431FD11_Out_2;
                        Unity_Multiply_float((_Power_53938C01_Out_2.xxx), IN.WorldSpaceNormal, _Multiply_A431FD11_Out_2);
                        float _Property_FB964FB1_Out_0 = Vector1_2330811F;
                        float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                        float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                        float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                        float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                        float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                        float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                        float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                        float3 _RotateAboutAxis_B322FEFB_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                        float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                        float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                        float _Multiply_892E9609_Out_2;
                        Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                        float2 _TilingAndOffset_7E4525F6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                        float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                        float _GradientNoise_93A0065E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                        float2 _TilingAndOffset_9ED6A4D7_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                        float _GradientNoise_5B68DAAA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                        float _Add_B5636CC_Out_2;
                        Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                        float _Divide_B4A9CAB8_Out_2;
                        Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                        float _Saturate_EF9007D2_Out_1;
                        Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                        float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                        float _Power_1F04B9C8_Out_2;
                        Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                        float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                        float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                        float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                        float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                        float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                        float4 _Combine_68D2E9F1_RGBA_4;
                        float3 _Combine_68D2E9F1_RGB_5;
                        float2 _Combine_68D2E9F1_RG_6;
                        Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                        float4 _Combine_7074AA82_RGBA_4;
                        float3 _Combine_7074AA82_RGB_5;
                        float2 _Combine_7074AA82_RG_6;
                        Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                        float _Remap_5134C4F6_Out_3;
                        Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                        float _Absolute_6ACCA602_Out_1;
                        Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                        float _Smoothstep_44B217D8_Out_3;
                        Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                        float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                        float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                        float _Multiply_3B47E2E0_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                        float2 _TilingAndOffset_AC16A3F0_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                        float _Property_576D710C_Out_0 = Vector1_69315031;
                        float _GradientNoise_6176A24A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                        float _Add_111C237E_Out_2;
                        Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                        float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                        float _Multiply_F4E12D57_Out_2;
                        Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                        float _Add_7311E555_Out_2;
                        Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                        float _Divide_54C0CB48_Out_2;
                        Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                        float3 _Multiply_854B0633_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_54C0CB48_Out_2.xxx), _Multiply_854B0633_Out_2);
                        float3 _Multiply_76D889A0_Out_2;
                        Unity_Multiply_float((_Property_FB964FB1_Out_0.xxx), _Multiply_854B0633_Out_2, _Multiply_76D889A0_Out_2);
                        float3 _Add_BCB7AFD_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_76D889A0_Out_2, _Add_BCB7AFD_Out_2);
                        float3 _Add_65E783E5_Out_2;
                        Unity_Add_float3(_Multiply_A431FD11_Out_2, _Add_BCB7AFD_Out_2, _Add_65E783E5_Out_2);
                        description.VertexPosition = _Add_65E783E5_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_FB0D29DD_Out_0 = Color_7838ADB3;
                        float4 _Property_C942B902_Out_0 = Color_7B754E0F;
                        float _Property_E8D1E28F_Out_0 = Vector1_3E60CD72;
                        float _Property_C8D979CD_Out_0 = Vector1_3F76FFCA;
                        float4 _Property_E8586EB6_Out_0 = Vector4_8D860D8F;
                        float _Split_CC0BB54D_R_1 = _Property_E8586EB6_Out_0[0];
                        float _Split_CC0BB54D_G_2 = _Property_E8586EB6_Out_0[1];
                        float _Split_CC0BB54D_B_3 = _Property_E8586EB6_Out_0[2];
                        float _Split_CC0BB54D_A_4 = _Property_E8586EB6_Out_0[3];
                        float3 _RotateAboutAxis_B322FEFB_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_E8586EB6_Out_0.xyz), _Split_CC0BB54D_A_4, _RotateAboutAxis_B322FEFB_Out_3);
                        float2 _Property_6C5368A0_Out_0 = Vector2_530E3E4B;
                        float _Property_3DD862D1_Out_0 = Vector1_5F0B6D58;
                        float _Multiply_892E9609_Out_2;
                        Unity_Multiply_float(_Property_3DD862D1_Out_0, IN.TimeParameters.x, _Multiply_892E9609_Out_2);
                        float2 _TilingAndOffset_7E4525F6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_6C5368A0_Out_0, (_Multiply_892E9609_Out_2.xx), _TilingAndOffset_7E4525F6_Out_3);
                        float _Property_34D89B9E_Out_0 = Vector1_B1FFD6A1;
                        float _GradientNoise_93A0065E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7E4525F6_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_93A0065E_Out_2);
                        float2 _TilingAndOffset_9ED6A4D7_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_9ED6A4D7_Out_3);
                        float _GradientNoise_5B68DAAA_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_9ED6A4D7_Out_3, _Property_34D89B9E_Out_0, _GradientNoise_5B68DAAA_Out_2);
                        float _Add_B5636CC_Out_2;
                        Unity_Add_float(_GradientNoise_93A0065E_Out_2, _GradientNoise_5B68DAAA_Out_2, _Add_B5636CC_Out_2);
                        float _Divide_B4A9CAB8_Out_2;
                        Unity_Divide_float(_Add_B5636CC_Out_2, 2, _Divide_B4A9CAB8_Out_2);
                        float _Saturate_EF9007D2_Out_1;
                        Unity_Saturate_float(_Divide_B4A9CAB8_Out_2, _Saturate_EF9007D2_Out_1);
                        float _Property_71FEB00F_Out_0 = Vector1_1FB8F5E;
                        float _Power_1F04B9C8_Out_2;
                        Unity_Power_float(_Saturate_EF9007D2_Out_1, _Property_71FEB00F_Out_0, _Power_1F04B9C8_Out_2);
                        float4 _Property_CDF6AAAF_Out_0 = Vector4_1CD4A21A;
                        float _Split_A1F00803_R_1 = _Property_CDF6AAAF_Out_0[0];
                        float _Split_A1F00803_G_2 = _Property_CDF6AAAF_Out_0[1];
                        float _Split_A1F00803_B_3 = _Property_CDF6AAAF_Out_0[2];
                        float _Split_A1F00803_A_4 = _Property_CDF6AAAF_Out_0[3];
                        float4 _Combine_68D2E9F1_RGBA_4;
                        float3 _Combine_68D2E9F1_RGB_5;
                        float2 _Combine_68D2E9F1_RG_6;
                        Unity_Combine_float(_Split_A1F00803_R_1, _Split_A1F00803_G_2, 0, 0, _Combine_68D2E9F1_RGBA_4, _Combine_68D2E9F1_RGB_5, _Combine_68D2E9F1_RG_6);
                        float4 _Combine_7074AA82_RGBA_4;
                        float3 _Combine_7074AA82_RGB_5;
                        float2 _Combine_7074AA82_RG_6;
                        Unity_Combine_float(_Split_A1F00803_B_3, _Split_A1F00803_A_4, 0, 0, _Combine_7074AA82_RGBA_4, _Combine_7074AA82_RGB_5, _Combine_7074AA82_RG_6);
                        float _Remap_5134C4F6_Out_3;
                        Unity_Remap_float(_Power_1F04B9C8_Out_2, _Combine_68D2E9F1_RG_6, _Combine_7074AA82_RG_6, _Remap_5134C4F6_Out_3);
                        float _Absolute_6ACCA602_Out_1;
                        Unity_Absolute_float(_Remap_5134C4F6_Out_3, _Absolute_6ACCA602_Out_1);
                        float _Smoothstep_44B217D8_Out_3;
                        Unity_Smoothstep_float(_Property_E8D1E28F_Out_0, _Property_C8D979CD_Out_0, _Absolute_6ACCA602_Out_1, _Smoothstep_44B217D8_Out_3);
                        float2 _Property_60AD79E_Out_0 = Vector2_530E3E4B;
                        float _Property_7D87FBDE_Out_0 = Vector1_F48C110F;
                        float _Multiply_3B47E2E0_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_7D87FBDE_Out_0, _Multiply_3B47E2E0_Out_2);
                        float2 _TilingAndOffset_AC16A3F0_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_B322FEFB_Out_3.xy), _Property_60AD79E_Out_0, (_Multiply_3B47E2E0_Out_2.xx), _TilingAndOffset_AC16A3F0_Out_3);
                        float _Property_576D710C_Out_0 = Vector1_69315031;
                        float _GradientNoise_6176A24A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_AC16A3F0_Out_3, _Property_576D710C_Out_0, _GradientNoise_6176A24A_Out_2);
                        float _Add_111C237E_Out_2;
                        Unity_Add_float(_Smoothstep_44B217D8_Out_3, _GradientNoise_6176A24A_Out_2, _Add_111C237E_Out_2);
                        float _Property_F5671F6F_Out_0 = Vector1_48F8D2CE;
                        float _Multiply_F4E12D57_Out_2;
                        Unity_Multiply_float(_GradientNoise_6176A24A_Out_2, _Property_F5671F6F_Out_0, _Multiply_F4E12D57_Out_2);
                        float _Add_7311E555_Out_2;
                        Unity_Add_float(1, _Multiply_F4E12D57_Out_2, _Add_7311E555_Out_2);
                        float _Divide_54C0CB48_Out_2;
                        Unity_Divide_float(_Add_111C237E_Out_2, _Add_7311E555_Out_2, _Divide_54C0CB48_Out_2);
                        float4 _Lerp_31D2C1F5_Out_3;
                        Unity_Lerp_float4(_Property_FB0D29DD_Out_0, _Property_C942B902_Out_0, (_Divide_54C0CB48_Out_2.xxxx), _Lerp_31D2C1F5_Out_3);
                        float _Property_40F7DF8_Out_0 = Vector1_DEE5B51D;
                        float _FresnelEffect_955250D5_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_40F7DF8_Out_0, _FresnelEffect_955250D5_Out_3);
                        float _Multiply_9031E310_Out_2;
                        Unity_Multiply_float(_Divide_54C0CB48_Out_2, _FresnelEffect_955250D5_Out_3, _Multiply_9031E310_Out_2);
                        float _Property_62CEAF64_Out_0 = Vector1_52A4234E;
                        float _Multiply_201CD0D0_Out_2;
                        Unity_Multiply_float(_Multiply_9031E310_Out_2, _Property_62CEAF64_Out_0, _Multiply_201CD0D0_Out_2);
                        float4 _Add_89AD2985_Out_2;
                        Unity_Add_float4(_Lerp_31D2C1F5_Out_3, (_Multiply_201CD0D0_Out_2.xxxx), _Add_89AD2985_Out_2);
                        float _Property_10DA481C_Out_0 = Vector1_64EE49CE;
                        float4 _Multiply_D9E068F3_Out_2;
                        Unity_Multiply_float((_Property_10DA481C_Out_0.xxxx), _Lerp_31D2C1F5_Out_3, _Multiply_D9E068F3_Out_2);
                        float _SceneDepth_3CA34D50_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_3CA34D50_Out_1);
                        float4 _ScreenPosition_54FA224B_Out_0 = IN.ScreenPosition;
                        float _Split_696368CF_R_1 = _ScreenPosition_54FA224B_Out_0[0];
                        float _Split_696368CF_G_2 = _ScreenPosition_54FA224B_Out_0[1];
                        float _Split_696368CF_B_3 = _ScreenPosition_54FA224B_Out_0[2];
                        float _Split_696368CF_A_4 = _ScreenPosition_54FA224B_Out_0[3];
                        float _Subtract_BC526A39_Out_2;
                        Unity_Subtract_float(_Split_696368CF_A_4, 1, _Subtract_BC526A39_Out_2);
                        float _Subtract_C5A988EF_Out_2;
                        Unity_Subtract_float(_SceneDepth_3CA34D50_Out_1, _Subtract_BC526A39_Out_2, _Subtract_C5A988EF_Out_2);
                        float _Property_40378DD3_Out_0 = Vector1_BEA8AAF5;
                        float _Divide_17E0215F_Out_2;
                        Unity_Divide_float(_Subtract_C5A988EF_Out_2, _Property_40378DD3_Out_0, _Divide_17E0215F_Out_2);
                        float _Saturate_3BCB67B1_Out_1;
                        Unity_Saturate_float(_Divide_17E0215F_Out_2, _Saturate_3BCB67B1_Out_1);
                        surface.Albedo = (_Add_89AD2985_Out_2.xyz);
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.Metallic = 0;
                        surface.Emission = (_Multiply_D9E068F3_Out_2.xyz);
                        surface.Smoothness = 0.5;
                        surface.Occlusion = 1;
                        surface.Alpha = _Saturate_3BCB67B1_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    output.texCoord1 = input.texCoord1;
                    output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
                surfaceData.ambientOcclusion = 1.0;
                surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.
        
                // copy across graph values, if defined
                surfaceData.baseColor =             surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
                surfaceData.metallic =              surfaceDescription.Metallic;
                // surfaceData.specularColor =         surfaceDescription.Specular;
        
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                // normal delivered to master node
                float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
                normalSrc = surfaceDescription.Normal;
        
                // compute world space normal
        #if _NORMAL_DROPOFF_TS
                GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
        #elif _NORMAL_DROPOFF_OS
        		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
        #elif _NORMAL_DROPOFF_WS
        		surfaceData.normalWS = normalSrc;
        #endif
        
                surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
                surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    // Both uses and modifies 'surfaceData.normalWS'.
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
        #endif
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
                // doubleSidedConstants = float3(-1.0, -1.0, -1.0);
                doubleSidedConstants = float3( 1.0,  1.0, -1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                // DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal
                InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForward.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.Rendering.HighDefinition.HDPBRLitGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}
