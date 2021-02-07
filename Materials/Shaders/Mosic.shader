Shader "Custom/Mosic"
{
    Properties{
        [PowerSlider(3.0)] _Mosic("Mosic",Range(1,500)) = 10
    }
        SubShader
        {
            Tags { "Queue" = "Transparent+50"}
            GrabPass{"_BackgroundTexture"}
            Pass
            {
                //Cull Off
                LOD 100

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag alpha:fade
                #pragma target 3.0
                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                };

                struct v2f
                {
                    float4 vertex : SV_POSITION;
                    float4 ScreenPos : TEXCOORD0;
                    float4 worldPos : TEXCOORD1;
                };
                sampler2D _BackgroundTexture;
                float _Mosic;

                v2f vert(appdata v)
                {
                    v2f o;
                    float4 vt = v.vertex;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.ScreenPos = ComputeScreenPos(o.vertex);
                    o.worldPos = mul(unity_ObjectToWorld, vt);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    //画面のアスペクト比の計算
                    float4 projUpperRight = float4(1, 1, UNITY_NEAR_CLIP_VALUE, _ProjectionParams.y);
                    float4 viewUpperRight = mul(unity_CameraInvProjection, projUpperRight);
                    float aspect = viewUpperRight.x / viewUpperRight.y;

                    float2 tmpUV= i.ScreenPos.xy / i.ScreenPos.w;
                    //tmpUV.y /= aspect;
                    float mosicUVx = floor(tmpUV.x * _Mosic) / _Mosic;
                    float mosicUVy = floor(tmpUV.y / aspect * _Mosic) / _Mosic * aspect;//画面の縦横比を調整
                    float4 col = tex2D(_BackgroundTexture, float2(mosicUVx,mosicUVy));
                    //return tex2D(_BackgroundTexture, i.ScreenPos);
                    return col;

                }
                ENDCG
            }
        }
}