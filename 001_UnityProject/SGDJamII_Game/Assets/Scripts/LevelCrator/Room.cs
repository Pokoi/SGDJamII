using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Room : MonoBehaviour
{
    public int RoomSizeX, RoomSizeY;

    [HideInInspector]
    public int roomDoorX, roomDoorY;

    [HideInInspector]
    public int matrixStartX, matrixStartY;

    [HideInInspector]
    public bool connected = false;


}
