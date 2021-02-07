Shader "Custom/Reflection/BlinnPhongReflection"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        // アンビエント光反射量
        _Ambient("Ambient", Range(0, 1)) = 0
        //スペキュラ色
        _SpecColor("Specular Color", Color) = (0, 0, 0, 0)
        [PowerSlider(3.0)]_Roughness("Roughness", Range(0.00000001,1)) = 0.5
        //複素屈折率の実部
        _FresnelEffect("Fresnel Effect", Float) = 20.0
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            LOD 200

        //ここからCg/HLSL
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        sampler2D _MainTex;
        float4 _LightColor0;
        float _Ambient;
        float4 _SpecColor;
        float _Roughness;
        float _FresnelEffect;

        struct appdata//シェーダ関数が入力として受け取る値
        {
            float4 vertex : POSITION;
            float2 uv     : TEXCOORD0;
            float3 normal : NORMAL;
        };

        struct v2f//頂点シェーダからの出力->フラグメントシェーダへの入力
        {
            float2 uv          : TEXCOORD;
            float4 vertex      : SV_POSITION;
            float3 worldNormal : TEXCOORD1;//頂点シェーダからフラグメントシェーダへ任意の値を渡すときは"TEXCOORDn(n=0～1)"
            float3 worldPos    : TEXCOORD2;
        };

        v2f vert(appdata v)//頂点シェーダ
        {
            v2f o;
            //頂点をクリップ空間座標に変換
            o.vertex = UnityObjectToClipPos(v.vertex);
            //uv座標
            o.uv = v.uv;

            //法線ベクトルをワールド空間座標に変換
            float3 worldNormal = UnityObjectToWorldNormal(v.normal);
            o.worldNormal = worldNormal;

            //頂点をワールド空間座標に変換
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
            o.worldPos = worldPos;

            return o;
        }

    fixed4 frag(v2f i) : SV_Target
    {
            //法線
            float3 normal = normalize(i.worldNormal);
            //光源方向
            float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
            //視点方向
            float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
            //光源方向と視点方向のハーフベクトル
            float3 halfDir = normalize(lightDir + viewDir);

            //各ベクトル間の内積
            float NdotV = saturate(dot(normal, viewDir));
            float NdotH = saturate(dot(normal, halfDir));
            float VdotH = saturate(dot(viewDir, halfDir));
            float NdotL = saturate(dot(normal, lightDir));
            float LdotH = saturate(dot(lightDir, halfDir));

            //テクスチャカラー
            float4 tex = tex2D(_MainTex, i.uv);

            //拡散色の決定
            float diffusePower = max(_Ambient, NdotL);
            float4 diffuse = diffusePower * tex * _LightColor0;

            //Beckmann分布関数
            float m = _Roughness * _Roughness;
            float r1 = 1.0 / (4.0 * m * pow(NdotH + 0.00001, 4.0));
            float r2 = (NdotH * NdotH - 1.0) / (m * NdotH * NdotH + 0.00001);
            float D = r1 * exp(r2);

            //幾何減衰率
            float g1 = 2 * NdotH * NdotV / VdotH;
            float g2 = 2 * NdotH * NdotL / VdotH;
            float G = min(1.0, min(g1, g2));

            //フレネル効果
            /*float n = _FresnelEffect;
            float g = sqrt(n * n + LdotH * LdotH - 1);
            float gpc = g + LdotH;
            float gnc = g - LdotH;
            float cgpc = LdotH * gpc - 1;
            float cgnc = LdotH * gnc + 1;
            float F = 0.5 * gnc * gnc * (1 + cgpc * cgpc / (cgnc * cgnc)) / (gpc * gpc);*/

            //Schlickのフレネル近似式
            float F = _FresnelEffect + (1 - _FresnelEffect) * pow(saturate(1.0 - NdotL), 4);

            //スペキュラ量
            half BRDF = (F * D * G) / (NdotV * NdotL * 4.0 + 0.00001);

            //反射色
            half3 finalValue = BRDF * _SpecColor * _LightColor0;

            //拡散色+反射色
            fixed4 color = diffuse + float4(finalValue, 1.0);
            return color;
            }
            ENDCG
        }
    }
}
