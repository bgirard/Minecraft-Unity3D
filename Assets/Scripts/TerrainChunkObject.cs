using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

class TerrainChunkObject : MonoBehaviour {
    private TerrainChunk chunk = null;

    public TerrainChunk Chunk { get => chunk; set => chunk = value; }

    public Mesh BuildMesh(TerrainChunk chunk) {
        this.chunk = chunk;
        Mesh mesh = new Mesh();

        mesh.vertices = chunk.getVerts().ToArray();
        mesh.triangles = chunk.getTris().ToArray();
        mesh.uv = chunk.getUVs().ToArray();

        mesh.RecalculateNormals();
        GetComponent<MeshFilter>().mesh = mesh;
        GetComponent<MeshCollider>().sharedMesh = mesh;
        return mesh;
    }

    public void UpdateChunk() {
        chunk.UpdateTrig();
        BuildMesh(chunk);
    }
}