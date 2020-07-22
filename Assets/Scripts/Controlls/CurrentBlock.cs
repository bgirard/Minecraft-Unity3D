using System;
using UnityEngine;
using UnityEngine.UI;

public class CurrentBlock : MonoBehaviour
{
        private Transform tf;
        public Text text;

        public Vector3 offset = Vector3.zero;
        
        private void Start()
        {
                tf = GetComponent<Transform>();
        }

        private void LateUpdate()
        {
                var position = tf.position;
                //get the terrain chunk (can't just use collider)
                int chunkPosX = Mathf.FloorToInt((position.x + offset.x) / 16f) * 16;
                int chunkPosZ = Mathf.FloorToInt((position.z + offset.z) / 16f) * 16;

                ChunkPos cp = new ChunkPos(chunkPosX, chunkPosZ);
                
                int bix = Mathf.FloorToInt(position.x + offset.x) - chunkPosX;
                int biy = Mathf.FloorToInt(position.y + offset.y);
                int biz = Mathf.FloorToInt(position.z + offset.z) - chunkPosZ;

                text.text = "" + TerrainGenerator.getBlock(cp, bix, biy, biz);

                /*if (Input.GetKeyDown(KeyCode.LeftControl))
                {
                        TerrainGenerator.updateChunk(cp, (blocks, updateBlock) =>
                        {
                                updateBlock(bix+1, biy, biz+1, BlockType.Dirt);
                        });   
                }*/
        }
}