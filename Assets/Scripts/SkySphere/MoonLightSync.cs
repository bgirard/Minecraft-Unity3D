using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Light))]
[ExecuteInEditMode]
public class MoonLightSync : MonoBehaviour
{
    public Light matchThisRotation;
    public Light thisLight;
    public bool inverse = false;

    private void Update() {
        if(matchThisRotation != null && thisLight != null) {
            if(inverse) {
                this.thisLight.transform.rotation = Quaternion.Inverse(matchThisRotation.transform.rotation);
            } else {
                this.thisLight.transform.rotation = matchThisRotation.transform.rotation;
            }
        }
    }
}
