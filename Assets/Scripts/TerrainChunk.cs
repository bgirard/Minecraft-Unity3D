using System;
using System.Collections;
using System.Collections.Generic;
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

    public static FastNoise noise = new FastNoise();

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

    void GenerateTrig()
    {

        for (int x = 1; x < chunkWidth + 1; x++)
        {
            for (int z = 1; z < chunkWidth + 1; z++)
            {
                for (int y = 0; y < chunkHeight; y++)
                {
                    if (blocks[x, y, z] != BlockType.Air)
                    {
                        Vector3 blockPos = new Vector3(x - 1, y, z - 1);
                        int numFaces = 0;
                        //no land above, build top face
                        if (y < chunkHeight - 1 && blocks[x, y + 1, z] == BlockType.Air)
                        {
                            verts.Add(blockPos + new Vector3(0, 1, 0));
                            verts.Add(blockPos + new Vector3(0, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].topPos.GetUVs());
                        }

                        //bottom
                        if (y > 0 && blocks[x, y - 1, z] == BlockType.Air)
                        {
                            verts.Add(blockPos + new Vector3(0, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            verts.Add(blockPos + new Vector3(0, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].bottomPos.GetUVs());
                        }

                        //front
                        if (blocks[x, y, z - 1] == BlockType.Air)
                        {
                            verts.Add(blockPos + new Vector3(0, 0, 0));
                            verts.Add(blockPos + new Vector3(0, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //right
                        if (blocks[x + 1, y, z] == BlockType.Air)
                        {
                            verts.Add(blockPos + new Vector3(1, 0, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 0));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //back
                        if (blocks[x, y, z + 1] == BlockType.Air)
                        {
                            verts.Add(blockPos + new Vector3(1, 0, 1));
                            verts.Add(blockPos + new Vector3(1, 1, 1));
                            verts.Add(blockPos + new Vector3(0, 1, 1));
                            verts.Add(blockPos + new Vector3(0, 0, 1));
                            numFaces++;

                            uvs.AddRange(Block.blocks[blocks[x, y, z]].sidePos.GetUVs());
                        }

                        //left
                        if (blocks[x - 1, y, z] == BlockType.Air)
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

        float simplex = noise.GetSimplex(x * .8f, z * .8f);

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
                            if (k >= 0 && k < 16 && l >= 0 && l < 16 && m >= 0 && m < 64 && rand.NextDouble() < .8f)
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

        //print(noise.GetSimplex(x, z));
        float simplex1 = noise.GetSimplex(x * .8f, z * .8f) * 10;
        float simplex2 = noise.GetSimplex(x * 3f, z * 3f) * 10 * (noise.GetSimplex(x * .3f, z * .3f) + .5f);

        float heightMap = simplex1 + simplex2;

        //add the 2d noise to the middle of the terrain chunk
        float baseLandHeight = TerrainChunk.chunkHeight * .5f + heightMap;

        //3d noise for caves and overhangs and such
        float caveNoise1 = noise.GetPerlinFractal(x * 5f, y * 10f, z * 5f);
        float caveMask = noise.GetSimplex(x * .3f, z * .3f) + .3f;

        //stone layer heightmap
        float simplexStone1 = noise.GetSimplex(x * 1f, z * 1f) * 10;
        float simplexStone2 = (noise.GetSimplex(x * 5f, z * 5f) + .5f) * 20 * (noise.GetSimplex(x * .3f, z * .3f) + .5f);

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

        if (caveNoise1 > Mathf.Max(caveMask, .2f))
            blockType = BlockType.Air;

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