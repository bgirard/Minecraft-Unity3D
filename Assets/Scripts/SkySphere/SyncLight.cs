using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SyncLight : MonoBehaviour
{
    public Light source;
    public Light target;
  

    void Update()
    {
        target.intensity = source.intensity;
        target.color = source.color;
        target.transform.rotation = source.transform.rotation;
    }

}
