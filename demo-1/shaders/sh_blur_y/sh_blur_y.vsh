// Vertex Input
struct VertexInput
{
	float3 Position : POSITION;
	float4 Color    : COLOR;
	float2 TexCoord : TEXCOORD;
};

// Vertex Output
struct VertexOutput
{
	float4 Position : SV_POSITION;
	float2 TexCoord : TEXCOORD;
};

// Vertex Program
void main(in VertexInput In, out VertexOutput Out)
{
	Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(In.Position, 1.0f));
	Out.TexCoord = In.TexCoord;
}