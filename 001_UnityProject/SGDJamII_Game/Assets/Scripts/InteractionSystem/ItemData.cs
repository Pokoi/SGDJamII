using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[CreateAssetMenu(fileName = "ItemData", menuName = "InteractableObjects/Item")]
public class ItemData : ScriptableObject
{
    #region Data
    [SerializeField] string objectName = "";
    #endregion

    #region Properties
    public string ObjectName
    {
        get => objectName;
        set => objectName = value;
    }
    #endregion
}
