/*
 * File: IntelligentAgent.cs
 * File Created: Tuesday, 22nd September 2020 3:22:10 pm
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
    [RequireComponent (typeof(ArtificialIntelligence.Locomotion))]
    public class IntelligentAgent : MonoBehaviour
    {
        ArtificialIntelligence.Room suspicionLocation;
        ArtificialIntelligence.Room currentRoom;
        ArtificialIntelligence.HiddingPlace currentHiddingPlace;
        ArtificialIntelligence.Locomotion locomotor;
        ArtificialIntelligence.DecisionMaker thinker;   

        MeshRenderer meshRenderer;

        public struct Psychology
        {
            public float changeRoomWeight;
            public float changeHiddingPlaceWeight;
            public float waitingWeight;
            public float searchingHiddingPlaceWeight;
        }

        private IntelligentAgent.Psychology psychology;    


        private void Start() 
        {
            locomotor = GetComponent<ArtificialIntelligence.Locomotion>();
            thinker = GetComponent<ArtificialIntelligence.DecisionMaker>();
            transform.parent.GetComponent<ArtificialIntelligence.HiveManager>().AddAgent(this);
            meshRenderer = transform.GetComponentInChildren<MeshRenderer>();

            psychology.changeRoomWeight = Random.Range(0.0f, 1.0f);
            psychology.changeHiddingPlaceWeight = Random.Range(0.0f, 1.0f);
            psychology.waitingWeight = Random.Range(0.0f, 1.0f);
            psychology.searchingHiddingPlaceWeight = Random.Range(0.0f, 1.0f);     

        }

        /**
        @brief Sets the ai agent into a given hidding place
        @param hiddingPlace The hidding place where hide this agent
        */
        public void SetOnRandomHiddingPlace(ArtificialIntelligence.HiddingPlace hiddingPlace)
        {
            currentHiddingPlace = hiddingPlace;
            currentRoom = hiddingPlace.GetOwnerRoom();

            var component = locomotor.GetNavMeshAgent();
            component.enabled = false;
            
            transform.position = hiddingPlace.transform.position;

            component.enabled = true;

            //locomotor.GetNavMeshAgent().Warp(hiddingPlace.transform.position);
            locomotor.SetDestination(transform.position);
            Hide();        
            locomotor.Activate();

        }

        public void SetSuspicionLocation(ArtificialIntelligence.Room room) => suspicionLocation = room;
        public ArtificialIntelligence.Room GetSuspicionLocation() 
        {
            
            // FOR DEBUG PURPOSES ONLY:
            var rooms = ArtificialIntelligence.RoomManager.singletonInstance.GetRooms();
            int maxRoom = rooms.Count;           

            int roomIndex = Random.Range(0, maxRoom);
            suspicionLocation = rooms[roomIndex];

            ArtificialIntelligence.HiveManager.singletonInstance.GetPlayerReference().position = suspicionLocation.GetDoor().transform.position;
            
            return suspicionLocation;
        } 

        public void SetCurrentRoom(ArtificialIntelligence.Room room) => currentRoom = room;

        public ArtificialIntelligence.Room GetCurrentRoom() => currentRoom;

        public void SetCurrentHiddingPlace(ArtificialIntelligence.HiddingPlace hp) => currentHiddingPlace = hp;

        public ArtificialIntelligence.HiddingPlace GetCurrentHiddingPlace() => currentHiddingPlace;        

        public IntelligentAgent.Psychology GetPsychology() => psychology;

        public ArtificialIntelligence.DecisionMaker GetThinker() => thinker;

        private void OnTriggerEnter(Collider other) 
        {
            if(other.gameObject.CompareTag("HiddingPlace"))
            {
                currentHiddingPlace = other.transform.GetComponent<ArtificialIntelligence.HiddingPlace>();
            }
            else if(other.gameObject.CompareTag("Room"))
            {
                currentRoom = other.transform.GetComponent<ArtificialIntelligence.Room>();
            }            
        }

        /**
        @brief Hides the agent
        */
        public void Hide()
        {
            if(currentHiddingPlace.IsAvailable())
            {
                meshRenderer.enabled = false;
                currentHiddingPlace.AddAgent(this);
            }
        }

        /**
        @brief Reveals the agent
        */
        public void Unhide()
        {
            meshRenderer.enabled = true;
            currentHiddingPlace.RemoveAgent(this);
        }
       
        /**
        @brief Method called when the agent reach the goal
        */
        public void AtGoal()
        {
            // DO SOMETHNG
        }


    }

}
