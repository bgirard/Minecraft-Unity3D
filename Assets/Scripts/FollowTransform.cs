using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowTransform : MonoBehaviour
{
    public AxisMode axisMode = AxisMode.Full;
    public Transform target;
    private Transform tf;
    
    private void Start()
    {
        tf = GetComponent<Transform>();
    }

    private void Update()
    {
        if (axisMode == AxisMode.Full)
        {
            tf.position = target.position;
        }
        else if (axisMode == AxisMode.XZ)
        {
            var temp = target.position;
            temp.y = tf.position.y;
            
            tf.position = temp;
        }
        
        
    }
    
    public enum AxisMode
    {
        Full,
        XZ
    }
}
