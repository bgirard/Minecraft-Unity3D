using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainModifier : MonoBehaviour
{
    public LayerMask groundLayer;

    public Inventory inv;

    float maxDist = 32;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        bool leftClick = Input.GetMouseButtonDown(0);
        bool rightClick = Input.GetMouseButtonDown(1);
        RaycastHit hitInfo;
        if (Physics.Raycast(transform.position, transform.forward, out hitInfo, maxDist, groundLayer))
        {
            var selection = GameObject.Find("BlockSelection");
            if (selection != null)
            {
                var selectionPoint = hitInfo.point + transform.forward * .01f; //move a little inside the block
                selection.transform.position = new Vector3(Mathf.FloorToInt(selectionPoint.x), Mathf.FloorToInt(selectionPoint.y), Mathf.FloorToInt(selectionPoint.z));
            }
            Vector3 pointInTargetBlock;
            if (leftClick || rightClick)
            {

                //destroy
                if (rightClick)
                {
                    pointInTargetBlock = hitInfo.point + transform.forward * .01f; //move a little inside the block
                }
                else
                {
                    pointInTargetBlock = hitInfo.point - transform.forward * .01f;
                }
                //get the terrain chunk (can't just use collider)
                int chunkPosX = Mathf.FloorToInt(pointInTargetBlock.x / 16f) * 16;
                int chunkPosZ = Mathf.FloorToInt(pointInTargetBlock.z / 16f) * 16;

                ChunkPos cp = new ChunkPos(chunkPosX, chunkPosZ);

                TerrainGenerator.updateChunk(cp, (blocks, updateBlock) =>
                {
                    //index of the target block
                    int bix = Mathf.FloorToInt(pointInTargetBlock.x) - chunkPosX + 1;
                    int biy = Mathf.FloorToInt(pointInTargetBlock.y);
                    int biz = Mathf.FloorToInt(pointInTargetBlock.z) - chunkPosZ + 1;

                    if (rightClick) //replace block with air
                    {
                        updateBlock(bix, biy, biz, BlockType.Air);

                        inv.AddToInventory(blocks[bix, biy, biz]);
                    }
                    else if (leftClick && inv.CanPlaceCur())
                    {
                        updateBlock(bix, biy, biz, inv.GetCurBlock());

                        inv.ReduceCur();
                    }
                });

            }
        }
    }
}