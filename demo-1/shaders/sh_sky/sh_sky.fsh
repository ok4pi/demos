struct PixelInput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD;
};

uniform float time;

Texture2D    NoiseTexture : register(t1);
// SamplerState NoiseSampler : register(s1);

float4 main(in PixelInput In) : SV_TARGET
{
	float n = NoiseTexture.Sample(gm_BaseTexture, In.TexCoord).r * 1.2f;
	
	return gm_BaseTextureObject.Sample(gm_BaseTexture, In.TexCoord) * abs(sin(time * 0.02f * n));
}