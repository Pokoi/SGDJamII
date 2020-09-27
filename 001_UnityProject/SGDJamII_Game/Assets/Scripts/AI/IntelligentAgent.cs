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
    public class IntelligentAgent : MessageSystem.Listener
    {
        ArtificialIntelligence.Room suspicionLocation;
        ArtificialIntelligence.Room currentRoom;
        ArtificialIntelligence.HiddingPlace currentHiddingPlace;
        ArtificialIntelligence.Locomotion locomotor;
        ArtificialIntelligence.DecisionMaker thinker;   

        MeshRenderer meshRenderer;
        CapsuleCollider collider;

        [System.Serializable]
        public struct Psychology
        {
            public float changeRoomWeight;
            public float changeHiddingPlaceWeight;
            public float waitingWeight;
            public float searchingHiddingPlaceWeight;
        }

        [SerializeField]
        public IntelligentAgent.Psychology psychology;    


        public void Init() 
        {
            locomotor = GetComponent<ArtificialIntelligence.Locomotion>();
            locomotor.Init();

            MessageSystem.Dispatcher.singletonInstance.AddListener(this, "slowEnemy");
            MessageSystem.Dispatcher.singletonInstance.AddListener(this, "speedUpEnemy");
            MessageSystem.Dispatcher.singletonInstance.AddListener(this, "changeSpot");

            thinker = GetComponent<ArtificialIntelligence.DecisionMaker>();
            transform.parent.GetComponent<ArtificialIntelligence.HiveManager>().AddAgent(this);
            meshRenderer = transform.GetComponentInChildren<MeshRenderer>();
            collider = transform.GetComponent<CapsuleCollider>();            

            psychology.changeRoomWeight = Random.Range(0.0f, 0.1f);
            psychology.changeHiddingPlaceWeight = Random.Range(0.5f, 1.0f);
            psychology.waitingWeight = Random.Range(0.7f, 1.0f);
            psychology.searchingHiddingPlaceWeight = Random.Range(0.9f, 1.0f); 
            


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
            if (!suspicionLocation)
            {  
                var rooms = ArtificialIntelligence.RoomManager.singletonInstance.GetRooms();
                int maxRoom = rooms.Count;           

                int roomIndex = Random.Range(0, maxRoom);
                suspicionLocation = rooms[roomIndex];
            }
            
            return suspicionLocation;
        } 

        public void SetCurrentRoom(ArtificialIntelligence.Room room) => currentRoom = room;

        public ArtificialIntelligence.Room GetCurrentRoom() => currentRoom;

        public void SetCurrentHiddingPlace(ArtificialIntelligence.HiddingPlace hp) => currentHiddingPlace = hp;

        public ArtificialIntelligence.HiddingPlace GetCurrentHiddingPlace() => currentHiddingPlace;        

        public IntelligentAgent.Psychology GetPsychology() => psychology;

        public ArtificialIntelligence.DecisionMaker GetThinker() => thinker;

        public void ResetCurrentHiddingPlace() => currentHiddingPlace = null;

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

        private void OnCollisionEnter(Collision other) 
        {
            if(other.gameObject.CompareTag("Player"))
            {
               Death();
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
                currentHiddingPlace.Use();
                currentHiddingPlace.AddAgent(this);
                collider.enabled = false;
            }
        }

        /**
        @brief Reveals the agent
        */
        public void Unhide()
        {
            meshRenderer.enabled = true;
            collider.enabled = true;

            if(currentHiddingPlace)
            {
                currentHiddingPlace.RemoveAgent(this);                              
                collider.enabled = true;
            }
        }
       
        /**
        @brief Method called when the agent reach the goal
        */
        public void AtGoal()
        {
            // DO SOMETHNG
            Hide();
            locomotor.Inactivate();
            GameManager.Instance.EnemySaved();
            gameObject.SetActive(false);
        }

        /**
        @brief Method called when the enemy dies
        */
        public void Death()
        {
            Hide();
            locomotor.Inactivate();
            GameManager.Instance.EnemyCaught();
            gameObject.SetActive(false);
            //Debug.Log ("He morido :c");

        }

        /**
        @brief Handle the messages
        */
        public override void Handle(string tag)
        {
            if (tag == "slowEnemy")
            {
                locomotor.Slow();
            }
            else if (tag == "speedUpEnemy")
            {
                locomotor.SpeedUp();
            }
            else if (tag == "changeSpot")
            {
                locomotor.SetDestination(thinker.ChooseDestinyRoom());            
            }
        }

    }

}
