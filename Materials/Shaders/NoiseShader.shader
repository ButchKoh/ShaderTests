Shader "Custom/NoiseShader" {
    Properties{
    _MainTex("Main Texture", 2D) = "white" {}
    _EmissionLevel("EmissionLevel", Float) = 1.0
    [Toggle]_AlphaBlend("Alpha Blend",int) = 1.0
    _UVScalingX("UVScaling x", float) = 1.0
    _UVScalingY("UVScaling y", float) = 1.0

    _TimeScale("TimeScale", Range(0,100)) = 40

    [Toggle]_UVHorizontalSlipOn("enable/disable", int) = 1
    _SlippingPosOffset("Position Offset", float) = 0
    _SlippingFrequency("Frequency", Int) = 6
    _SlippingLevel("Intensity", Range(0, 2)) = 0.15
    _SlippingWidth("Width", float) = 0.52
    _NoiseParam1("Noise Paramater", float) = 500
    _NoiseIntensity("Noise Intensity", float) = 1

    _VerticalSlipping("VerticalSlipping", Range(-1.5, 1.5)) = 0

    [Toggle]_UVNoiseOn("enable/disable", int) = 1
    _NoiseFrequency("Noise Frequency", Float) = 300
    _NoiseDetail("Noise Detail", float) = 1
    _NoiseSpeed("Noise Speed", float) = 100
    _NoiseThreshold("Noise Threshold", Range(0,1)) = 0.25
    _NoiseWidth("Noise Width", Range(0,25)) = 0.1

    [Toggle]_StretchOn("enable/disable", int) = 1
    _StretchIntensity("Intensity", Int) = 2
    _StretchLevel("Level", int) = 8
    _StretchThreshold("Threshold", Range(0,1)) = 0.75
    _NoiseParam4("Noise Paramater", int) = 600

    [Toggle]_SeparationOn("enable/disable", int) = 1
    _RGBSeparationWidth("Width", Range(0, 1)) = 0.15
    _RGBSeparationThreshold("Threshold", Range(0, 1)) = 0.15
    _NoiseParam5("Noise Paramater", int) = 30

    [Toggle]_MosicOn("enable/disable", int) = 1
    _MosicLevelX("Mosic Level X", Range(0,1000)) = 1
    _MosicLevelY("Mosic Level Y", Range(0,1000)) = 1
    _MosicThreshold("Mosic Threshold",Range(0,1)) = 0.5

    [Toggle]_WaveOn("enable/disable", int) = 1
    _WaveSpeed("Wave Speed", float) = 1
    _LineWidth("Line Width",float) = 1
    _LineIntensity("Line Intensity", Range(0,1)) = 1

    [Toggle]_SimpleNoiseOn("enable/disable", int) = 1
    _SimpleNoiseLevel("SimpleNoiseLevel", Range(0,2.5)) = 0.5
     _SimpleNoiseScale("SimpleNoiseScale", Range(250,50000)) = 250
    _NoiseParam7("Noise Paramater", int) = 500

    [Toggle]_PixelizeOn("eneble/disable",int) = 1
    _PixelNum("Pixel Num ", Range(5,1000)) = 10
    _PixelSize("Pixel Size", Range(0,1)) = 0.8
    _PixelWidth("Pixed Width", Range(0,1)) = 1
    }
        SubShader{
            Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
            Blend SrcAlpha OneMinusSrcAlpha
            Fog { Mode Off }

            Pass{

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };
        sampler2D _MainTex;
        int _AlphaBlend;
        half _EmissionLevel;

        //half4 _MainTex_ST;
        half _UVScalingX;
        half _UVScalingY;
        half _TimeScale;

        int _UVHorizontalSlipOn;
        half _SlippingPosOffset;
        int _SlippingFrequency;
        int _NoiseParam1;
        half _SlippingLevel;
        half _SlippingWidth;
        half _VerticalSlipping;
        half _NoiseIntensity;

        int _UVNoiseOn;
        half _NoiseFrequency;
        half _NoiseDetail;
        half _NoiseSpeed;
        half _NoiseThreshold;
        half _NoiseWidth;

        int _StretchOn;
        half _StretchIntensity;
        int _StretchLevel;
        half _StretchThreshold;
        int _NoiseParam4;

        int _SeparationOn;
        half _RGBSeparationWidth;
        half _RGBSeparationThreshold;
        int _NoiseParam5;

        int _MosicOn;
        half _MosicLevelX;
        half _MosicLevelY;
        half _MosicThreshold;

        int _WaveOn;
        half _WaveSpeed;
        half _LineWidth;
        half _LineIntensity;

        int _SimpleNoiseOn;
        half _SimpleNoiseLevel;
        half _SimpleNoiseScale;
        int _NoiseParam7;

        int _PixelizeOn;
        half _PixelNum;
        half _PixelSize;
        half _PixelWidth;

        half4 _Color;
        //ノイズ生成、参考:https://docs.unity3d.com/Packages/com.unity.shadergraph@7.1/manual/Simple-Noise-Node.html
        inline half noise_randomValue(half2 uv)
        {
            return frac(sin(dot(uv, half2(12.9828, 78.2333))) * 43758.4535);
        }
        inline half noise_interpolate(half a, half b, half t)
        {
            return (1.0 - t) * a + (t * b);
        }
        inline half valueNoise(half2 uv)
        {
            half2 i = floor(uv);
            half2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);

            uv = abs(frac(uv) - 0.5);
            half2 c0 = i + half2(0.0, 0.0);
            half2 c1 = i + half2(1.0, 0.0);
            half2 c2 = i + half2(0.0, 1.0);
            half2 c3 = i + half2(1.0, 1.0);
            half r0 = noise_randomValue(c0);
            half r1 = noise_randomValue(c1);
            half r2 = noise_randomValue(c2);
            half r3 = noise_randomValue(c3);

            half bottomOfGrid = noise_interpolate(r0, r1, f.x);
            half topOfGrid = noise_interpolate(r2, r3, f.x);
            half t = noise_interpolate(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        inline half SimpleNoise(half2 UV, half Scale) {
            half noise; noise = 0.0;
            half noise_tmp1 = pow(2.0, half(0));
            half noise_tmp2 = pow(0.5, half(3 - 0));
            noise += valueNoise(half2(UV.x * Scale / noise_tmp1, UV.y * Scale / noise_tmp1)) * noise_tmp2;
            noise_tmp1 = pow(2.0, half(1)); noise_tmp2 = pow(0.5, half(3 - 1));
            noise += valueNoise(half2(UV.x * Scale / noise_tmp1, UV.y * Scale / noise_tmp1)) * noise_tmp2;
            noise_tmp1 = pow(2.0, half(2)); noise_tmp2 = pow(0.5, half(3 - 2));
            noise += valueNoise(half2(UV.x * Scale / noise_tmp1, UV.y * Scale / noise_tmp1)) * noise_tmp2;
            return noise;
        }
        //色空間周り
        fixed3 rgb2hsv(fixed3 In)
        {
            fixed4 K = fixed4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            fixed4 P = lerp(fixed4(In.bg, K.wz), fixed4(In.gb, K.xy), step(In.b, In.g));
            fixed4 Q = lerp(fixed4(P.xyw, In.r), fixed4(In.r, P.yzx), step(P.x, In.r));
            fixed D = Q.x - min(Q.w, Q.y);
            fixed  E = 1e-10;
            return fixed3(abs(Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);
        }
        fixed3 hsv2rgb(fixed3 In)
        {
            fixed4 K = fixed4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            fixed3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
            return In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
        }
        //長方形の描画単位
        half Rectangle(half2 UV, half Width, half Height)
        {
            half2 d = abs(UV * 2 - 1) - half2(Width, Height);
            d = 1 - d / fwidth(d);
            return saturate(min(d.x, d.y));
        }

        half ScaledTime;

                v2f vert(appdata v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }
                // Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


                fixed4 frag(v2f i) : SV_TARGET {
                    half2 _UVScaling = half2(_UVScalingX, _UVScalingY);
                ScaledTime += _Time.y * _TimeScale;
                half ScaledTimeFraction = frac(ScaledTime);

                //1----------------------------------------------------------------------------------

                half modulo = fmod(ScaledTime, 10.0);
                half posterized1 = floor(modulo * _SlippingFrequency) / _SlippingFrequency;
                half2 TimeFractionPair;
                TimeFractionPair.x = ScaledTimeFraction;
                TimeFractionPair.y = ScaledTimeFraction;
                half2 PosterizedPair;
                PosterizedPair.x = posterized1;
                PosterizedPair.y = posterized1;
                half noise1 = SimpleNoise(PosterizedPair, _NoiseParam1);
                half saturated = saturate(step(i.uv.y, noise1 * _NoiseIntensity + _SlippingWidth + _SlippingPosOffset) - step(i.uv.y, noise1 * _NoiseIntensity + _SlippingPosOffset));
                half2 VerticalSlipped;
                VerticalSlipped.x = saturated * _SlippingLevel * _UVHorizontalSlipOn;
                VerticalSlipped.y = _VerticalSlipping;

                //2-------------------------------------------------------------------------

                half noise2 = SimpleNoise(TimeFractionPair, _NoiseFrequency);
                half noise3 = (SimpleNoise(float2(i.uv.y, i.uv.y * noise2) * _NoiseDetail, 150) * 2) - 1;
                half stepped3 = step(noise2, _NoiseThreshold);
                half2 NoiseUV = half2(noise3 * stepped3 * _NoiseWidth * _UVNoiseOn, 0);

                //3-------------------------------------------------------------------------

                half noise4 = SimpleNoise(PosterizedPair, _NoiseParam4);
                half posterizedNoise = floor(noise4 * _StretchLevel) / _StretchLevel;
                half2 UVStretch;
                UVStretch.x = step(posterizedNoise, _StretchThreshold) * _StretchIntensity * posterizedNoise;
                //UVStretch.x = (1.0 - abs(sign(_StretchOn - 1))) * i.uv.x * UVStretch;
                UVStretch.y = 0;

                //UV関係-------------------------------------------------------------

                half2 UVsum1 = i.uv + VerticalSlipped + NoiseUV + UVStretch;
                UVsum1.y = frac(UVsum1.y);
                half2 ScaledUV;
                ScaledUV.x = UVsum1.x * _UVScaling.x;
                ScaledUV.y = UVsum1.y * _UVScaling.y;

                //4-------------------------------------------------------------------------

                half noise5 = SimpleNoise(noise4, _NoiseParam5);
                half RGBSeparaton = step(noise5, _RGBSeparationThreshold) * _RGBSeparationWidth * _SeparationOn;
                half2 uvR = ScaledUV;
                half2 uvG = ScaledUV;
                half2 uvB = ScaledUV;
                uvR.x -= RGBSeparaton;
                uvB.x += RGBSeparaton;

                fixed4 r = tex2D(_MainTex, uvR);
                fixed4 g = tex2D(_MainTex, uvG);
                fixed4 b = tex2D(_MainTex, uvB);
                fixed4 color = fixed4(r.r, g.g, b.b, (r.a + g.a + b.a) / 3);

                //5------------------------------------------------------------------------

                half noise6 = SimpleNoise(noise1, noise4);
                half2 UVMosicLevel_tmp = half2(_MosicLevelX * noise1 * 2, _MosicLevelY * noise1 * 2) / 10;
                half2 UVMosicLevel = UVMosicLevel_tmp - frac(UVMosicLevel_tmp) + half2(1, 1);
                half2 MosicUV = floor(i.uv * UVMosicLevel.xy) / UVMosicLevel.xy * _UVScaling;
                MosicUV = frac(MosicUV + VerticalSlipped);
                int MosicThres = step(noise1, _MosicThreshold) * _MosicOn;

                //6----------------------------------------------------------------------------------

                half LineSequence = frac(_WaveSpeed * ScaledTime + i.uv.y * _LineWidth) * _LineIntensity * _WaveOn;
                LineSequence *= LineSequence * LineSequence;

                //7-------------------------------------------------------------------------

                half noise7 = SimpleNoise(i.uv, _SimpleNoiseScale);
                half addSimpleNoise = frac(noise7 * 30 + ScaledTime * 3 * _SimpleNoiseOn) * _SimpleNoiseLevel;
                fixed4 AddSimpleNoise = fixed4(addSimpleNoise, addSimpleNoise, addSimpleNoise, 1) / 2;

                //8----------------------------------------------------------------------------------

                half2 PixelizedUV = (floor(i.uv.xy / (1 / _PixelNum.xx)) * (1 / _PixelNum.xx) / 10);

                half noise8 = SimpleNoise(ScaledTime, _NoiseParam7) * _SimpleNoiseOn;

                fixed4 pxelizedColor = tex2D(_MainTex, PixelizedUV);

                fixed3 albedoColorRGB = (lerp(color.rgb, AddSimpleNoise, noise8 * _SimpleNoiseLevel)
                                    - LineSequence) * (1 - MosicThres)
                                    + tex2D(_MainTex, MosicUV).rgb * MosicThres;
                fixed4 albedoColor = fixed4(albedoColorRGB, color.a);


                fixed4 PixelR = Rectangle(frac((i.uv - fixed2(0.333 / _PixelNum, 0)) * _PixelNum), _PixelSize * _PixelWidth / 3, _PixelSize)
                    * fixed4(albedoColor.r, 0, 0, 1);
                fixed4 PixelG = Rectangle(frac(i.uv * _PixelNum), _PixelSize * _PixelWidth / 3, _PixelSize)
                    * fixed4(0, albedoColor.g, 0, 1);
                fixed4 PixelB = Rectangle(frac((i.uv + fixed2(0.333 / _PixelNum, 0)) * _PixelNum), _PixelSize * _PixelWidth / 3, _PixelSize)
                    * fixed4(0, 0, albedoColor.b, 1);

                fixed4 RGBColor = (PixelR + PixelG + PixelB) * _PixelizeOn + (1 - _PixelizeOn) * albedoColor;
                RGBColor.a = _AlphaBlend* RGBColor.a + (1 - _AlphaBlend);
                return RGBColor * _EmissionLevel;
                }
                ENDCG
            }
    }
        FallBack Off
        CustomEditor "NoiseShaderEditor"
}