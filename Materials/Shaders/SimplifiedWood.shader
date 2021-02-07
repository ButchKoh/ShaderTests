Shader "Custom/Wood"
{
    Properties
    {
        _Color1 ("Color1", Color) = (0.754717,0.4533587,0.2171591,1)
        _Color2 ("Color2", Color) = (0.4811321,0.2145932,0.06581526,1)
        _Smoothness ("Smoothness", Range(0, 2)) = 0.0
        _ScaleX ("ScaleX", float) = 5.0
        _ScaleY ("ScaleY", float) = 20.0
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

        half _Smoothness;
        fixed _ScaleX;
        fixed _ScaleY;
        fixed4 _Color1;
        fixed4 _Color2;

        inline float noise_randomValue(float2 uv)
        {
            return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
        }
        inline float noise_interpolate(float a, float b, float t)
        {
            return (1.0 - t) * a + (t * b);
        }
        inline float valueNoise(float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = noise_randomValue(c0);
            float r1 = noise_randomValue(c1);
            float r2 = noise_randomValue(c2);
            float r3 = noise_randomValue(c3);

            float bottomOfGrid = noise_interpolate(r0, r1, f.x);
            float topOfGrid = noise_interpolate(r2, r3, f.x);
            float t = noise_interpolate(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        float SimpleNoise(float2 UV, float Scale)
        {
            float t = 0.0;

            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3 - 0));
            t += valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3 - 1));
            t += valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3 - 2));
            t += valueNoise(float2(UV.x * Scale / freq, UV.y * Scale / freq)) * amp;

            return t;
        }

        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float sn1 = SimpleNoise(IN.worldPos * float3(_ScaleX, _ScaleY, _ScaleX), 1);
            float sn2 = SimpleNoise(IN.worldPos * float3(_ScaleX, _ScaleY, _ScaleX), 5);
            float tmp = pow(frac(5 * sn1), 0.5);
            float3 c = max(tmp * _Color1, _Color2);
            float Smoothness = clamp((tmp * sn2), 0, 1)*_Smoothness;
            float3 normal = 
            o.Albedo = c.rgb;
            o.Smoothness = Smoothness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
