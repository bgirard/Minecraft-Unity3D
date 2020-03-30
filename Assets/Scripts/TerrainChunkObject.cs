using System.Collections;
using System.Collections.Generic;
using UnityEngine;

class TerrainChunkObject : MonoBehaviour
{
    public Mesh BuildMesh(TerrainChunk chunk)
    {
        Mesh mesh = new Mesh();

        mesh.vertices = chunk.getVerts().ToArray();
        mesh.triangles = chunk.getTris().ToArray();
        mesh.uv = chunk.getUVs().ToArray();

        mesh.RecalculateNormals();
        GetComponent<MeshFilter>().mesh = mesh;
        GetComponent<MeshCollider>().sharedMesh = mesh;
        return mesh;
    }
}