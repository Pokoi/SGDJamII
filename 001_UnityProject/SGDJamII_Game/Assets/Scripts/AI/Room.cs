/*
 * File: Room.cs
 * File Created: Tuesday, 22nd September 2020 1:23:51 pm
 * ––––––––––––––––––––––––
 * Author: Jesus Fermin, 'Pokoi', Villar  (hello@pokoidev.com)
 * ––––––––––––––––––––––––
 * MIT License
 * 
 * Copyright (c) 2020 Pokoidev
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ArtificialIntelligence
{   
    [RequireComponent (typeof(BoxCollider))] 
    public class Room : MonoBehaviour
    {
        [SerializeField] private bool isGoal;
        [SerializeField] private List<ArtificialIntelligence.HiddingPlace> hiddingPlaces = new List<ArtificialIntelligence.HiddingPlace>();
        [SerializeField] private ArtificialIntelligence.Door door;      

        public float GetDistanceToGoal() => door.GetDistanceToGoal();

        public int GetHiddingPlacesCount() => hiddingPlaces.Count;  

        public List<ArtificialIntelligence.HiddingPlace> GetHiddingPlaces() => hiddingPlaces;  

        public void AddHiddingPlace(ArtificialIntelligence.HiddingPlace hp) => hiddingPlaces.Add(hp);

        public void RemoveHiddingPlace(ArtificialIntelligence.HiddingPlace hp) => hiddingPlaces.Remove(hp);

        public ArtificialIntelligence.Door GetDoor() => door;

        public void setDoor(ArtificialIntelligence.Door d) => door = d;

        public bool GetIsGoal() => isGoal;

        public void RegisterRoom() => transform.parent.GetComponent<ArtificialIntelligence.RoomManager>().AddRoom(this);

        private void OnTriggerEnter(Collider other) 
        {
            if(other.gameObject.CompareTag("Player"))
            {
                var playerListener = other.GetComponent<MessageSystem.PlayerListener>();
                if (playerListener)
                { 
                    if (playerListener.GetExposed())
                    { 
                        PlayerAlert();                       
                    }
                    else 
                    {
                        playerListener.SetExposed(true);
                    }
                }
            }
        }

        /**
        @brief Event dispatched when the player enters a room to alarm all the AI agents in this room
        */
        private void PlayerAlert()
        {
            foreach (ArtificialIntelligence.HiddingPlace hp in hiddingPlaces)
            {
                var agents = hp.GetHiddenAgents();
                foreach(ArtificialIntelligence.IntelligentAgent agent in agents)
                {
                    agent.SetSuspicionLocation(this);
                }
            }
        }

    }
}

