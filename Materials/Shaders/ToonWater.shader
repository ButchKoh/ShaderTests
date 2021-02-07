Shader "Custom/ToonWater"
{
    Properties
    {
        _WaterFlow("water flow", Vector) = (0,-0.1,0,0)
        _Scale("scale", Vector) = (0.1, 0.1, 0.1, 1)
        _UVNoise("UV noise", float) = 100
        [Toggle]_UVorPos("UV base or Position base",int) = 0
        _Wave("wave", Vector) = (0, 0, 0, 0)
        _WaveSpeed("wave speed", float) = 1
        _Threshold1("Threshold 1", Range(0,1)) = 0.55
        _Threshold2("Threshold 2", Range(0,1)) = 0.55
        _NoiseParam1("Noise Parameter 1", int) = 5
        _NoiseParam2("Noise Parameter 2", int) = 50
        _NoiseParam3("Noise Parameter 3", float) = 1.0
        _Color1("Color 1", Color) = (0,0.8078432,1,1)
        _Color2("Color 2", Color) = (0.5058824,0.9058824,1,1)
        _Color3("Color 3", Color) = (1,1,1,1)
        _Emission("Emission", float) = 1
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

        float4 _WaterFlow;
        float4 _Scale;
        float _UVNoise;
        int _UVorPos;
        float4 _Wave;
        float _WaveSpeed;
        float _Threshold1;
        float _Threshold2;
        int _NoiseParam1;
        int _NoiseParam2;
        float _NoiseParam3;
        fixed4 _Color1;
        fixed4 _Color2;
        fixed4 _Color3;
        float _Emission;

        //参考link: https://docs.unity3d.com/Packages/com.unity.shadergraph@7.1/manual/Simple-Noise-Node.html
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
        inline float SimpleNoise(float2 UV, float Scale)
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

        //参考link: https://docs.unity3d.com/Packages/com.unity.shadergraph@7.1/manual/Voronoi-Node.html
        inline float2 RandomVector(float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)) * 46839.32);
            return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
        }
        inline float2 Voronoi(float2 UV, float AngleOffset, float CellDensity)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);

            for (int y = -1; y <= 1; y++){
                for (int x = -1; x <= 1; x++){
                    float2 lattice = float2(x, y);
                    float2 offset = RandomVector(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    float Out = 0;
                    float Cells = 0;
                    if (d < res.x){
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
            return res.xy;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float3 tmpVec = sin(_Time.y * _WaveSpeed) * _Wave.xyz + _WaterFlow.xyz * (-1) * _Time.y + _Scale.xyz * IN.worldPos;
            float2 tmpUV = tmpVec.xy+tmpVec.z;
            float2 noisedUV = tmpUV + 0.2 * SimpleNoise(tmpUV, _UVNoise);

            float voronoi = Voronoi(noisedUV, _Time.y * _NoiseParam3, _NoiseParam1);

            float3 BaseColor = _Color1 * step(voronoi, _Threshold1);
            float3 SubColor  = _Color2 * step(_Threshold1, voronoi);
            float3 AccentColor = _Color3 * step(_Threshold2, voronoi * SimpleNoise(tmpUV, _NoiseParam2));
            
            float3 CombinedColor = clamp(BaseColor + SubColor + AccentColor, 0, 1);
            o.Albedo = CombinedColor;
            o.Emission = CombinedColor * _Emission;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
