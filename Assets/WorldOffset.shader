﻿Shader "Unlit/WorldOffset"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Position("World Position",vector) = (1,1,1,1)
		_Radius("Sphere Radius", range(1,10)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 thing : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Radius;
			float4 _Position;
			v2f vert (appdata v)
			{
				v2f o;
				float3 dis = distance(_Position, v.vertex.xyz);
				float3 sphere = 1 - (saturate(dis / _Radius));
				float3 dir =  v.vertex.xyz - _Position;
				v.vertex.xyz += dir * sphere;
				o.thing = float4(dis,1);
				o.thing = v.vertex;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				//col = i.thing;
				return col;
			}
			ENDCG
		}
	}
}
