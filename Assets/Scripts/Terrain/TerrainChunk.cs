using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Unity.Profiling;
using UnityEngine;

public class TerrainChunk
{
    public ChunkPos pos;
    //chunk size
    public const int chunkWidth = 16;
    public const int chunkHeight = 64;

    //0 = air, 1 = land
    public BlockType[,,] blocks = new BlockType[chunkWidth + 2, chunkHeight, chunkWidth + 2];
    List<Vector3> verts = new List<Vector3>();
    List<int> tris = new List<int>();
    List<Vector2> uvs = new List<Vector2>();

    public static FastNoise noise1 = new FastNoise(1337);
    public static FastNoise noise2 = new FastNoise(1338);

    public TerrainChunk(ChunkPos pos)
    {
        this.pos = pos;
    }

    public void PopulateOffthread()
    {
        GenerateBlocks();
        GenerateTrees();
        GenerateTrig();
    }

    public void UpdateTrig()
    {
        GenerateTrig();
    }

    public void RefreshBlocks()
    {
        using (new ProfilerMarker("RefreshBlocks").Auto())
        {
            for (int x = 0; x < chunkWidth + 2; x++)
            {
                for (int z = 0; z < chunkWidth + 2; z++)
                {
                    for (int y = 0; y < chunkHeight; y++)
                    {
                        BlockType block = TerrainGenerator.getBlock(pos, x - 1, y, z - 1);
                        blocks[x, y, z] = block;
                    }
                }
            }
        }
    }

    bool Transparent(BlockType bt)
    {
        if (bt == BlockType.Air || bt == BlockType.Water)
            return true;
        else
        {
            return false;
        }
    }
    
