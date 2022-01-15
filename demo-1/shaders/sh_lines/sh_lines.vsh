struct VertexInput
{
	float3 Position : POSITION;
	float3 Normal   : NORMAL;
	float2 TexCoord : TEXCOORD;
	float4 Color    : COLOR;
};

struct VertexOutput
{
	float4 Position : SV_POSITION;
	float4 Color    : COLOR;
};

void main(in VertexInput In, out VertexOutput Out)
{
	Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(In.Position, 1.0f));
	Out.Color    = In.Color;
}