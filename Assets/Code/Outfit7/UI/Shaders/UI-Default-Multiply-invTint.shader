Shader "Outfit7/UI/UI-Default-Multiply-invTint"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Fog { Mode Off }
		Blend DstColor Zero
		ColorMask [_ColorMask]

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				half4 vertex   : POSITION;
				fixed4 color    : COLOR0;
				half2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				half4 vertex   : SV_POSITION;
				fixed4 color    : COLOR0;
				fixed4 vcolor    : COLOR1;
				half2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;
			half4 _MainTex_ST;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
				OUT.color = _Color;
				OUT.vcolor = IN.color;
				return OUT;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				half color = tex2D(_MainTex, IN.texcoord).a * IN.color.a;
				return lerp(half4(1,1,1,1),IN.vcolor,color);
			}
		ENDCG
		}
	}
}
