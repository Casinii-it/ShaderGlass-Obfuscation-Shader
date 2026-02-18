#version 450

//////////////////////////////////////////////////////////////////
// you can define parameters of your shader in this section

#pragma parameter Boost "Boost" 1.0 0.0 2.0 0.1

layout(push_constant) uniform Push
{
    // built-in parameters
    vec4 SourceSize;
    vec4 OriginalSize;
    vec4 OutputSize;
    uint FrameCount;

    // your custom parameters
    float Boost;
} params;

layout(std140, set = 0, binding = 0) uniform UBO
{
    mat4 MVP;
} global;

//////////////////////////////////////////////////////////////////
// vertex shader, you usually don't need to modify it

#pragma stage vertex

layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;

void main()
{
   gl_Position = global.MVP * Position;
   vTexCoord = TexCoord;
}

//////////////////////////////////////////////////////////////////
// fragment shader is where you define per-pixel operations

#pragma stage fragment

layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D Source;


//uniform vec2 u_resolution;

void main()
{
   vec3 input_pixel = texture(Source, vTexCoord).rgb;


   const float PI = 3.14159265358979323846;
   vec2 pixel_coords = gl_FragCoord.xy;
   float value = 6000*(gl_FragCoord.x/1920 + gl_FragCoord.y/1080);

   float luminance = input_pixel.r*0.3 + input_pixel.g*0.59 + input_pixel.b*0.11;
   float new_green_val = abs(tan(value/30));
   float new_blue_val = abs(cos(value/60));
   vec3 new_pixel = vec3(luminance/1.5, new_green_val, new_blue_val);


   FragColor = vec4(new_pixel, 1.0);
}
