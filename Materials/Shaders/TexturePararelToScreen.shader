Shader "Custom/TexturePararelToScreen"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _ScalingX("scaling x",Float) = 1.0
        _ScalingY("scaling y",Float) = 1.0

    }
        SubShader
        {
            Tags { 
                "IgnoreProjector" = "True" 
                "RenderType" = "Opaque" 
            }
            Pass
            {
                LOD 100
                Blend SrcAlpha OneMinusSrcAlpha

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

                sampler2D _MainTex;
                float _ScalingX;
                float _ScalingY;
                float4 Scaling;

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
                    Scaling.x = i.ScreenPos.x * _ScalingX;
                    Scaling.y = i.ScreenPos.y * _ScalingY;
                    Scaling.z = i.ScreenPos.z;
                    Scaling.w = i.ScreenPos.w;
                    
                    return tex2Dproj(_MainTex, Scaling);
                }
                ENDCG
            }
        }
}