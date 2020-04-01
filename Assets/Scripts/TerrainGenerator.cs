using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unity.Profiling;
using UnityEngine;

public class TerrainGenerator : MonoBehaviour {
    public Transform player;
    public GameObject terrainChunkPrefab;

    private static Dictionary<ChunkPos, TerrainChunkObject> chunks = new Dictionary<ChunkPos, TerrainChunkObject>();

    // Start is called before the first frame update
    void Start() {
        TerrainChunkGenerator.Start();
        LoadChunks(1, true);
    }

    private void Update() {
        LoadChunks(1, true);
        LoadChunks(8);
        UnloadChunk(8);
    }

    TerrainChunkObject LoadChunk(ChunkPos cp, bool instant) {
        if (chunks.ContainsKey(cp)) {
            return chunks[cp];
        }

        TerrainChunk chunk = TerrainChunkGenerator.request(cp, instant);
        if (chunk == null) {
            return null;
        }

        int xPos = cp.x;
        int zPos = cp.z;
        GameObject chunkGO = Instantiate(terrainChunkPrefab, new Vector3(xPos, 0, zPos), Quaternion.identity);
        TerrainChunkObject chunkObject = chunkGO.GetComponent<TerrainChunkObject>();
        chunkObject.transform.parent = transform;
        chunkObject.name = "Chunk:" + cp;

        chunkObject.BuildMesh(chunk);

        WaterChunk wat = chunkObject.transform.GetComponentInChildren<WaterChunk>();
        wat.SetLocs(chunk.blocks);
        wat.BuildMesh();

        chunks.Add(cp, chunkObject);

        return chunkObject;
    }

    public static void updateChunk(ChunkPos cp, Func<TerrainChunk, bool> cb) {
        TerrainChunkObject chunkObject = chunks[cp];
        bool hasChanged = cb(chunkObject.Chunk);
        if (hasChanged) {
            chunkObject.UpdateChunk();
        }
    }

    void LoadChunks(int chunkDist, bool instant = false) {
        //the current chunk the player is in
        int curChunkPosX = Mathf.FloorToInt(player.position.x / 16) * 16;
        int curChunkPosZ = Mathf.FloorToInt(player.position.z / 16) * 16;

        for (int i = curChunkPosX - 16 * chunkDist; i <= curChunkPosX + 16 * chunkDist; i += 16) {
            for (int j = curChunkPosZ - 16 * chunkDist; j <= curChunkPosZ + 16 * chunkDist; j += 16) {
                ChunkPos cp = new ChunkPos(i, j);

                LoadChunk(cp, instant);
            }
        }

    }

    void UnloadChunk(int chunkDist) {
        int curChunkPosX = Mathf.FloorToInt(player.position.x / 16) * 16;
        int curChunkPosZ = Mathf.FloorToInt(player.position.z / 16) * 16;

        List<ChunkPos> toDestroy = new List<ChunkPos>();
        foreach (KeyValuePair<ChunkPos, TerrainChunkObject> c in chunks) {
            {
                ChunkPos cp = c.Key;
                if (Mathf.Abs(curChunkPosX - cp.x) > 16 * (chunkDist + 3) ||
                    Mathf.Abs(curChunkPosZ - cp.z) > 16 * (chunkDist + 3)) {
                    toDestroy.Add(c.Key);
                }
            }
        }

        foreach (ChunkPos cp in toDestroy) {
            {
                chunks[cp].gameObject.SetActive(false);
                Destroy(chunks[cp].gameObject);
                chunks.Remove(cp);
            }
        }
    }

}

public struct ChunkPos {
    public int x, z;
    public ChunkPos(int x, int z) {
        this.x = x;
        this.z = z;
    }

    public override string ToString() {
        return "[x=" + x + ",z=" + z + "]";
    }
}