    void GenerateTrig()
    {
        verts = new List<Vector3>();
        tris = new List<int>();
        uvs = new List<Vector2>();
        for (int x = 1; x < chunkWidth + 1; x++)
        {
            for (int z = 1; z < chunkWidth + 1; z++)
            {
                for (int y = 0; y < chunkHeight; y++)
                {
                    var current = blocks[x, y, z];
                    if (current != BlockType.Air && current != BlockType.Water)
                    {
                        Vector3 blockPos = new Vector3(x - 1, y, z - 1);
                        int numFaces = 0;
                        //no land above, build top face
                        if (y < chunkHeight - 1 && Transparent(blocks[x, y + 1, z]))
                        {
                            verts.Add(blockPos + new Vector3(0, 1, 0));
                            verts.Add(blockPos + new Vector3(0, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].topPos.GetUVs());
                        }

                        //bottom
                        if (y > 0 && Transparent(blocks[x, y - 1, z]))
                        {
                            verts.Add(blockPos + new Vector3(0, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            verts.Add(blockPos + new Vector3(0, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].bottomPos.GetUVs());
                        }

                        //front
                        if (Transparent(blocks[x, y, z - 1]))
                        {
                            verts.Add(blockPos + new Vector3(0, 0, 0));
                            verts.Add(blockPos + new Vector3(0, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //right
                        if (Transparent(blocks[x + 1, y, z]))
                        {
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //back
                        if (Transparent(blocks[x, y, z + 1]))
                        {
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(0, 1, 1));
                            verts.Add(blockPos + new Vector3(0, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //left
                        if (Transparent(blocks[x - 1, y, z]))
                        {
                            verts.Add(blockPos + new Vector3(0, 0, 1));
                            verts.Add(blockPos + new Vector3(0, 1, 1));
                            verts.Add(blockPos + new Vector3(0, 1, 0));
                            verts.Add(blockPos + new Vector3(0, 0, 0));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        int tl = verts.Count - 4 * numFaces;
                        for (int i = 0; i < numFaces; i++)
                        {
                            tris.AddRange(new int[] { tl + i * 4, tl + i * 4 + 1, tl + i * 4 + 2, tl + i * 4, tl + i * 4 + 2, tl + i * 4 + 3 });
                            //uvs.AddRange(Block.blocks[BlockType.Grass].topPos.GetUVs());

                        }
                    }
                }
            }
        }
    }

    void GenerateBlocks()
    {
        for (int x = 0; x < TerrainChunk.chunkWidth + 2; x++)
        {
            for (int z = 0; z < TerrainChunk.chunkWidth + 2; z++)
            {
                for (int y = 0; y < TerrainChunk.chunkHeight; y++)
                {
                    //if(Mathf.PerlinNoise((xPos + x-1) * .1f, (zPos + z-1) * .1f) * 10 + y < TerrainChunk.chunkHeight * .5f)
                    blocks[x, y, z] = GetBlockType(pos.x + x - 1, y, pos.z + z - 1);
                }
            }
        }
    }

    void GenerateTrees()
    {
        int x = pos.x;
        int z = pos.z;
        System.Random rand = new System.Random(x * 10000 + z);

        float simplex = noise1.GetSimplex(x * .8f, z * .8f);

        if (simplex > 0)
        {
            simplex *= 2f;
            int treeCount = Mathf.FloorToInt((float)rand.NextDouble() * 5 * simplex);

            for (int i = 0; i < treeCount; i++)
            {
                int xPos = (int)(rand.NextDouble() * 14) + 1;
                int zPos = (int)(rand.NextDouble() * 14) + 1;

                int y = TerrainChunk.chunkHeight - 1;
                //find the ground
                while (y > 0 && blocks[xPos, y, zPos] == BlockType.Air)
                {
                    y--;
                }

                //if under the tree is grass - make it to just dirt.
                if (blocks[xPos, y, zPos] == BlockType.Grass)
                {
                    blocks[xPos, y, zPos] = BlockType.Dirt;
                }
                
                y++;

                int treeHeight = 4 + (int)(rand.NextDouble() * 4);

                for (int j = 0; j < treeHeight; j++)
                {
                    if (y + j < 64)
                        blocks[xPos, y + j, zPos] = BlockType.Trunk;
                }

                int leavesWidth = 1 + (int)(rand.NextDouble() * 6);
                int leavesHeight = (int)(rand.NextDouble() * 3);

                int iter = 0;
                for (int m = y + treeHeight - 1; m <= y + treeHeight - 1 + treeHeight; m++)
                {
                    for (int k = xPos - (int)(leavesWidth * .5) + iter / 2; k <= xPos + (int)(leavesWidth * .5) - iter / 2; k++)
                        for (int l = zPos - (int)(leavesWidth * .5) + iter / 2; l <= zPos + (int)(leavesWidth * .5) - iter / 2; l++)
                        {
                            if (k > 0 && k < 16 && l > 0 && l < 16 && m >= 0 && m < 64 && rand.NextDouble() < .8f)
                                blocks[k, m, l] = BlockType.Leaves;
                        }

                    iter++;
                }

            }
        }
    }

    //get the block type at a specific coordinate
    BlockType GetBlockType(int x, int y, int z)
    {
        /*if(y < 33)
            return BlockType.Dirt;
        else
            return BlockType.Air;*/

        //Core block placement at the bottom.
        if (y <= 1)
        {
            float simplexCore = noise1.GetSimplex(x * 30f, z * 30f) * 1;
            //Debug.Log(simplexCore);
            int coreLevel = simplexCore > 0 ? 1 : 0;
            
            if (y <= coreLevel) return BlockType.Core;
        }

        //print(noise.GetSimplex(x, z));
        float simplex1 = noise1.GetSimplex(x * .8f, z * .8f) * 10;
        float simplex2 = noise1.GetSimplex(x * 3f, z * 3f) * 10 * (noise1.GetSimplex(x * .3f, z * .3f) + .5f);

        float heightMap = simplex1 + simplex2;

        //add the 2d noise to the middle of the terrain chunk
        float baseLandHeight = TerrainChunk.chunkHeight * .5f + heightMap;

        //stone layer heightmap
        float simplexStone1 = noise1.GetSimplex(x * 1f, z * 1f) * 10;
        float simplexStone2 = (noise1.GetSimplex(x * 5f, z * 5f) + .5f) * 20 * (noise1.GetSimplex(x * .3f, z * .3f) + .5f);

        float stoneHeightMap = simplexStone1 + simplexStone2;
        float baseStoneHeight = TerrainChunk.chunkHeight * .25f + stoneHeightMap;

        //float cliffThing = noise.GetSimplex(x * 1f, z * 1f, y) * 10;
        //float cliffThingMask = noise.GetSimplex(x * .4f, z * .4f) + .3f;

        BlockType blockType = BlockType.Air;
        //under the surface, dirt block
        if (y <= baseLandHeight)
        {
            blockType = BlockType.Dirt;

            //just on the surface, use a grass type
            if (y > baseLandHeight - 1 && y > WaterChunk.waterHeight - 2)
                blockType = BlockType.Grass;

            if (y <= baseStoneHeight)
                blockType = BlockType.Stone;
        }

        //3d noise for caves and overhangs and such
        float xz = x + z;
        float yy = y * 0.577350269189626f;
        float s2 = xz * -0.211324865405187f + yy;
        float xr = x + s2;
        float zr = z + s2;
        float yr = xz * -0.577350269189626f + yy;

        float caveNoise1 = noise1.GetPerlin(xr * 5f, yr * 10f, zr * 5f);
        float caveNoise2 = noise1.GetPerlin(xr * 5f + 128.5f / 0.01f, yr * 10f + 128.5f / 0.01f, zr * 5f + 128.5f / 0.01f);
        float caveValue = caveNoise1 * caveNoise1 + caveNoise2 * caveNoise2;

        if (caveValue < 0.01)
        {
            blockType = BlockType.Air;
        }

        /*if(blockType != BlockType.Air)
            blockType = BlockType.Stone;*/

        //if(blockType == BlockType.Air && noise.GetSimplex(x * 4f, y * 4f, z*4f) < 0)
        //  blockType = BlockType.Dirt;

        //if(Mathf.PerlinNoise(x * .1f, z * .1f) * 10 + y < TerrainChunk.chunkHeight * .5f)
        //    return BlockType.Grass;

        return blockType;
    }

    void AddSquare(List<Vector3> verts, List<int> tris)
    {

    }

    public List<Vector3> getVerts()
    {
        return verts;
    }

    public List<int> getTris()
    {
        return tris;
    }

    public List<Vector2> getUVs()
    {
        return uvs;
    }
}