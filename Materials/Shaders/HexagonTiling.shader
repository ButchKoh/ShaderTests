Shader "Custom/HexagonTiling"
{
    Properties
    {
        [HideInInspector]_MainTex("Albedo (RGB)", 2D) = "white" {}
        _CenterPos("Center Position", Vector) = (0,0,0,0)
        _Scale("Scale",float) = 1
        _WaveFreq("Wave Frequency", float) = 1
        _WaveColor("Wave Color", Color) = (0,255,211,255)
        _WaveSpeed("Wave Speed", float) = 1
        _TileSize("Tile Size", Range(0,1)) = 0.05
        _LineThinness("Line Thinness", Range(0,1)) = 0.5
        _Intensity("Intensity", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _CenterPos;
        float _Scale;
        float _WaveFreq;
        float4 _WaveColor;
        float _WaveSpeed;
        float _TileSize;
        float _LineThinness;
        float _Intensity;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float tmp1 = abs(frac(0.5 * fmod(floor(1.1547 * IN.uv_MainTex.x*_Scale), 2) + IN.uv_MainTex.y*_Scale) - 0.5);
            float tmp2 = abs(frac(1.1547 * IN.uv_MainTex*_Scale) - 0.5) * 1.5 + tmp1;
            float tile = step(abs(max(tmp1 * 2, tmp2) - 1), _TileSize);

            float tmp4 = pow(abs(sin(distance(IN.worldPos, _CenterPos) * _WaveFreq + _Time.y * (-1) * _WaveSpeed)), _LineThinness);
            float3 waveColor = step(tmp4, _LineThinness) * tile * _WaveColor.rgb;
            o.Albedo = float3(tile, tile, tile);
            o.Albedo = float3(tmp4,tmp4,tmp4);
            o.Albedo = waveColor.xyz;
            o.Emission = waveColor.xyz * _Intensity;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
