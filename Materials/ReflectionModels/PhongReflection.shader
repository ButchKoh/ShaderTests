Shader "Custom/Reflection/PhongReflection"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        
        //スペキュラ色
        _SpecColor("Specular Color", Color) = (0, 0, 0, 0)
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
            //ライトカラー
            float4 _LightColor0;
            //スペキュラ色
            float4 _SpecColor;

            struct appdata//シェーダ関数が入力として受け取る値
            {
                float4 vertex : POSITION;//頂点のローカル座標空間
                float2 uv     : TEXCOORD0;//頂点に対応するテクスチャuv0座標
                float3 normal : NORMAL;//頂点に設定された法線ベクトル
            };

            struct v2f//頂点シェーダからの出力->フラグメントシェーダへの入力
            {
                float2 uv          : TEXCOORD;
                float4 vertex      : SV_POSITION;
                //ワールド空間の法線ベクトル
                float3 worldNormal : TEXCOORD1;//頂点シェーダからフラグメントシェーダへ任意の値を渡すときは"TEXCOORDn(n=0～1)"
                //ワールド空間の頂点座標
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
                //法線ベクトル
                float3 normal = normalize(i.worldNormal);
                //視点方向ベクトル
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                //法線ベクトルと視点方向ベクトルの内積
                float NdotL = dot(normal, lightDir);

                //カメラ方向ベクトル
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                //法線-カメラの角度量
                float NdotV = dot(normal, viewDir);

                //テクスチャからカラーをサンプリング
                float4 tex = tex2D(_MainTex, i.uv);

                //拡散色の決定
                float diffusePower = max(0, NdotL);
                float4 diffuse = diffusePower * tex * _LightColor0;

                //フォンによるスペキュラ近似式１
                float3 R = -1 * viewDir + 2.0 * NdotV * normal;

                //フォンによるスペキュラ近似式２
                float LdotR = dot(lightDir, R);
                float3 specularPower = pow(max(0, LdotR), 10.0);

                //反射色の決定
                float4 specular = float4(specularPower, 1.0) * _SpecColor * _LightColor0;

                //拡散色と反射色の合算
                fixed4 color = diffuse + specular;
                return color;
            }
            ENDCG
        }
    }
}