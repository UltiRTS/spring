#version 410 core


uniform sampler2D       decalTex;
uniform sampler2D       shadeTex;
uniform sampler2DShadow shadowTex;

uniform vec4 groundAmbientColor;

uniform mat4 shadowMatrix;
uniform vec4 shadowParams;
uniform float shadowDensity;
uniform float decalAlpha;


in vec4 vertexPos;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 baseColor;

out vec4 fragColor;


void main() {
	#ifdef HAVE_SHADOWS
	vec4 vertexShadowPos = shadowMatrix * vertexPos;
		vertexShadowPos.xy *= (inversesqrt(abs(vertexShadowPos.xy) + shadowParams.zz) + shadowParams.ww);
		vertexShadowPos.xy += shadowParams.xy;

	float shadowCoeff = mix(1.0, textureProj(shadowTex, vertexShadowPos), shadowDensity);
	#else
	float shadowCoeff = 1.0;
	#endif

	vec4 shadeInt;
	vec4 decalInt;
	vec4 shadeCol;

	#if (HAVE_SHADING_TEX == 1)
	shadeInt = texture(shadeTex, texCoord1);
	#else
	shadeInt = vec4(1.0, 1.0, 1.0, 1.0);
	#endif

	decalInt = texture(decalTex, texCoord0);
	shadeCol = mix(groundAmbientColor, shadeInt, shadowCoeff * shadeInt.a);

	fragColor = decalInt * shadeCol;
	fragColor.a = decalInt.a * decalAlpha;
}

