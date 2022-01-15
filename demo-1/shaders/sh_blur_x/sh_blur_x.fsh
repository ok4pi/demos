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
	float4 color = float4(0.1329062576f * gm_BaseTextureObject.Sample(gm_BaseTexture, In.TexCoord).rgb, 1.0f);
	
	color.rgb += 0.1270834220 * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x -       size, In.TexCoord.y)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x +       size, In.TexCoord.y)).rgb);
	color.rgb += 0.1109147155 * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x - 2.0 * size, In.TexCoord.y)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x + 2.0 * size, In.TexCoord.y)).rgb);
	color.rgb += 0.0884076034 * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x - 3.0 * size, In.TexCoord.y)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x + 3.0 * size, In.TexCoord.y)).rgb);
	color.rgb += 0.0643561781 * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x - 4.0 * size, In.TexCoord.y)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x + 4.0 * size, In.TexCoord.y)).rgb);
	color.rgb += 0.0427849522 * (gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x - 5.0 * size, In.TexCoord.y)).rgb + gm_BaseTextureObject.Sample(gm_BaseTexture, float2(In.TexCoord.x + 5.0 * size, In.TexCoord.y)).rgb);
	
	return color;
}