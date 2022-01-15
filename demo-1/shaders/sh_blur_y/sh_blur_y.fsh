// Pixel Input
struct PixelInput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD;
};

// Pixel Uniforms
uniform float size;

// Pixel Program
float4 main(in PixelInput In) : SV_TARGET
{
	float4 color = float4(2.0f * 0.1329062576f * gm_BaseTextureObject.Sample(gm_BaseTexture, In.TexCoord).rgb, 1.0f);
	
	color.rgb += 2.0f * 0.1270834220f * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y -       size)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y +       size)).rgb);
	color.rgb += 2.0f * 0.1109147155f * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y - 2.0 * size)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y + 2.0 * size)).rgb);
	color.rgb += 2.0f * 0.0884076034f * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y - 3.0 * size)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y + 3.0 * size)).rgb);
	color.rgb += 2.0f * 0.0643561781f * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y - 4.0 * size)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y + 4.0 * size)).rgb);
	color.rgb += 2.0f * 0.0427849522f * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y - 5.0 * size)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x, In.TexCoord.y + 5.0 * size)).rgb);
	
	return color;
}