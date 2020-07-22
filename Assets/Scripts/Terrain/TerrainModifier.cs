using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TerrainModifier : MonoBehaviour
{
    public Text text;
    public LayerMask groundLayer;
    public Inventory inv;
    
    private float maxDist = 32;
    
    private void Start()
    {

    }
    private void Update()
    {
        bool leftClick = Input.GetMouseButtonDown(0);
        bool rightClick = Input.GetMouseButtonDown(1);
        
        RaycastHit hitInfo;
        if (Physics.Raycast(transform.position, transform.forward, out hitInfo, maxDist, groundLayer))
        {
            var selection = GameObject.Find("BlockSelection");
            if (selection != null)
            {
                //Move a little inside the block
                var selectionPoint = hitInfo.point + transform.forward * .01f; 
                selection.transform.position = new Vector3(Mathf.FloorToInt(selectionPoint.x), Mathf.FloorToInt(selectionPoint.y), Mathf.FloorToInt(selectionPoint.z));
            }
            
            Vector3 pointInTargetBlock;
            if (leftClick || rightClick)
            {

                //Destroy
                if (leftClick)
                {
                    pointInTargetBlock = hitInfo.point + transform.forward * .01f; //Move a little inside the block
                }
                else
                {
                    pointInTargetBlock = hitInfo.point - transform.forward * .01f;
                }
                
                //Get the terrain chunk (can't just use collider)
                int chunkPosX = Mathf.FloorToInt(pointInTargetBlock.x / 16f) * 16;
                int chunkPosZ = Mathf.FloorToInt(pointInTargetBlock.z / 16f) * 16;

                ChunkPos cp = new ChunkPos(chunkPosX, chunkPosZ);
                
                //Index of the target block
                int bix = Mathf.FloorToInt(pointInTargetBlock.x) - chunkPosX + 1;
                int biy = Mathf.FloorToInt(pointInTargetBlock.y);
                int biz = Mathf.FloorToInt(pointInTargetBlock.z) - chunkPosZ + 1;

                //Ensure that block could be destroyed.
                var currentBlock = TerrainGenerator.getBlock(cp, bix-1, biy, biz-1);

                text.text = $"[At cursor]\ncp: {chunkPosX} {chunkPosZ} \nb: {bix} {biy} {biz} \nt: {currentBlock}";
                
                if (currentBlock != BlockType.Core)
                {
                    TerrainGenerator.updateChunk(cp, (blocks, updateBlock) =>
                    {
                        if (leftClick) //replace block with air
                        {
                            updateBlock(bix, biy, biz, BlockType.Air);
                            selection.transform.position = Vector3.zero;
                            inv.AddToInventory(blocks[bix, biy, biz]);
                        }
                        else if (rightClick && inv.CanPlaceCur() && Vector3.Distance(hitInfo.point, transform.position) > 2f)
                        {
                            updateBlock(bix, biy, biz, inv.GetCurBlock());
                            inv.ReduceCur();
                        }
                    });
                }
            }
        }
    }
}
