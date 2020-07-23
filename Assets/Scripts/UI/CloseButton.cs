using UnityEngine;

//Drop it on any UI that should be disabled via Closse() call.
public class CloseButton : MonoBehaviour
{
    public void Close()
    {
        gameObject.SetActive(false);
    }
}
