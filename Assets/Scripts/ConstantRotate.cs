using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ConstantRotate : MonoBehaviour
{

    public Vector3 speed;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.rotation *= Quaternion.AngleAxis(speed.x * Time.deltaTime, Vector3.right) * Quaternion.AngleAxis(speed.y * Time.deltaTime, Vector3.up) * Quaternion.AngleAxis(speed.z * Time.deltaTime, Vector3.forward);
    }
}
