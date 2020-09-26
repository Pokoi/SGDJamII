using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldRoom : MonoBehaviour
{
    public int RoomSizeX, RoomSizeY;
    public bool MainRoom = false;
    [HideInInspector]
    public int roomDoorX, roomDoorY;

    [HideInInspector]
    public int matrixStartX, matrixStartY;

    [HideInInspector]
    public bool connected = false;


}
