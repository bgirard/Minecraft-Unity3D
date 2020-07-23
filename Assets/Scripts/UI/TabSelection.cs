using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//To switch between tabs in the UI.
//Call SwitchTab() to select one from tabs array.
public class TabSelection : MonoBehaviour
{
    public int startTab = 0;
    public UISaveMode uiSaveMode = UISaveMode.GameSessionDuration;

    public GameObject[] tabs;
    private int currentTab = 0;
    private bool firstStart = true;
    
    
    private void OnEnable()
    {
        if (uiSaveMode == UISaveMode.None)
        {
            currentTab = startTab;
            Local();
        }
        else if (uiSaveMode == UISaveMode.GameSessionDuration)
        {
            if (firstStart)
            {
                firstStart = false;
                currentTab = startTab;
                Local();
            }
        }
        else if(uiSaveMode == UISaveMode.FullSerialization)
        {
            if(firstStart)
                throw new NotImplementedException();
        }
    }

    public void SwitchTab(int index)
    {
        currentTab = index;
        Local();
    }

    private void Local()
    {
        int length = tabs.Length;
        if (length <= 0 || length < currentTab)
        {
            throw new Exception("TabSelection currentTab index out of range, please, check TabSelection settings in Inspector.");
        }
        
        for (int i = 0; i < length; i++)
        {
            tabs[i].SetActive(false);
        }
        tabs[currentTab].SetActive(true);
    }

    private void OnDisable()
    {
        if (uiSaveMode == UISaveMode.FullSerialization)
        {
            //TODO
        }
    }
}
