using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenu : MonoBehaviour
{
    public KeyCode key = KeyCode.Escape;
    public GameObject menuUI, settingsUI;

    public static bool pause = false;
    
    private void Start()
    {
        Local();
    }

    private void Update()
    {
        if (Input.GetKeyDown(key))
        {
            if (settingsUI.activeSelf)
            {
                settingsUI.SetActive(false);
                return;
            }
            
            pause = !pause;
            Local();
            
        }
    }

    private void Local()
    {
        Cursor.visible = pause;
        menuUI.SetActive(pause);

        if (pause)
        {
            ;
        }
        else
        {
            settingsUI.SetActive(false); 
        }
    }

    public void Settings()
    {
        settingsUI.SetActive(true); 
    }

    public void Quit()
    {
        Application.Quit();
        
        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif
    }
}
