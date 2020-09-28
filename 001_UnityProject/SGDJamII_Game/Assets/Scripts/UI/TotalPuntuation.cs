using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TotalPuntuation : MonoBehaviour
{
    public TextMeshPro puntText;
    // Start is called before the first frame update
    void Start()
    {
      puntText.text = string.Format("Total Caughts: {0} \n Total Saved: {1}", 
            PlayerPrefs.GetInt("TotalCaught"), PlayerPrefs.GetInt("TotalSaved"));
    }

    
}
