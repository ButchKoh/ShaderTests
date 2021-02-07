Shader "Custom/Reflection/GouraudShading"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
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

            struct appdata//シェーダ関数が入力として受け取る値
            {
                float4 vertex : POSITION;//頂点のローカル座標空間
                float2 uv     : TEXCOORD0;//頂点に対応するテクスチャuv0座標
                float3 normal : NORMAL;//頂点に設定された法線ベクトル
            };

            struct v2f//頂点シェーダからの出力->フラグメントシェーダへの入力
            {
                float2 uv     : TEXCOORD;
                float4 vertex : SV_POSITION;
                //拡散係数
                float diffuse : COLOR0;
            };

            v2f vert(appdata v)//頂点シェーダ
            {
                v2f o;
                //頂点をクリップ空間座標に変換
                o.vertex = UnityObjectToClipPos(v.vertex);
                //uv座標
                o.uv = v.uv;

                //法線ベクトル
                float3 normal = v.normal;
                //光源方向ベクトル
                float3 lightDir = ObjSpaceLightDir(v.vertex);
                float NdotL = dot(normal, lightDir);
                //拡散係数の決定
                o.diffuse = max(0, NdotL);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //テクスチャマップからカラー値をサンプリング
                float4 tex = tex2D(_MainTex, i.uv);
                //サンプリングしたカラー値に拡散係数を掛ける
                fixed4 color = i.diffuse * tex;
                return color;
            }
            ENDCG
        }
    }
}
