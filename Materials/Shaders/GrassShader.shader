Shader "Custom/GrassShader"
{
	Properties
	{
		//ToDo: 影周りの実装
		_Color1("Color1", Color) = (0.572549,1,0,1)
		_Color2("Color2", Color) = (0,0.3018867,0.07654338,1)
		_LightBiasGain("Light Bias", Range(0,1)) = 0.5

		_TessellationLevel("Tessellation Level", Range(1, 64)) = 1

		_MeshWidth("Mesh Width", Float) = 0.05
		_MeshWidthRdm("Mesh Width Rdm", Float) = 0.02
		_MeshHeight("Mesh Height", Float) = 0.5
		_MeshHeightRdm("Mesh Height Rdm", Float) = 0.3
		_MeshForward("Mesh Forward Amount", Float) = 0.38
		_MeshCurve("Mesh Curvature Amount", Range(1, 4)) = 2
		_BendRotRdm("Bend Rot Rdm", Range(0, 1)) = 0.2

		_WindIntensity("Wind Strength", Vector) = (0.05, 0.05, 0, 0)
		_WindFrequency("Wind Frequency", Float) = 1
		_WindDetail("Wind Detail",Float) = 1
	}

		CGINCLUDE
#include "UnityCG.cginc"

			struct vtxInput
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
		};
		struct vtxOutput
		{
			float4 vertex : SV_POSITION;
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
		};
		struct TessellationFactors
		{
			float edge[3] : SV_TessFactor;
			float inside : SV_InsideTessFactor;
		};
		struct geoOutput
		{
			float4 pos : SV_POSITION;
			float3 normal : NORMAL;
			float2 uv : TEXCOORD0;
		};
		vtxInput vert(vtxInput v)
		{
			return v;
		}
		vtxOutput tessVert(vtxInput v)
		{
			vtxOutput o;
			o.vertex = v.vertex;
			o.normal = v.normal;
			o.tangent = v.tangent;
			return o;
		}
		geoOutput VtxOutput(float3 pos, float3 normal, float2 uv)
		{
			geoOutput o;
			o.pos = UnityObjectToClipPos(pos);
			o.normal = UnityObjectToWorldNormal(normal);
			o.uv = uv;

			return o;
		}

		float _TessellationLevel, _MeshHeight, _MeshHeightRdm, _MeshWidthRdm, _MeshWidth, _MeshForward, _MeshCurve, _BendRotRdm;
		float4 _WindIntensity;
		float _WindFrequency, _WindDetail;

		// 乱数生成 : http://answers.unity.com/answers/624136/view.html
		float rand(float3 co)
		{
			return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 53.539))) * 43758.5453);
		}
		// 回転行列：https://gist.github.com/keijiro/ee439d5e7388f3aafc5296005c8c3f33
		float3x3 AngleAxis3x3(float angle, float3 axis)
		{
			float c, s;
			sincos(angle, s, c);
			float t = 1 - c;
			float x = axis.x;
			float y = axis.y;
			float z = axis.z;

			return float3x3(
				t * x * x + c, t * x * y - s * z, t * x * z + s * y,
				t * x * y + s * z, t * y * y + c, t * y * z - s * x,
				t * x * z - s * y, t * y * z + s * x, t * z * z + c
				);
		}

		float randomValue(float2 uv)
		{
			return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
		}
		float interpolate(float a, float b, float t)
		{
			return (1.0 - t) * a + (t * b);
		}
		float valueNoise(float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac(uv);
			f = f * f * (3.0 - 2.0 * f);

			uv = abs(frac(uv) - 0.5);
			float2 c0 = i + float2(0.0, 0.0);
			float2 c1 = i + float2(1.0, 0.0);
			float2 c2 = i + float2(0.0, 1.0);
			float2 c3 = i + float2(1.0, 1.0);
			float r0 = randomValue(c0);
			float r1 = randomValue(c1);
			float r2 = randomValue(c2);
			float r3 = randomValue(c3);

			float bottom = interpolate(r0, r1, f.x);
			float top = interpolate(r2, r3, f.x);
			float t = interpolate(bottom, top, f.y);
			return t;
		}
		float SimpleNoise(float2 UV, float Scale)
		{
			float t = 0.0;
			t += valueNoise(float2(UV.x * Scale / 1, UV.y * Scale / 1)) * 0.125;
			t += valueNoise(float2(UV.x * Scale / 2, UV.y * Scale / 2)) * 0.25;
			t += valueNoise(float2(UV.x * Scale / 4, UV.y * Scale / 4)) * 0.5;
			return t;
		}

		//https://catlikecoding.com/unity/tutorials/advanced-rendering/tessellation/
		TessellationFactors patchConstantFunction(InputPatch<vtxInput, 3> patch)
		{
			TessellationFactors f;
			f.edge[0] = _TessellationLevel;
			f.edge[1] = _TessellationLevel;
			f.edge[2] = _TessellationLevel;
			f.inside = _TessellationLevel;
			return f;
		}

		[UNITY_domain("tri")]//patch:(tri/quad/isoline)
		[UNITY_outputcontrolpoints(3)]
		[UNITY_outputtopology("triangle_cw")]
		[UNITY_partitioning("integer")]//分割法：integer、fractional_even、fractional_odd
		[UNITY_patchconstantfunc("patchConstantFunction")]//テッセレーションの係数を計算
		vtxInput hull(InputPatch<vtxInput, 3> patch, uint id : SV_OutputControlPointID)
		{
			return patch[id];
		}

		//頂点ごとに1回呼び出し
		[UNITY_domain("tri")]//BarycentricCoordinates:重心座標系<https://en.wikipedia.org/wiki/Barycentric_coordinate_system>
		vtxOutput domain(TessellationFactors factors, OutputPatch<vtxInput, 3> patch, float3 BaryentricCoordinates : SV_DomainLocation)
		{
			vtxInput v;
			//頂点位置を見つけるには、重心座標を使用して、元の三角形ドメイン全体を補間
			//X、Y、Z座標は、第1、第2、第3の制御点の重みを決定
			#define DOMAIN_INTERPOLATION(fieldName) v.fieldName = patch[0].fieldName * BaryentricCoordinates.x + patch[1].fieldName * BaryentricCoordinates.y + patch[2].fieldName * BaryentricCoordinates.z
			//同じ方法で補間
			DOMAIN_INTERPOLATION(vertex);
			DOMAIN_INTERPOLATION(normal);
			DOMAIN_INTERPOLATION(tangent);

			return tessVert(v);
		}

		geoOutput GenerateMeshVertex(float3 vertexPos, float width, float height, float forward, float2 uv, float3x3 transformMatrix)
		{
			float3 tangentPnt = float3(width, forward, height);

			float3 tangentNor = normalize(float3(0, -1, forward));

			float3 localPos = vertexPos + mul(transformMatrix, tangentPnt);
			float3 localNor = mul(transformMatrix, tangentNor);
			return VtxOutput(localPos, localNor, uv);
		}

		// 1つの三角ポリを取り込んで，その三角形の最初の頂点位置にある草の葉を，その頂点の法線に合わせて出力する
		[maxvertexcount(11)]
		void geo(triangle vtxOutput IN[3], inout TriangleStream<geoOutput> triStream)
		{
			float3 pos = IN[0].vertex.xyz;
			// 正面をランダム化
			float3x3 facingRotMatrix = AngleAxis3x3(rand(pos) * UNITY_TWO_PI, float3(0, 0, 1));
			// 曲げ方向
			float3x3 bendRotMatrix = AngleAxis3x3(rand(pos.xyz) * _BendRotRdm * UNITY_PI * 0.5, float3(-1, 0, 0));

			// 風の歪みマップをサンプリングし、その方向の正規化ベクトルを構築します。
			float2 uv = pos.xz  + _WindFrequency * _Time.y;
			float noise = SimpleNoise(uv, _WindFrequency * _WindDetail);
			float3 windSample = (float3(noise, noise, noise) * 2 - 1) ;
			float3 wind = normalize(float3(windSample.x, windSample.y, windSample.z))*_WindIntensity;

			float3x3 windRot = AngleAxis3x3(windSample, wind);

			// 接線空間からローカル空間に変換するための行列を作成
			float3 tmpNormal = IN[0].normal;
			float4 tmpTangent = IN[0].tangent;
			float3 tmpBinormal = cross(tmpNormal, tmpTangent) * tmpTangent.w;
			float3x3 tangentToLocal = float3x3(tmpTangent.x, tmpBinormal.x, tmpNormal.x,
											   tmpTangent.y, tmpBinormal.y, tmpNormal.y,
											   tmpTangent.z, tmpBinormal.z, tmpNormal.z
											   );

			// 回転を含むローカル行列の完全接線を作成
			// これはブレードの根元に適応され、常に正しい方向を向いていることを確認
			float3x3 tmTmp1 = mul(tangentToLocal, windRot);
			float3x3 tmTmp2 = mul(facingRotMatrix, bendRotMatrix);
			float3x3 transformationMatrix = mul(tmTmp1, tmTmp2);
			float3x3 transformationMatrixFacing = mul(tangentToLocal, facingRotMatrix);

			float height = (rand(pos.zyx) * 2 - 1) * _MeshHeightRdm + _MeshHeight;
			float width = (rand(pos.xzy) * 2 - 1) * _MeshWidthRdm + _MeshWidth;
			float forward = rand(pos.yyz) * _MeshForward;

			for (int i = 0; i < 5; i++)
			{
				float t = i / (float)5;

				float sgmHeight = height * t;
				float sgmWidth = width * (1 - t);
				float sgmForward = pow(t, _MeshCurve) * forward;

				float3x3 transformMatrix = i == 0 ? transformationMatrixFacing : transformationMatrix;
				//頂点を追加
				triStream.Append(GenerateMeshVertex(pos, sgmWidth, sgmHeight, sgmForward, float2(0, t), transformMatrix));
				triStream.Append(GenerateMeshVertex(pos, -sgmWidth, sgmHeight, sgmForward, float2(1, t), transformMatrix));
			}

			// 最終的な頂点を先端として追加
			triStream.Append(GenerateMeshVertex(pos, 0, height, forward, float2(0.5, 1), transformationMatrix));
		}
		ENDCG

			SubShader
		{
			Cull Off

			Pass
			{
				Tags
				{
					"RenderType" = "Opaque"
					"LightMode" = "ForwardBase"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma geometry geo
				#pragma fragment frag
				#pragma hull hull
				#pragma domain domain
				#pragma target 4.6
				#pragma multi_compile_fwdbase

				#include "Lighting.cginc"

				float4 _Color1;
				float4 _Color2;
				float _LightBiasGain;

				float4 frag(geoOutput i,  fixed facing : VFACE) : SV_Target
				{
					float3 normal = facing > 0 ? i.normal : -i.normal;
					float NdotL = saturate(saturate(dot(normal, _WorldSpaceLightPos0)) + _LightBiasGain);// *SHADOW_ATTENUATION(i);
					float4 lightIntensity = NdotL * _LightColor0 + float4(ShadeSH9(float4(normal, 1)), 1);
					float4 col = lerp(_Color2, _Color1 * lightIntensity, i.uv.y);
					return col;
				}
				ENDCG
			}
		}
}
