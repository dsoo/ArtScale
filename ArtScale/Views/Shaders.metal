//
//  Shaders.metal
//  ArtScale
//
//  Created by Douglas Soo on 9/26/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    packed_float3 position;
    packed_float3 color;
};
struct VertexOut {
    float4 position [[position]];
    float4 color;
};
vertex VertexOut vertex_main(device const VertexIn *vertices [[buffer(0)]],
                             uint vertexId [[vertex_id]]) {
    VertexOut out;
    out.position = float4(vertices[vertexId].position, 1);
    out.color = float4(vertices[vertexId].color, 1);
    return out;
}
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
    }
