Shader "Custom/ExractEdge"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _EdgeSize("Edge Size", float) = 5
        _Scale("UV scale", float) = 1.0
        _Intensity("Intensity",float) = 1
        [PowerSlider]_Threshold("Threshold",Range(0,100)) = 0.5
        [Toggle]_4or8("4 or 8", int) = 1
        _Color("Color", Color) = (0,0,0,1)
    }
        SubShader
        {
            LOD 200

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows
            #pragma target 3.0

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            struct Input
            {
                float2 uv_MainTex;
            };

            float _EdgeSize;
            int _4or8;
            float _Scale;
            float _Intensity;
            float _Threshold;
            float4 _Color;

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                float EdgeWidth = _EdgeSize / _MainTex_TexelSize.z;
                float2 uv = IN.uv_MainTex.xy;
                float2 uvRight      = float2(uv.x + EdgeWidth, uv.y);
                float2 uvLeft       = float2(uv.x - EdgeWidth, uv.y);
                float2 uvUp         = float2(uv.x,             uv.y + EdgeWidth);
                float2 uvDown       = float2(uv.x,             uv.y - EdgeWidth);
                float2 uvRightUp    = float2(uv.x + EdgeWidth, uv.y + EdgeWidth);
                float2 uvLeftUp     = float2(uv.x - EdgeWidth, uv.y + EdgeWidth);
                float2 uvRightDown  = float2(uv.x + EdgeWidth, uv.y - EdgeWidth);
                float2 uvLeftDown   = float2(uv.x - EdgeWidth, uv.y - EdgeWidth);

                float4 colBase = tex2D(_MainTex, uv * _Scale);

                float4 colRight = tex2D(_MainTex, uvRight * _Scale);
                float4 colLeft = tex2D(_MainTex, uvLeft * _Scale);
                float4 colUp = tex2D(_MainTex, uvUp * _Scale);
                float4 colDown = tex2D(_MainTex, uvDown * _Scale);
                float4 colRightUp = tex2D(_MainTex, uvRightUp * _Scale);
                float4 colLeftUp = tex2D(_MainTex, uvLeftUp * _Scale);
                float4 colRightDown = tex2D(_MainTex, uvRightDown * _Scale);
                float4 colLeftDown = tex2D(_MainTex, uvLeftDown * _Scale);

                colRight = uvRight.x > 1 ? 0 : colRight;
                colLeft = uvLeft.x < 0 ? 0 : colLeft;
                colUp = uvUp.y > 1 ? 0 : colUp;
                colDown = uvDown.y < 0 ? 0 : colDown;
                colRightUp = uvRightUp.x > 1 | uvRightUp.y > 1 ? 0 : colRightUp;
                colLeftUp = uvLeftUp.x < 0 | uvLeftUp.y    > 1 ? 0 : colLeftUp;
                colRightDown = uvRightDown.x > 1 | uvRightDown.y < 0 ? 0 : colRightDown;
                colLeftDown = uvLeftDown.x < 0 | uvLeftDown.y < 0 ? 0 : colLeftDown;

                float4 c_tmp = (colRight + colLeft + colUp + colDown + ((colRightUp + colLeftUp + colRightDown + colLeftDown) * _4or8) - (4 + (4 * _4or8)) * colBase);
                float4 c = 1 - step(c_tmp, (float4)(1 / _Threshold));
                c *= _Color;
                float3 color = clamp(abs(c.rgb),0,1);

                o.Albedo = color;
                o.Emission = color * _Intensity;

            }
            ENDCG
        }
            FallBack "Diffuse"
}
