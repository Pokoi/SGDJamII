using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum Cells { Room, Corridor, Door, Empty }; // tipo de las celdas que utilizaremos

// cada casilla del mapa es una box, 
// tiene el GO que saldra en el editor y la informacion del tipo
public struct box
{
    public Cells cell;
    public GameObject mapCell;
    public bool occupied;
}

public class LevelCreator : MonoBehaviour
{

    public Material CORRIDORMATERIAL, ROOMMATERIAL, DOORMATERIAL;

    public int matrixX, matrixY;

    public Room[] rooms;

    public GameObject[] tiles;

    private box[,] table;

    // Start is called before the first frame update
    void Start()
    {
        GameObject aux = new GameObject();

        table = new box[matrixX, matrixY];


        for (int i = 0; i < matrixX; i++)
        {
            for (int j = 0; j < matrixY; j++)
            {
                //ASUMIMOS QUE LA LONGUTID DE TODOS LOS TILES ES 1
                GameObject g = Instantiate(tiles[Random.Range(0, tiles.Length)], new Vector3(i, 0, j), Quaternion.identity);
                table[i, j].mapCell = g;
                g.transform.parent = aux.transform;
                table[i, j].cell = Cells.Empty;
            }
        }

        foreach (Room r in rooms)
        {
            createRoom(r);
        }

        createCorridors();

        wallsOnCorridors();

        clearPath();

    }

    private void wallsOnCorridors()
    {
        for (int i = 0; i < matrixX; i++)
            for (int j = 0; j < matrixY; j++)
            {
                if (table[i, j].cell == Cells.Corridor)
                {
                    table[i, j].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = CORRIDORMATERIAL;
                    wallsOnADy(i, j);
                }
            }
    }

    private void wallsOnADy(int i, int j)
    {
        if(i + 1 == matrixX)
            table[i, j].mapCell.GetComponent<Tile>().SouthhWall.SetActive(true);
        else if (table[i + 1, j].cell == Cells.Empty)
            table[i, j].mapCell.GetComponent<Tile>().SouthhWall.SetActive(true);

        if (i - 1 < 0)
            table[i, j].mapCell.GetComponent<Tile>().NorthWall.SetActive(true);

        else if (table[i - 1, j].cell == Cells.Empty)
            table[i, j].mapCell.GetComponent<Tile>().NorthWall.SetActive(true);

        if (j + 1 == matrixY)
            table[i, j].mapCell.GetComponent<Tile>().EastWall.SetActive(true);
        else if (j + 1 < matrixY && table[i, j + 1].cell == Cells.Empty)
            table[i, j].mapCell.GetComponent<Tile>().EastWall.SetActive(true);

        if (j - 1 < 0)
            table[i, j].mapCell.GetComponent<Tile>().WesthWall.SetActive(true);

        else if (table[i, j - 1].cell == Cells.Empty)
            table[i, j].mapCell.GetComponent<Tile>().WesthWall.SetActive(true);

    }

    private void clearPath()
    {
        //for (int i = 0; i < matrixX; i++)
        //    for (int j = 0; j < matrixY; j++)
        //    {
        //        if (!table[i, j].occupied)
        //            Destroy(table[i, j].mapCell);
        //    }
    }

    private void createCorridors()
    {
        foreach (Room r in rooms)
        {
            Room closestOne = FindClosestRoom(r);
            if (closestOne)
            {
                if(AStar.Instance.Begin(0, closestOne.roomDoorX, closestOne.roomDoorY, r.roomDoorX, r.roomDoorY, table))
                {
                    List<Node> path = AStar.Instance.getPath();
                    foreach (Node n in path)
                    {
                        if (!(n.i_ == closestOne.roomDoorX && n.j_ == closestOne.roomDoorY) &&
                            !(n.i_ == r.roomDoorX && n.j_ == r.roomDoorY))
                        {
                            table[n.i_, n.j_].occupied = true;
                            table[n.i_, n.j_].cell = Cells.Corridor;
                            
                        }
                    }
                }
            }
        }
    }

    private Room FindClosestRoom(Room room)
    {
        float closestDistance = Mathf.Infinity;
        Room closestRoom = null;

        foreach (Room r in rooms)
        {
            if (r != room)
            {
                float distance = Vector3.Distance(r.gameObject.transform.position, room.gameObject.transform.position);
                if (distance < closestDistance)
                {
                    closestDistance = distance;
                    closestRoom = r;
                }
            }
        }

        return closestRoom;
    }

    private void createRoom(Room r)
    {
        int rndX = 0, rndY = 0;

        int maxTries = 50;

        while (maxTries-- >= 0 && !checkIfCanPlaceRoom(r, rndX, rndY))
        {
            randomPosition(ref rndX, ref rndY);
        }

        if (maxTries-- >= 0)
        {
            for (int i = 0; i < r.RoomSizeX; i++)
                for (int j = 0; j < r.RoomSizeY; j++)
                {
                    table[rndX + i, rndY + j].occupied = true;
                    table[rndX + i, rndY + j].cell = Cells.Room;
                    table[rndX + i, rndY + j].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = ROOMMATERIAL;
                }

            r.matrixStartX = rndX;
            r.matrixStartY = rndY;

            int x = 0, y = 0;
            maxTries = 50;

            bool worked = false;

            while (maxTries-- >= 0 && !worked)
            {
                createDoor(ref x, ref y, rndX, rndY, r);

                if(x == rndX || x == rndX + r.RoomSizeX || y == rndY || y == r.roomDoorY)
                {
                    worked = true;
                }
            }

            if (worked)
            {
                r.roomDoorX = x;
                r.roomDoorY = y;
                Debug.Log("Worked door creation");
            }

            else
            {
                r.roomDoorX = rndX;
                r.roomDoorY = rndY;
                Debug.Log("Didnt work door creation, default position");
            }

            table[r.roomDoorX, r.roomDoorY].cell = Cells.Door;
            table[r.roomDoorX, r.roomDoorY].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = DOORMATERIAL;


            Instantiate(r.gameObject, new Vector3(rndX, 0, rndY), Quaternion.identity);
        }

        else Debug.Log("Cannot place this room, max tries reached");
    }

    private void createDoor(ref int x, ref int y, int rndX, int rndY, Room r)
    {
        x = Random.Range(rndX, rndX + r.RoomSizeX);
        y = Random.Range(rndY, rndY + r.RoomSizeY);
    }

    private void randomPosition(ref int x, ref int y)
    {
        x = Random.Range(0, matrixX + 1);
        y = Random.Range(0, matrixY + 1);
    }

    private bool checkIfCanPlaceRoom(Room r, int x, int y)
    {
        bool canConstruct = true;
        for (int i = 0; i < r.RoomSizeX; i++)
            for (int j = 0; j < r.RoomSizeY; j++)
            {
                if (x + i > matrixX - 2 || y + j > matrixY - 2 || x + i <= 0 || y + j <= 0 || table[x + i, y + j].occupied)
                {
                    canConstruct = false;
                    break;
                }
            }

        return canConstruct;
    }
}
