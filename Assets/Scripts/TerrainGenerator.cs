using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unity.Profiling;
using UnityEngine;

public class TerrainGenerator : MonoBehaviour
{
    public Transform player;
    public GameObject terrainChunkPrefab;

    private static Dictionary<ChunkPos, TerrainChunkObject> chunks = new Dictionary<ChunkPos, TerrainChunkObject>();

    // Start is called before the first frame update
    void Start()
    {
        TerrainChunkGenerator.Start();
        LoadChunks(1, true);
    }

    private void Update()
    {
        LoadChunks(1, true);
        LoadChunks(8);
        UnloadChunk(8);
    }

    TerrainChunkObject LoadChunk(ChunkPos cp, bool instant)
    {
        if (chunks.ContainsKey(cp))
        {
            return chunks[cp];
        }

        TerrainChunk chunk = TerrainChunkGenerator.request(cp, instant);
        if (chunk == null)
        {
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

    public static BlockType getBlock(ChunkPos pos, int x, int y, int z)
    {
        while (x < 0)
        {
            x += TerrainChunk.chunkWidth;
            pos = new ChunkPos(pos.x - TerrainChunk.chunkWidth, pos.z);
        }
        while (x >= TerrainChunk.chunkWidth)
        {
            x -= TerrainChunk.chunkWidth;
            pos = new ChunkPos(pos.x + TerrainChunk.chunkWidth, pos.z);
        }
        while (z < 0)
        {
            z += TerrainChunk.chunkWidth;
            pos = new ChunkPos(pos.x, pos.z - TerrainChunk.chunkWidth);
        }
        while (z >= TerrainChunk.chunkWidth)
        {
            z -= TerrainChunk.chunkWidth;
            pos = new ChunkPos(pos.x, pos.z + TerrainChunk.chunkWidth);
        }
        if (!chunks.ContainsKey(pos))
        {
            return BlockType.Air;
        }
        TerrainChunkObject chunk = chunks[pos];
        return chunk.Chunk.blocks[x + 1, y, z + 1];
    }

    public static void updateChunk(ChunkPos cp, Action<BlockType[,,], Action<int, int, int, BlockType>> cb)
    {
        TerrainChunkObject chunkObject = chunks[cp];
        BlockType[,,] blocks = chunkObject.Chunk.blocks;
        HashSet<TerrainChunkObject> changed = new HashSet<TerrainChunkObject>();
        cb(blocks, (x, y, z, block) =>
        {
            updateChunkNearbyHelper(cp, changed, x, y, z, block);
            if (x == 1)
            {
                updateChunkNearbyHelper(new ChunkPos(cp.x - TerrainChunk.chunkWidth, cp.z), changed, TerrainChunk.chunkWidth + 1, y, z, block);
            }
            if (z == 1)
            {
                updateChunkNearbyHelper(new ChunkPos(cp.x, cp.z - TerrainChunk.chunkWidth), changed, x, y, TerrainChunk.chunkWidth + 1, block);
            }
            if (x == 1 + TerrainChunk.chunkWidth - 1)
            {
                updateChunkNearbyHelper(new ChunkPos(cp.x + TerrainChunk.chunkWidth, cp.z), changed, 0, y, z, block);
            }
            if (z == 1 + TerrainChunk.chunkWidth - 1)
            {
                updateChunkNearbyHelper(new ChunkPos(cp.x, cp.z + TerrainChunk.chunkWidth), changed, x, y, 0, block);
            }
        });
        foreach (var chunk in changed)
        {
            chunk.UpdateChunk();
        }
    }

    private static void updateChunkNearbyHelper(ChunkPos cp, HashSet<TerrainChunkObject> changed, int x, int y, int z, BlockType block)
    {
        if (!chunks.ContainsKey(cp))
        {
            Debug.Log("Not found");
            return;
        }
        chunks[cp].Chunk.blocks[x, y, z] = block;
        changed.Add(chunks[cp]);
    }

    void LoadChunks(int chunkDist, bool instant = false)
    {
        //the current chunk the player is in
        int curChunkPosX = Mathf.FloorToInt(player.position.x / 16) * 16;
        int curChunkPosZ = Mathf.FloorToInt(player.position.z / 16) * 16;

        Camera camera = player.GetComponentInChildren<Camera>();

        List<ChunkPos> highPri = new List<ChunkPos>();
        List<ChunkPos> lowPri = new List<ChunkPos>();
        for (int i = curChunkPosX - 16 * chunkDist; i <= curChunkPosX + 16 * chunkDist; i += 16)
        {
            for (int j = curChunkPosZ - 16 * chunkDist; j <= curChunkPosZ + 16 * chunkDist; j += 16)
            {
                ChunkPos cp = new ChunkPos(i, j);
                if (chunks.ContainsKey(cp))
                {
                    continue;
                }

                if (camera != null)
                {
                    var point = camera.WorldToViewportPoint(new Vector3(cp.x, 32, cp.z));
                    if (point.z > 0 && point.x >= 0 && point.x <= 1 && point.y >= 0 && point.y <= 1)
                    {
                        highPri.Add(cp);
                    }
                    else
                    {
                        lowPri.Add(cp);
                    }
                }
                else
                {
                    highPri.Add(cp);
                }
            }
        }

        foreach (var cp in highPri)
        {
            if (TerrainChunkGenerator.getRequestSize() < 5 || instant)
            {
                LoadChunk(cp, instant);
            }
        }
        foreach (var cp in lowPri)
        {
            if (TerrainChunkGenerator.getRequestSize() < 5 || instant)
            {
                LoadChunk(cp, instant);
            }
        }
    }

    void UnloadChunk(int chunkDist)
    {
        int curChunkPosX = Mathf.FloorToInt(player.position.x / 16) * 16;
        int curChunkPosZ = Mathf.FloorToInt(player.position.z / 16) * 16;

        List<ChunkPos> toDestroy = new List<ChunkPos>();
        foreach (KeyValuePair<ChunkPos, TerrainChunkObject> c in chunks)
        {
            {
                ChunkPos cp = c.Key;
                if (Mathf.Abs(curChunkPosX - cp.x) > 16 * (chunkDist + 3) ||
                    Mathf.Abs(curChunkPosZ - cp.z) > 16 * (chunkDist + 3))
                {
                    toDestroy.Add(c.Key);
                }
            }
        }

        foreach (ChunkPos cp in toDestroy)
        {
            {
                chunks[cp].gameObject.SetActive(false);
                Destroy(chunks[cp].gameObject);
                chunks.Remove(cp);
            }
        }
    }

}

public struct ChunkPos
{
    public int x, z;
    public ChunkPos(int x, int z)
    {
        this.x = x;
        this.z = z;
    }

    public override string ToString()
    {
        return "[x=" + x + ",z=" + z + "]";
    }
}