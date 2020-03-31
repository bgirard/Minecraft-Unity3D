using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using UnityEngine;

public class TerrainChunkGenerator {
    public static HashSet<ChunkPos> requestedChunk = new HashSet<ChunkPos>();
    public static Dictionary<ChunkPos, TerrainChunk> chunkBlocks = new Dictionary<ChunkPos, TerrainChunk>();

    public static TerrainChunk request(ChunkPos pos, bool instant) {
        lock(chunkBlocks) {
            if (chunkBlocks.ContainsKey(pos)) {
                return chunkBlocks[pos];
            } else if (!requestedChunk.Contains(pos)) {
                Monitor.PulseAll(chunkBlocks);
                requestedChunk.Add(pos);
            }
            if (instant) {
                TerrainChunk chunk = new TerrainChunk(pos);
                chunk.PopulateOffthread();
                chunkBlocks[pos] = chunk;
                return chunk;
            }
            return null;
        }
    }

    public static void Start() {
        SpawnThread();
        SpawnThread();
        SpawnThread();
        SpawnThread();
    }
    static void SpawnThread() {
        Thread thread = new Thread(() => {
            while (true) {
                Nullable<ChunkPos> toCompute = null;
                lock(chunkBlocks) {
                    if (requestedChunk.Count == 0) {
                        Monitor.Wait(chunkBlocks);
                        continue;
                    }
                    ChunkPos pos = requestedChunk.First();
                    requestedChunk.Remove(pos);
                    if (chunkBlocks.ContainsKey(pos)) {
                        Monitor.PulseAll(chunkBlocks);
                        continue;
                    } else {
                        Monitor.PulseAll(chunkBlocks);
                        toCompute = pos;
                    }
                }
                TerrainChunk chunk = new TerrainChunk(toCompute.Value);
                chunk.PopulateOffthread();
                lock(chunkBlocks) {
                    chunkBlocks[toCompute.Value] = chunk;
                    Monitor.PulseAll(chunkBlocks);
                }

            }

        });
        thread.Start();
    }
}