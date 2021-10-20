//
//  shader.metal
//  SoundAndARStudy
//
//  Created by mio kato on 2021/10/20.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct VertexInput
{
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal) ]];
    float3 color [[ attribute(SCNVertexSemanticColor) ]];
    float2 texcoord [[ attribute(SCNVertexSemanticTexcoord0) ]];
};

struct ColorInOut
{
    float4 position [[ position ]];
    float brightness;
};

struct NodeBuffer
{
    float4x4 modelViewTransform;
    float4x4 modelViewProjectionTransform;
    float4x4 normalTransform;
};

vertex ColorInOut vertexShader(VertexInput in [[ stage_in ]],
                               constant SCNSceneBuffer& scn_frame [[ buffer(0) ]],
                               constant NodeBuffer& scn_node [[ buffer(1) ]])
{
    ColorInOut out;
    // ビュー視点でのモデルの頂点
    out.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    float3 modelSpaceNormal = in.normal.xyz;
    float4 eyeSpacePosition = scn_node.modelViewTransform * float4(in.position, 1.0);
    float3 eyeSpaceNormal = (scn_node.normalTransform * float4(in.normal, 0.0)).xyz;
    float3 eyeSpaceViewVector = normalize(-eyeSpacePosition.xyz);
    // 光の位置
    float3 sunVector = normalize(float3(2, 2, 2));
    // カメラからの視点
    float3 viewVec = normalize(eyeSpaceViewVector);
    // カメラ視点の法線
    float3 normal = normalize(eyeSpaceNormal);
    // オブジェクトの明るさs
    float brightness = dot(sunVector, normal);
    out.brightness = brightness;
    
    return out;
}

fragment float4 fragmentShader(ColorInOut in [[ stage_in ]])
{
    float3 c = float3(in.brightness) * 0.5;
    float3 env = float3(0.2);
    c += env;

    return float4(c, 1.0);
}
