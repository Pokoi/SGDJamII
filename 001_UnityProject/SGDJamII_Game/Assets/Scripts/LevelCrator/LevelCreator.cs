using ArtificialIntelligence;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

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

    public WorldRoom[] rooms;

    public GameObject[] tiles;

    private box[,] table;

    public GameObject door;

    public NavMeshSurface navigationSurface;

    //Rooms assign
    private RoomManager roomManager;

    // Start is called before the first frame update
    void Start()
    {

        //RoomManager creation
        GameObject roomManagerGO = new GameObject("RoomManager");
        roomManager = roomManagerGO.AddComponent(typeof(RoomManager)) as RoomManager;


        GameObject aux = new GameObject("FloorLayout");


        table = new box[matrixX, matrixY];


        for (int i = 0; i < matrixX; i++)
        {
            for (int j = 0; j < matrixY; j++)
            {
                //ASUMIMOS QUE LA LONGUTID DE TODOS LOS TILES ES 1
                GameObject g = Instantiate(tiles[Random.Range(0, tiles.Length)], new Vector3(i, 0, j), Quaternion.identity);
                table[i, j].mapCell = g;
                g.transform.parent = aux.transform;
                g.layer = LayerMask.NameToLayer("NavMeshSurface");
                table[i, j].cell = Cells.Empty;
            }
        }

        foreach (WorldRoom r in rooms)
        {
            createRoom(r);
        }

        createCorridors(true);
        createCorridors(false);

        wallsOnCorridors();

        clearPath();

        //Generate NavMesh

        navigationSurface.BuildNavMesh();

        //Calculate distances between rooms
        CalculateRoomsDistances();

        HiveManager.singletonInstance.SetPlayerReference(GameObject.FindGameObjectWithTag("Player").gameObject.transform);

        //foreach (IntelligentAgent IA in HiveManager.singletonInstance.transform.GetComponentsInChildren<IntelligentAgent>())
        //    IA.Init();

        //HiveManager.singletonInstance.RandomizeAgentsInitialHiddingPlace();

    }

    private void CalculateRoomsDistances()
    {

        roomManager.SetGoal();

        List<ArtificialIntelligence.Room> roomsList = roomManager.GetRooms();
        int nRooms = roomsList.Count;

        List<List<float>> distanceMatrix = roomManager.GetDistanceMatrix();
        for (int x = 0; x < nRooms; x++)
        {
            distanceMatrix.Add(new List<float>());

            for (int y = 0; y < nRooms; y++)
            {
                if (x == y) //The diagonal is the distance from A to A so its 0.0f
                {
                    distanceMatrix[x].Add(0.0f);
                    continue;
                }

                float dist = GetDistanceBetweenPoints(roomsList[x].GetDoor().transform.position, roomsList[y].GetDoor().transform.position);

                if (roomsList[y].GetIsGoal())
                {
                    roomsList[x].GetDoor().SetDistanceToGoal(dist);
                }


                distanceMatrix[x].Add(dist);
            }

            var hiddingPlaces = roomsList[x].GetHiddingPlaces();

            foreach (var hp in hiddingPlaces)
            {
                hp.SetDistanceToExitRoom(GetDistanceBetweenPoints(hp.transform.position, roomsList[x].GetDoor().transform.position));
            }
        }
    }

    private float GetDistanceBetweenPoints(Vector3 origin, Vector3 target)
    {
        NavMeshPath path = new NavMeshPath();

        // Find the closest point to the target position. This is needed to avoid 
        // false "not path found" when the point is outside the navmesh

        NavMeshHit hit;
        bool b = NavMesh.SamplePosition(origin, out hit, 2.0f, NavMesh.AllAreas);
        if (b)
        { 
            origin = hit.position;
        }

        if (NavMesh.CalculatePath(origin, target, NavMesh.AllAreas, path))
        {
            float distance = 0.0f;
            Vector3[] corners = path.corners;

            for (int k = 0; k < corners.Length - 1; ++k)
            {
                distance += (corners[k] - corners[k + 1]).magnitude;
            }

            return distance;
        }

        Debug.Log("Not path found");
        return -1.0f;
    }

    private void wallsOnCorridors()
    {
        for (int i = 0; i < matrixX; i++)
            for (int j = 0; j < matrixY; j++)
            {
                if (table[i, j].cell == Cells.Corridor || table[i, j].cell == Cells.Door)
                {
                    wallsOnADy(i, j);
                }
            }
    }

    private void wallsOnADy(int i, int j)
    {
        if (i + 1 == matrixX)
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
        for (int i = 0; i < matrixX; i++)
            for (int j = 0; j < matrixY; j++)
            {
                if (table[i, j].cell == Cells.Empty)
                    DestroyImmediate(table[i, j].mapCell);
            }
    }

    private void createCorridors(bool toCenter)
    {
        foreach (Room r in roomManager.GetRooms())
        {
            WorldRoom rRoom = r.GetComponent<WorldRoom>();

            WorldRoom closestOne;

            if (toCenter)
                closestOne = FindClosestRoom(rRoom);
            else
                closestOne = rooms[0];

            if (closestOne)
            {
                var condition = AStar.Instance.Begin(0, closestOne.roomDoorX, closestOne.roomDoorY, rRoom.roomDoorX, rRoom.roomDoorY, table);

                if (condition)
                {
                    List<Node> path = AStar.Instance.getPath();

                    foreach (Node n in path)
                    {
                        //if (!(n.i_ == closestOne.roomDoorX && n.j_ == closestOne.roomDoorY) &&
                        //    !(n.i_ == r.roomDoorX && n.j_ == r.roomDoorY))
                        //{
                        table[n.i_, n.j_].occupied = true;
                        table[n.i_, n.j_].cell = Cells.Corridor;
                        if (CORRIDORMATERIAL)
                            table[n.i_, n.j_].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = CORRIDORMATERIAL;

                        //}
                    }
                }

            }
        }
    }

    private WorldRoom FindClosestRoom(WorldRoom room)
    {
        float closestDistance = float.MaxValue;
        WorldRoom closestRoom = null;

        foreach (WorldRoom r in rooms)
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

    private void createRoom(WorldRoom r)
    {
        int rndX = 0, rndY = 0;

        int maxTries = 50;

        while (maxTries-- >= 0 && !checkIfCanPlaceRoom(r, rndX, rndY))
        {
            randomPosition(ref rndX, ref rndY);

        }

        if (maxTries >= 0)
        {
            for (int i = 0; i < r.RoomSizeX; i++)
                for (int j = 0; j < r.RoomSizeY; j++)
                {
                    table[rndX + i, rndY + j].occupied = true;
                    table[rndX + i, rndY + j].cell = Cells.Room;
                    if (ROOMMATERIAL)
                        if(!r.MainRoom)
                            table[rndX + i, rndY + j].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = ROOMMATERIAL;
                        else
                            table[rndX + i, rndY + j].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = DOORMATERIAL;
                }

            r.matrixStartX = rndX;
            r.matrixStartY = rndY;

            int x = 0, y = 0;

            createDoor(ref x, ref y, rndX - 1, rndY - 1, r);

            r.roomDoorX = x;
            r.roomDoorY = y;
            table[r.roomDoorX, r.roomDoorY].cell = Cells.Door;

            if (DOORMATERIAL)
                table[r.roomDoorX, r.roomDoorY].mapCell.transform.GetChild(0).GetComponent<Renderer>().material = DOORMATERIAL;

            GameObject roomGo = Instantiate(r.gameObject, new Vector3(rndX, 0, rndY), Quaternion.identity);

            GameObject doorObject = createPhysicalDoor(roomGo, table[r.roomDoorX, r.roomDoorY].mapCell.transform.GetChild(0).gameObject);

            GameObject d = new GameObject();
            d.AddComponent<Door>();
            d.transform.position = doorObject.transform.position;
            d.transform.parent = roomGo.transform;

            Room roomComponent = roomGo.GetComponent<Room>();
            roomComponent.setDoor(d.GetComponent<Door>());

            if (doorObject.transform.childCount > 0 && doorObject.transform.GetChild(0).GetComponent<HiddingPlace>())
                roomGo.GetComponent<Room>().RemoveHiddingPlace(doorObject.transform.GetChild(0).GetComponent<HiddingPlace>());

            //doorObject.GetComponent<Renderer>().material = DOORMATERIAL;

            DestroyImmediate(doorObject);
 
            roomGo.transform.parent = roomManager.transform;
            roomComponent.RegisterRoom();
        }

        else Debug.Log("Cannot place this room, max tries reached");
    }

    private GameObject createPhysicalDoor(GameObject r, GameObject tableDoor)
    {
        int child = r.gameObject.transform.childCount;
        float closestDistance = float.MaxValue;
        GameObject closest = null;

        for (int i = 0; i < child; i++)
        {
            if (r.transform.GetChild(i).CompareTag("Wall"))
            {
                float distance = Vector3.Distance(tableDoor.transform.position, r.transform.GetChild(i).position);

                if (distance < closestDistance)
                {
                    closestDistance = distance;
                    closest = r.transform.GetChild(i).gameObject;
                }
            }
        }

        return closest;

    }

    private void createDoor(ref int x, ref int y, int rndX, int rndY, WorldRoom r)
    {
        x = Random.Range(rndX, rndX + r.RoomSizeX + 1);
        y = Random.Range(rndY, rndY + r.RoomSizeY + 1);

        int rnd = Random.Range(0, 4);

        if (rnd == 0)
            x = rndX;
        else if (rnd == 1)
            x = (rndX + r.RoomSizeX) + 1;
        else if (rnd == 2)
            y = rndY;
        else y = (rndY + r.RoomSizeY) + 1;

        if ((x == rndX && y == rndY) || (x == rndX && y == (rndY + r.RoomSizeY) + 1) ||
            (x == (rndX + r.RoomSizeX) + 1 && y == rndY) || (x == (rndX + r.RoomSizeX) + 1 && y == (rndY + r.RoomSizeY) + 1))
        {
            if (rnd == 0)
                x++;
            else if (rnd == 1)
                x--;
            else if (rnd == 2)
                y++;
            else y--;

        }

    }

    private void randomPosition(ref int x, ref int y)
    {
        x = Random.Range(0, matrixX + 1);
        y = Random.Range(0, matrixY + 1);
    }

    private bool checkIfCanPlaceRoom(WorldRoom r, int x, int y)
    {
        bool canConstruct = true;
        for (int i = -1; i < r.RoomSizeX + 1; i++)
            for (int j = -1; j < r.RoomSizeY + 1; j++)
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
