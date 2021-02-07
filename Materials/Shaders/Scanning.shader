Shader "Custom/scanning" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_Intensity("Intensity",float) = 1
		[PowerSlider(3.0)]_AlphaLevel("Alpha Clamp Level", Range(0, 1)) = 1
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_LineWidth("Line Width", float) = 10
		_WaveSpeed("Wave Speed", float) = 1
	}

		SubShader{
			Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
			LOD 200

			Pass{
			  ZWrite ON
			  ColorMask 0
			}

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows alpha:fade
			#pragma target 3.0

			float _Intensity;
			float _AlphaLevel;
			sampler2D _MainTex;
			float _LineWidth;
			float _WaveSpeed;

			struct Input {
				float2 uv_MainTex;
				float3 worldPos;
			};

			fixed4 _Color;

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				float LineSequence = frac(_WaveSpeed * _Time + IN.worldPos.y * _LineWidth);
				fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
				float GrayScale = tex.r * 0.2126 + tex.g * 0.7152 + tex.b * 0722;
				GrayScale *= LineSequence;
				float4 col = _Color;
				col *= GrayScale;
				o.Albedo = col.rgb;

				col *= _Intensity;
				o.Emission = col.rgb;

				o.Alpha = min(GrayScale / 256 * _AlphaLevel, tex.a);
			}
			ENDCG
		}
			FallBack "Diffuse"
}