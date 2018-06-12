Shader "Custom/WorldPos" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SecondaryTex("Albedo2 (RGB)", 2D) = "white" {}
		_Position("World Position", vector) = (1,1,1,1)
		//_Position("World Position", vector) = (1,1,1,1)
		_Radius("Sphere Radius",range(1,10)) = 1
		_BorderWidth("Border Width", range(0,1)) = 1
		_Test("Test Lerp",range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SecondaryTex;
		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

	
		fixed4 _Color;
		float4 _Position;
		float _Radius;
		float _BorderWidth;
		float _Test;
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			float3 dis = distance(_Position.xyz, IN.worldPos);
			
			float3 sphere = 1 - (saturate(dis / _Radius));
			
			
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
			fixed4 c2 = tex2D(_SecondaryTex, IN.uv_MainTex);

			float3 primaryTex = (step(sphere, 0.1) * c.rgb);
			float3 otherTex = (step(0.1 + _BorderWidth, sphere) * c2.rgb);
			//float3 border = (step(0.1 + _BorderWidth,sphere ) * _Color );
			float3 texLerp = lerp(primaryTex, otherTex, _Test);
			
			//float4 finalColor = float4(primaryTex + otherTex, 1);
			//o.Albedo = (primaryTex + saturate(border - (otherTex / _Color))) ;//+ (otherTex - border);//+ border;
			//o.Albedo = primaryTex + otherTex;

			o.Albedo = (primaryTex + otherTex);
			//o.Albedo = primaryTex + (otherTex - border);
			//o.Albedo = texLerp;
			// Metallic and smoothness come from slider variables)
			
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
