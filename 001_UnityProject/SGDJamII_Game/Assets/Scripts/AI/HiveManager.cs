using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ArtificialIntelligence
{        
    public class HiveManager : MonoBehaviour
    {
        private List<ArtificialIntelligence.IntelligentAgent> agents = new List<ArtificialIntelligence.IntelligentAgent>();
        public static ArtificialIntelligence.HiveManager singletonInstance;

        [SerializeField] private Transform player;

        private void Awake() 
        {
            if(singletonInstance == null)
            {
                singletonInstance = this;
            }
            else
            {
                Destroy(this);
            }    
        }
        
        public void AddAgent(ArtificialIntelligence.IntelligentAgent agent) => agents.Add(agent);
        public List<ArtificialIntelligence.IntelligentAgent> GetAgents() => agents;

        /**
        @brief Randomize the initial hidding place of each agent
        */
        public void RandomizeAgentsInitialHiddingPlace()
        {
            var rooms = ArtificialIntelligence.RoomManager.singletonInstance.GetRooms();
            int maxRoom = rooms.Count;
            var hiddingPlaces = new List<ArtificialIntelligence.HiddingPlace>();

            int roomIndex = 0;
            int maxHiddingPlace = 0;
            int hiddingPlaceIndex = 0;

            foreach(ArtificialIntelligence.IntelligentAgent agent in agents)
            {
                do
                {
                    do
                    {
                        roomIndex = Random.Range(0, maxRoom);
                    } while(rooms[roomIndex].GetIsGoal());

                    hiddingPlaces = rooms[roomIndex].GetHiddingPlaces();
                    maxHiddingPlace = hiddingPlaces.Count;

                    hiddingPlaceIndex = Random.Range(0, maxHiddingPlace);

                } while (!hiddingPlaces[hiddingPlaceIndex].IsAvailable());

                agent.SetOnRandomHiddingPlace(hiddingPlaces[hiddingPlaceIndex]);
            }

        }

        public Transform GetPlayerReference() => player;        
    }

}