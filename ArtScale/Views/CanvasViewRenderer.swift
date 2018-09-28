//
//  CanvasViewRenderer.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/26/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import MetalKit
import CleanroomLogger
import simd

struct Uniforms {
    var modelViewMatrix: float4x4
}

struct Primitive {
    let start: Int
    let length: Int
}

class CanvasViewRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let mtkView: MTKView
    let canvasViewModel: CanvasViewModel

    private var uniformBuffer: MTLBuffer?
    private var vertexBuffer: MTLBuffer?
    private var primitives: [Primitive]
    private var screenProjectionMatrix = matrix_float4x4()

    let commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!

    init(view: MTKView, device: MTLDevice, canvasViewModel: CanvasViewModel) {
        self.mtkView = view
        self.canvasViewModel = canvasViewModel

        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Could not load default library from main bundle")
        }

        do {
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
            pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
            pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            Log.error?.message("Exception while building pipeline!")
        }

        self.uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * 16)
        self.primitives = []
        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateProjection(width: Float(size.width), height: Float(size.height))
    }

    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else { return }

        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

        encoder.setRenderPipelineState(pipelineState)
        for primitive in primitives {
            encoder.drawPrimitives(type: .lineStrip, vertexStart: primitive.start, vertexCount: primitive.length)
        }
        encoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }

    func updateProjection(width: Float, height: Float) {
        screenProjectionMatrix = matrix_float4x4(columns: (simd_float4(x: Float(4.0/width), y: 0.0, z: 0.0, w: 0.0),
                                                           simd_float4(x: 0.0, y: Float(-4.0/height), z: 0.0, w: 0.0),
                                                           simd_float4(x: 0.0, y: 0.0, z: 1, w: 0),
                                                           simd_float4(x: -1.0, y: 1.0, z: 0.0, w: 1)))
        let bufferPointer = uniformBuffer!.contents()
        memcpy(bufferPointer, &screenProjectionMatrix, MemoryLayout<Float>.size * 16)
    }

    func updateVertexData() {
        // Canvas data has been updated. Regenerate all vertex data
        let renderedStrokes = canvasViewModel.renderedStrokes
        var vertexData: [Float] = []

        primitives = []
        var offset = 0
        for stroke in renderedStrokes {
            for point in stroke.points {
                vertexData.append(Float(point.x))
                vertexData.append(Float(point.y))
                vertexData.append(0.0)
            }
            primitives.append(Primitive(start: offset, length: stroke.points.count))
            offset += stroke.points.count
        }

        vertexBuffer = device.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.stride)
    }
}
