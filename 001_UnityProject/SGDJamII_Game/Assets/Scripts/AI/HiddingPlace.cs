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
    public class HiddingPlace : MonoBehaviour
    {
        [SerializeField] private int maxOccupation;
        private List<IntelligentAgent> hiddenAgents = new List<IntelligentAgent>();
        private int currentOccupation;
        private Room ownerRoom;

        private float chanceToRevealPosition;
        private float distanceToExitRoom;

        public bool IsAvailable() => currentOccupation < maxOccupation;
        
        public float GetOccupationRate() => (float) currentOccupation / (float) maxOccupation;

        public float GetChanceToRevealPosition() => chanceToRevealPosition;
        
        public float SetDistanceToExitRoom(float distance) => distanceToExitRoom = distance;

        public float GetDistanceToExitRoom() => distanceToExitRoom;

        public void SetOwnerRoom(Room room) => ownerRoom = room;

        public Room GetOwnerRoom() => ownerRoom;

        public void AddAgent(IntelligentAgent agent) => hiddenAgents.Add(agent);

        public void RemoveAgent(IntelligentAgent agent) => hiddenAgents.Remove(agent);

        public List<IntelligentAgent> GetHiddenAgents() => hiddenAgents;

        public int GetMaxOccupation() => maxOccupation;
        public int GetCurrentOccupation() => currentOccupation;
    }

}
