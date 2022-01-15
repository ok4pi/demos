struct PixelInput
{
	float4 Position : SV_POSITION;
	float4 Color    : COLOR;
};

float4 main(in PixelInput In) : SV_TARGET
{
	return In.Color;
}