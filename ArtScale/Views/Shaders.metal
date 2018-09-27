//
//  Shaders.metal
//  ArtScale
//
//  Created by Douglas Soo on 9/26/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float4x4 modelMatrix;
};

struct VertexIn {
    packed_float3 position;
};
struct VertexOut {
    float4 position [[position]];
    float4 color;
};
vertex VertexOut vertex_main(device const VertexIn *vertices [[buffer(0)]],
                             device const Uniforms& uniforms [[buffer(1)]],
                             uint vertexId [[vertex_id]]) {
    float4x4 mvMatrix = uniforms.modelMatrix;
    
    VertexOut out;
    out.position = mvMatrix * float4(vertices[vertexId].position, 1);
    out.color = float4(1, 1, 1, 1);
    return out;
}
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
