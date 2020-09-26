/*
 * File: HiddingPlace.cs
 * File Created: Tuesday, 22nd September 2020 1:25:16 pm
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
    public class HiddingPlace : MonoBehaviour
    {
        [SerializeField] private int maxOccupation;
        private List<ArtificialIntelligence.IntelligentAgent> hiddenAgents = new List<ArtificialIntelligence.IntelligentAgent>();
        private int currentOccupation;
        private ArtificialIntelligence.Room ownerRoom;

        [SerializeField] private float chanceToRevealPosition;
        private float distanceToExitRoom;

        private void Awake() 
        {
            Transform t = transform.parent;
            while (t.GetComponent<ArtificialIntelligence.Room>() == null)
            {
                t = transform.parent;
            }
            ownerRoom = t.GetComponent<ArtificialIntelligence.Room>();
            ownerRoom.AddHiddingPlace(this); 
        }

        public bool IsAvailable() => currentOccupation < maxOccupation;
        
        public float GetOccupationRate() => (float) currentOccupation / (float) maxOccupation;

        public float GetChanceToRevealPosition() => chanceToRevealPosition;
        
        public float SetDistanceToExitRoom(float distance) => distanceToExitRoom = distance;

        public float GetDistanceToExitRoom() => distanceToExitRoom;

        public void SetOwnerRoom(ArtificialIntelligence.Room room) => ownerRoom = room;

        public ArtificialIntelligence.Room GetOwnerRoom() => ownerRoom;

        public void AddAgent(ArtificialIntelligence.IntelligentAgent agent) 
        {
          if(!hiddenAgents.Contains(agent))
          {
            hiddenAgents.Add(agent);
            ++currentOccupation;
          }         
        }

        public void RemoveAgent(ArtificialIntelligence.IntelligentAgent agent)
        {
          if(hiddenAgents.Contains(agent))
          {
            hiddenAgents.Remove(agent);
            --currentOccupation;
          }
        }
          

        public List<ArtificialIntelligence.IntelligentAgent> GetHiddenAgents() => hiddenAgents;

        public int GetMaxOccupation() => maxOccupation;
        public int GetCurrentOccupation() => currentOccupation;

        /**
        @brief Use the hidding place revealing the position or not
        */
        public void Use()
        {         
          float random = Random.Range (0.0f, 1.0f);
          if(random < chanceToRevealPosition)
          {
            var agents = HiveManager.singletonInstance.GetAgents();
            
            foreach (ArtificialIntelligence.IntelligentAgent agent in agents)
            {
              if(agent.GetCurrentRoom() != ownerRoom)
              {
                agent.SetSuspicionLocation(ownerRoom);
              }
            }

            // TODO: Play Sound effect

          }
        }
    }

}
